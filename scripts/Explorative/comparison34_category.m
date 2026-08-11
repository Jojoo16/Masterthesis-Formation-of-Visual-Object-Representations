
%% Exploratory Analysis: Comparison of Category between day 3 and day 4 (Infants) - Plotting
% -------------------------------------------------------------------
% Author:       Johanna Fiege
% Date:         11.08.2026
% Project:      Master's Thesis — Formation of Neural Object Representations

%% Settings

clear; close all; clc

projectRoot = '...\Masterthesis-Formation-of-Visual-Object-Representations';
addpath(genpath(projectRoot));

input_folder  = fullfile(projectRoot, 'results', 'DA_mean', 'Infants_100', 'cat');
res           = fullfile(projectRoot, 'results', 'stats', 'Infants_100');
output_folder = fullfile(projectRoot, 'results', 'Plots', 'Infants_100');

subjects_4 = {'23_2', '24_2', '25_2', '26_2', '27_2', '33_2', '37_2', '38_2', '40_2', '42_2'};
subjects_3 = {'23_1', '24_1', '25_1', '26_1', '27_1', '33_1', '37_1', '38_1', '40_1', '42_1'}

%--------------------------------------------------------------------------
%% Category representation day 3
% Loading subject data, including decoding accuracy matrices of all subjects
[data, DA_all_3] = load_subjects(input_folder, subjects_3);

% Computing DA_avg (mean decoding accuracy), timeCourse, timeCourse_sub, time_mean and time_sem
cat_3 = compute_timecourse(DA_all_3);

% Loading results, p-values
cat = load(fullfile(res, 'results_cat.mat'));
res_3 = cat.tbl_sub(ismember(cat.tbl_sub.ID, subjects_3), :);

% Peak Accuracy and Latency
time = -1000:2:2498;
idx0 = find(time >= 0, 1, 'first');
time_post   = time(idx0:end);
[peak_acc3, rel3_idx] = max(cat_3.time_mean(idx0:end));
peak_idx3 = idx0 + rel3_idx - 1;
peakLat_3 = time(peak_idx3);
peakAcc_3 = peak_acc3;

fprintf('Peak decoding accuracy Day 3: %.2f%% at %.0f ms\n', peakAcc_3, peakLat_3);

res_catcomp = struct();
res_catcomp.peakLat3 = peakLat_3;
res_catcomp.peakAcc3 = peakAcc_3;

%% Category representation day 4

[data, DA_all_4] = load_subjects(input_folder, subjects_4);

cat_4 = compute_timecourse(DA_all_4);

res_4 = cat.tbl_sub(ismember(cat.tbl_sub.ID, subjects_4), :);

% Peak Accuracy and Latency
idx0 = find(time >= 0, 1, 'first');
time_post   = time(idx0:end);
[peak_acc4, rel4_idx] = max(cat_4.time_mean(idx0:end));
peak_idx4 = idx0 + rel4_idx - 1;
peakLat_4 = time(peak_idx4);
peakAcc_4 = peak_acc4;

fprintf('Peak decoding accuracy Day 4: %.2f%% at %.0f ms\n', peakAcc_4, peakLat_4);

res_catcomp.peakLat4 = peakLat_4;
res_catcomp.peakAcc4 = peakAcc_4;

%--------------------------------------------------------------------------
%% Plotting time Course
purple = [0.55 0.35 0.75];
orange = [0.85 0.45 0.20];


orange_fill = [0.95 0.75 0.60];
purple_fill = [0.80 0.70 0.90];

figure(1);
hold on
timePoints = -1000:2:2498;

f1 = fill([timePoints fliplr(timePoints)], ...
         [ (cat_4.time_mean-cat_4.time_sem)' fliplr((cat_4.time_mean+cat_4.time_sem)') ], ...
         purple_fill, ...
         'EdgeColor', 'none', ...
         'FaceAlpha', 0.4);
     
f2 = fill([timePoints fliplr(timePoints)], ...
         [ (cat_3.time_mean-cat_3.time_sem)' fliplr((cat_3.time_mean+cat_3.time_sem)') ], ...
         orange_fill, ...
         'EdgeColor', 'none', ...
         'FaceAlpha', 0.4);

    
    
    h1 = plot(timePoints, cat_4.time_mean,  'Color', purple, 'LineWidth', 2);
    h2 = plot(timePoints, cat_3.time_mean, 'Color', orange, 'LineWidth', 2);
    

    
    box off;
    xlim([-200,2000]);
    ylim([30 80]);
    xlabel('Time (ms)'); 
    ylabel('Decoding accuracy (%)');
%     title('Time course of category decoding in Infants');
    legend([h1 h2], {'Day 4', 'Day 3'})
    
    
    hChance = yline(50, '--k', 'LineWidth', 1.5);
    hZero   = xline(0, '--k', 'LineWidth', 1.5);
    
    hChance.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hZero.Annotation.LegendInformation.IconDisplayStyle = 'off';
    f1.Annotation.LegendInformation.IconDisplayStyle = 'off';
    f2.Annotation.LegendInformation.IconDisplayStyle = 'off';
    
    set(gca,'FontSize',12)
    
    hold off
    
    % Set figure position and size
    rectFig = get(gcf,'position');
    width=700;
    height=300;
    set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
    
%--------------------------------------------------------------------------    
%% Mean Accuracy

m4 = mean(res_4.PeakAccuracy)
m3 = mean(res_3.PeakAccuracy)
        
res_catcomp.mean3 = m3;
res_catcomp.mean4 = m4;

%--------------------------------------------------------------------------
%% saving results


savefig(figure(1), fullfile(output_folder, 'comparison_34_cat.fig'));
saveas(figure(1), fullfile(output_folder, 'comparison_34_cat.png'));
save(fullfile(res, 'catcomp_infants.mat'), 'res_catcomp');


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
