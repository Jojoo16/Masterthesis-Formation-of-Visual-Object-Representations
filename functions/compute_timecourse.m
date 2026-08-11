function results = compute_timecourse(DA_all)

results.DA_avg = mean(DA_all,4);

results.timeCourse = squeeze(nanmean(nanmean(results.DA_avg,1),2));

results.timeCourse_sub = squeeze(nanmean(nanmean(DA_all,1),2)); % individual decoding curves per subject

results.time_mean = mean(results.timeCourse_sub, 2); % group average curve

results.time_sem  = std(results.timeCourse_sub, 0, 2) / sqrt(size(results.timeCourse_sub,2)); % standard error across subjects

end