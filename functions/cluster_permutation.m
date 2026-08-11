function cluster_corr = cluster_permutation(timeCourse_sub, time, chance, num_permutations, p_threshold, num_clusters, cluster_alpha)


% timeCourse_sub   : time x subjects matrix of subject-level decoding values
% time             : time vector
% chance           : chance level, e.g. 50 or 0.5
% num_permutations : number of sign permutations, e.g. 5000
% p_threshold      : cluster-forming p threshold, e.g. 0.05
% num_clusters     : maximum number of observed clusters to test, default inf
% cluster_alpha    : corrected cluster-level alpha, default 0.05
%
% OUTPUT
% cluster_corr contains observed t-values, clusters, cluster p-values,
% t-sums, and the max-cluster permutation distribution.

if nargin < 7 || isempty(cluster_alpha)
    cluster_alpha = 0.05;
end
if nargin < 6 || isempty(num_clusters)
    num_clusters = inf;
end
if nargin < 5 || isempty(p_threshold)
    p_threshold = 0.05;
end
if nargin < 4 || isempty(num_permutations)
    num_permutations = 10^4;
end
if nargin < 3
    error('Not enough input arguments.');
end

if ~ismatrix(timeCourse_sub)
    error('timeCourse_sub must be a 2-D matrix: time x subjects.');
end

[num_data_points, num_subjects] = size(timeCourse_sub);

if numel(time) ~= num_data_points
    error('Length of time must match the first dimension of timeCourse_sub.');
end
if num_subjects < 2
    error('At least two subjects are required.');
end

% Difference from chance. The one-sample test is performed against zero
data = timeCourse_sub - chance;

% In each permutation, each subject-level time course can be sign-flipped
max_num_permutations = 2^num_subjects;
if num_permutations > max_num_permutations
    warning('With %d subjects, only %d sign permutations are possible. Using this value instead of %d.', ...
        num_subjects, max_num_permutations, num_permutations);
    num_permutations = max_num_permutations;
end

% One-sided right-tail threshold
t_threshold = tinv(1 - p_threshold, num_subjects - 1);

% PRODUCE PERMUTATION VECTORS
if num_permutations < max_num_permutations / 1000
    permutation_vectors = round(rand(num_subjects, num_permutations)) * 2 - 1;
else
    permutation_vectors = NaN(num_subjects, num_permutations);
    rndB = dec2bin(randperm(max_num_permutations, num_permutations) - 1);
    nBits = size(rndB, 2);
    if nBits < num_subjects
        rndB(:, (num_subjects - nBits + 1):num_subjects) = rndB;
        rndB(:, 1:num_subjects - nBits) = '0';
    end
    for ii = 1:numel(permutation_vectors)
        permutation_vectors(ii) = str2double(rndB(ii)) * 2 - 1;
    end
end

% RUN PRIMARY TEST
t_value_vector = simpleTTest(data', 0)';
t_value_vector(~isfinite(t_value_vector)) = 0;

[cluster_idx_primary, t_sum_primary] = findPositiveClusters1D(t_value_vector, t_threshold);

% Sort observed clusters by cluster mass
[t_sum_primary, t_sum_sort_idx] = sort(t_sum_primary, 'descend');
cluster_idx_primary = cluster_idx_primary(t_sum_sort_idx);

% RUN PERMUTATIONS
permutation_distribution = zeros(num_permutations, 1);

for p = 1:num_permutations
    D = bsxfun(@times, data', permutation_vectors(:, p));
    t_perm = simpleTTest(D, 0)';
    t_perm(~isfinite(t_perm)) = 0;

    [~, t_sum_perm] = findPositiveClusters1D(t_perm, t_threshold);

    if isempty(t_sum_perm)
        permutation_distribution(p) = 0;
    else
        permutation_distribution(p) = max(t_sum_perm);
    end
end

% DETERMINE SIGNIFICANCE
num_tested_clusters = min(num_clusters, numel(t_sum_primary));
clusters = cell(1, num_tested_clusters);
p_values = ones(1, num_tested_clusters);

for clustIdx = 1:num_tested_clusters
    ii = sum(permutation_distribution >= t_sum_primary(clustIdx));
    clusters{clustIdx} = cluster_idx_primary{clustIdx};
    p_values(clustIdx) = (ii + 1) / (num_permutations + 1);
end

cluster_start_idx = NaN(num_tested_clusters, 1);
cluster_end_idx = NaN(num_tested_clusters, 1);
cluster_start_time = NaN(num_tested_clusters, 1);
cluster_end_time = NaN(num_tested_clusters, 1);

for clustIdx = 1:num_tested_clusters
    cluster_start_idx(clustIdx) = clusters{clustIdx}(1);
    cluster_end_idx(clustIdx) = clusters{clustIdx}(end);
    cluster_start_time(clustIdx) = time(cluster_start_idx(clustIdx));
    cluster_end_time(clustIdx) = time(cluster_end_idx(clustIdx));
end

cluster_corr.time = time(:);
cluster_corr.chance = chance;
cluster_corr.n_subjects = num_subjects;
cluster_corr.n_permutations = num_permutations;
cluster_corr.cluster_forming_p = p_threshold;
cluster_corr.cluster_alpha = cluster_alpha;
cluster_corr.t_threshold = t_threshold;

cluster_corr.tvals = t_value_vector(:);
cluster_corr.clusters = clusters;
cluster_corr.p_values = p_values(:);
cluster_corr.t_sums = t_sum_primary(:);
cluster_corr.permutation_distribution = permutation_distribution;

cluster_corr.cluster_start_idx = cluster_start_idx;
cluster_corr.cluster_end_idx = cluster_end_idx;
cluster_corr.cluster_start_time = cluster_start_time;
cluster_corr.cluster_end_time = cluster_end_time;
cluster_corr.sig_clusters = p_values(:) < cluster_alpha;

end

function [clusters, t_sums] = findPositiveClusters1D(t_values, t_threshold)
above_threshold = t_values(:) > t_threshold;
edges = diff([false; above_threshold; false]);
cluster_start = find(edges == 1);
cluster_end = find(edges == -1) - 1;

clusters = cell(1, numel(cluster_start));
t_sums = zeros(numel(cluster_start), 1);

for i = 1:numel(cluster_start)
    clusters{i} = cluster_start(i):cluster_end(i);
    t_sums(i) = sum(t_values(clusters{i}));
end
end

function [t, df] = simpleTTest(x, m)
% Fast one-sample t-test returning only t-values and degrees of freedom.
% Rows are observations, columns are variables.

if nargin < 1
    error('Requires at least one input argument.');
end
if nargin < 2
    m = 0;
end

samplesize = size(x, 1);
xmean = sum(x) / samplesize;

xc = bsxfun(@minus, x, xmean);
xstd = sqrt(sum(conj(xc) .* xc, 1) / (samplesize - 1));

ser = xstd ./ sqrt(samplesize);
t = (xmean - m) ./ ser;
df = samplesize - 1;
end
