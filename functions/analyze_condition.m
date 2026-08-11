function analyze_condition(input_folder, output_folder, subjects, output_prefix, chance)

%   input_folder  - folder containing the DA data files for this condition
%   output_folder - folder to save results into (created if it doesn't exist)
%   subjects      - cell array of subject IDs to include
%   output_prefix - prefix used for output filenames
%   chance        - chance level, default = 50


if nargin < 5
    chance = 50;
end

%% Load data
[data, DA_all] = load_subjects(input_folder, subjects);

%% Extract statistics
results = extract_decoding_stats(DA_all, chance);

%% Permutation
perm_results = cluster_permutation(results.timeCourse_sub, results.time, chance, 5000, 0.05, inf, 0.05);

sigC = find(perm_results.p_values < 0.05);
if isempty(sigC)
    fprintf('[%s] No cluster survived permutation correction (alpha = 0.05).\n', output_prefix);
else
    for i = 1:length(sigC)
        c = sigC(i);
        fprintf('[%s] SIGNIFICANT cluster %d: %.0f-%.0f ms, p_cluster = %.4f\n', ...
            output_prefix, c, ...
            perm_results.cluster_start_time(c), ...
            perm_results.cluster_end_time(c), ...
            perm_results.p_values(c));
    end
end

sigIdx = perm_results.p_values < 0.05;
perm_results.ClusterStart = perm_results.cluster_start_time(sigIdx);
perm_results.ClusterEnd   = perm_results.cluster_end_time(sigIdx);
perm_results.Clusterp     = perm_results.p_values(sigIdx);

%% Create tables
[tbl_sub, tbl_group] = create_results_tables(data, results);

%% Save
if ~isfolder(output_folder)
    mkdir(output_folder);
end

save(fullfile(output_folder, [output_prefix '.mat']), 'tbl_sub', 'tbl_group', 'results', 'perm_results');
writetable(tbl_sub,   fullfile(output_folder, [output_prefix '_sub.csv']));
writetable(tbl_group, fullfile(output_folder, [output_prefix '_group.csv']));

end
