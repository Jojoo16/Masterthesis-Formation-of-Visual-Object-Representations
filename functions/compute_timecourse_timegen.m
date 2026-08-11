function results = compute_timecourse_timegen(DA_all)

results.DA_avg = mean(DA_all,5);

results.timeCourse = squeeze(nanmean(nanmean(results.DA_avg,1),2));

results.timeCourse_sub = squeeze(nanmean(nanmean(DA_all,1),2)); % individual decoding curves per subject

results.time_mean = mean(results.timeCourse_sub, 3); % group average curve

results.time_sem  = std(results.timeCourse_sub, 0, 3) / sqrt(size(results.timeCourse_sub,3)); % standard error across subjects

end