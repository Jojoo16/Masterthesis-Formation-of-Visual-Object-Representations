function [tbl_sub, tbl_group] = create_results_tables(data, results)

nSub = length(data);

IDs = {data.ID}';

Subject = (1:nSub)';

tbl_sub = table(Subject, IDs, results.peakAcc, results.peakLat, results.sigMeanAcc, 'VariableNames', {'Subject', 'ID' 'PeakAccuracy', 'PeakLatency_ms', 'MeanAccuracy_win'});

tbl_group = table(mean(results.sigMeanAcc), std(results.sigMeanAcc), results.mean_t, results.mean_df, results.mean_p, results.mean_ci(1), results.mean_ci(2), results.sigwin(1), results.sigwin(2), results.maxLat, results.maxAcc, results.max_t, results.max_df, results.max_p, results.max_ci(1), results.max_ci(2), 'VariableNames', {'MeanAccuracy', 'MeanSD', 'Meant', 'MeanDF', 'Meanp', 'MeanCI_lower', 'MeanCI_upper', 'SigClusterOnset', 'SigClusterOffset', 'PeakLatency', 'PeakAccuracy', 'Peakt', 'PeakDF', 'Peakp', 'PeakCI_lower', 'PeakCI_upper'});

end