function results = extract_decoding_stats(DA_all, chance)

% Extracting statistics across subjects and timepoints

timeCourse_sub = squeeze(nanmean(nanmean(DA_all,1),2)); % individual decoding curves per subject
time_mean = mean(timeCourse_sub, 2); % group average curve
time_sem  = std(timeCourse_sub, 0, 2) / sqrt(size(timeCourse_sub,2)); % standard error across subjects
time = -1000:2:2498;
results.time = time;
results.timeCourse_sub = timeCourse_sub;
results.time_mean = time_mean;

nSub = size(timeCourse_sub,2);

%% Group Statistics

nTime = length(time);
tvals = zeros(nTime,1);
pvals = zeros(nTime,1);

for t = 1:nTime

    [~,p,~,stats] = ttest(timeCourse_sub(t,:), chance, 'Tail', 'right');

    pvals(t) = p;
    tvals(t) = stats.tstat;

end

results.pvals = pvals;
results.tvals = tvals;

% Maximal peak decoding accuracy & latency, group level
idx0 = find(time >= 0, 1, 'first');
time_post   = time(idx0:end);
[peak_acc, rel_idx] = max(time_mean(idx0:end));
peak_idx = idx0 + rel_idx - 1;
peak_latency = time(peak_idx); %% PEAK LATENCY

results.maxAcc = peak_acc;
results.maxLat = peak_latency;

% significance of peak decoding accuracy
peak_data = timeCourse_sub(peak_idx,:);
[~,p_peak,ci_peak,stats_peak] = ttest(peak_data, chance, 'Tail','right');
t_peak = stats_peak.tstat; %% PEAK t-VALUE
df_peak = stats_peak.df;  %% PEAK df-VALUE

results.max_t = t_peak;
results.max_df = df_peak;
results.max_p = p_peak;
results.max_ci = ci_peak;

% Find significant timepoints to build cluster window
sig_idx = pvals < 0.05;
sig_post = sig_idx(idx0:end);

d = diff([0;sig_post;0]);
cluster_start = find(d==1);
cluster_end = find(d==-1)-1;

cluster_start = cluster_start + idx0 - 1;
cluster_end = cluster_end + idx0 - 1;

peak_cluster = find(cluster_start <= peak_idx & cluster_end >= peak_idx, 1);

if isempty(peak_cluster)
    onset_time = NaN;
    offset_time = NaN;
    idx_sigwin = false(size(time));
else
    onset_idx = cluster_start(peak_cluster);
    offset_idx = cluster_end(peak_cluster);
    onset_time = time(onset_idx);
    offset_time = time(offset_idx);
    idx_sigwin = time >= onset_time & time <= offset_time;
end
    

sigMeanAcc = mean(timeCourse_sub(idx_sigwin,:),1)';

results.sigMeanAcc = sigMeanAcc;
results.onset_time = onset_time;
results.offset_time = offset_time;
results.sigwin = [onset_time offset_time];

% Significance test on time window
[h,p,ci,stats] = ttest(sigMeanAcc, chance, 'Tail', 'right');

results.mean_p = p;
results.mean_t = stats.tstat;
results.mean_df = stats.df;
results.mean_ci = ci;



%% Subject peaks
peakAcc = nan(nSub,1);
peakLat = nan(nSub,1);
idx0 = find(time >= 0, 1, 'first');

for s = 1:nSub
    
    % peak decoding accuracy
    tc = timeCourse_sub(:,s);
   
    tc_post = tc(idx0:end);
    
    [peakAcc(s), rel_idx] = max(tc_post);
    
    peak_idx = idx0 +rel_idx - 1;                   % stimulus onset(0 ms) occurs at idx0 = 501, therefore subtracting 1
    
    peakLat(s) = time(peak_idx);
    
end

results.peakAcc = peakAcc;
results.peakLat = peakLat;


end