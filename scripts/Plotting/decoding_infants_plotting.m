
%% Decoding in time for Infants - Plotting
% -------------------------------------------------------------------
% Author:       Johanna Fiege
% Date:         11.08.2026
% Project:      Master's Thesis — Formation of Neural Object Representations

%% Settings

clear; close all; clc

projectRoot = '...\Masterthesis-Formation-of-Visual-Object-Representations';
addpath(genpath(projectRoot));

input_folder  = fullfile(projectRoot, 'results', 'DA_mean', 'Infants_100', 'fam');
res           = fullfile(projectRoot, 'results', 'stats', 'Infants_100');
output_folder = fullfile(projectRoot, 'results', 'Plots', 'Infants_100');

%% Load Subjects
subjects_new = {'23_2', '24_2', '25_2', '26_2', '27_2', '33_2', '37_2', '38_2', '40_2', '42_2'};
subjects_old = {'7_1', '10_1', '15_1', '17_1', '18_1', '7_2', '10_2', '15_2', '17_2', '18_2', '23_1', '24_1', '25_1', '26_1', '27_1', '33_1', '37_1', '38_1', '40_1', '42_1'};

subjects = [subjects_new, subjects_old];

%--------------------------------------------------------------------------
%% Familiar data
% Loading subject data, including decoding accuracy matrices of all subjects
[data, DA_all_fam] = load_subjects(input_folder, subjects);

% Computing DA_avg (mean decoding accuracy), timeCourse, timeCourse_sub, time_mean and time_sem
fam = compute_timecourse(DA_all_fam);

% Loading results, p-values
res_fam = load(fullfile(res, 'results_familiar.mat'));
sig_fam = res_fam.results.pvals < 0.05;
peak_fam = res_fam.results.maxLat;



%% NOVEL data
input_folder  = fullfile(projectRoot, 'results', 'DA_mean', 'Infants_100', 'novel');

[data, DA_all_nov] = load_subjects(input_folder, subjects);

nov = compute_timecourse(DA_all_nov);

res_nov = load(fullfile(res, 'results_novel.mat'));
sig_nov = res_nov.results.pvals < 0.05;
peak_nov = res_nov.results.maxLat;

%% CATEGORY overall data
input_folder  = fullfile(projectRoot, 'results', 'DA_mean', 'Infants_100', 'cat');
[data, DA_all_cat] = load_subjects(input_folder, subjects);

cat = compute_timecourse(DA_all_cat);

res_cat = load(fullfile(res, 'results_cat.mat'));
sig_cat = res_cat.results.pvals < 0.05;
peak_cat = res_cat.results.maxLat;

%--------------------------------------------------------------------------
%% Plotting time course
purple = [0.55 0.35 0.75];
orange = [0.85 0.45 0.20];


orange_fill = [0.95 0.75 0.60];
purple_fill = [0.80 0.70 0.90];

figure(1);
hold on
timePoints = -1000:2:2498;

f1 = fill([timePoints fliplr(timePoints)], ...
         [ (fam.time_mean-fam.time_sem)' fliplr((fam.time_mean+fam.time_sem)') ], ...
         purple_fill, ...
         'EdgeColor', 'none', ...
         'FaceAlpha', 0.4);
     
f2 = fill([timePoints fliplr(timePoints)], ...
         [ (nov.time_mean-nov.time_sem)' fliplr((nov.time_mean+nov.time_sem)') ], ...
         orange_fill, ...
         'EdgeColor', 'none', ...
         'FaceAlpha', 0.4);

    
    
    h1 = plot(timePoints, fam.time_mean,  'Color', purple, 'LineWidth', 2);
    h2 = plot(timePoints, nov.time_mean, 'Color', orange, 'LineWidth', 2);
    
    s1 = plot(timePoints(sig_fam), 35*ones(sum(sig_fam),1), '.', 'Color', purple, 'MarkerSize', 12);
    s2 = plot(timePoints(sig_nov), 32*ones(sum(sig_nov),1), '.', 'Color', orange, 'MarkerSize', 12);
    
    box off;
    xlim([-200,2000]);
    ylim([30 70]);
    xlabel('Time (ms)'); 
    ylabel('Decoding accuracy (%)');
%     title('Time course of category decoding in Infants');
    legend([h1 h2 s1 s2], {'Familiar objects', 'Novel objects', 'Familiar p < .05', 'Novel p < .05'})
    
    
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
%% RDM at peak (familiar) 

     t_start = peak_fam;
     s_timeidx = dsearchn(timePoints', t_start); % start
    
     DA_mean_matrix_fam = fam.DA_avg(:,:,s_timeidx);
     DecodingMatrix_fam = triu(DA_mean_matrix_fam.',1) + tril(DA_mean_matrix_fam);
     
     figure(5);
     imagesc(DecodingMatrix_fam);
     set(gca, 'xtick',1:3, 'xticklabel',{'art','monster','toy'});
     set(gca, 'ytick',1:3, 'yticklabel',{'art','monster','toy'});
     axis equal; axis tight;
     xlabel('Condition'); ylabel ('Condition');
     CH = colorbar('southoutside');
     CH.Label.String = 'Decoding accuracy (%)';
     title(sprintf('A'));
        
        % Set figure position and size
        rectFig = get(gcf,'position');
        width=700;
        height=300;
        set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
        caxis([50 60])


        
%% RDM at peak (novel) 

     t_start = peak_nov;
     s_timeidx = dsearchn(timePoints', t_start); % start
    
     DA_mean_matrix_nv = nov.DA_avg(:,:,s_timeidx);
     DecodingMatrix_nv = triu(DA_mean_matrix_nv.',1) + tril(DA_mean_matrix_nv);
     
     figure(4);
     imagesc(DecodingMatrix_nv);
     set(gca, 'xtick',1:3, 'xticklabel',{'art','monster','toy'});
     set(gca, 'ytick',1:3, 'yticklabel',{'art','monster','toy'});
     axis equal; axis tight;
     xlabel('Condition'); ylabel ('Condition');
     CH = colorbar('southoutside');
     CH.Label.String = 'Decoding accuracy (%)';
     title(sprintf('B' ));
        
        % Set figure position and size
        rectFig = get(gcf,'position');
        width=700;
        height=300;
        set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
        caxis([50 60])

%% RDM at peak (category) 

     t_start = peak_cat;
     s_timeidx = dsearchn(timePoints', t_start); % start
    
     DA_mean_matrix_cat = cat.DA_avg(:,:,s_timeidx);
     DecodingMatrix_cat = triu(DA_mean_matrix_cat.',1) + tril(DA_mean_matrix_cat);
     
     figure(6);
     imagesc(DecodingMatrix_cat);
     set(gca, 'xtick',1:3, 'xticklabel',{'art','monster','toy'});
     set(gca, 'ytick',1:3, 'yticklabel',{'art','monster','toy'});
     axis equal; axis tight;
     xlabel('Condition'); ylabel ('Condition');
     CH = colorbar('southoutside');
     CH.Label.String = 'Decoding accuracy (%)';
     title(sprintf('A'));
        
        % Set figure position and size
        rectFig = get(gcf,'position');
        width=700;
        height=300;
        set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
        caxis([50 60])

%--------------------------------------------------------------------------
%% saving results


savefig(figure(1), fullfile(output_folder, 'timcourse_sem.fig'));
saveas(figure(1), fullfile(output_folder, 'timecourse_sem.png'));

savefig(figure(5), fullfile(output_folder, 'decoding_matrix_fam.fig'));
saveas(figure(5), fullfile(output_folder, 'decoding_matrix_fam.png'));

savefig(figure(4), fullfile(output_folder, 'decoding_matrix_nov.fig'));
saveas(figure(4), fullfile(output_folder, 'decoding_matrix_nov.png'));

savefig(figure(6), fullfile(output_folder, 'decoding_matrix_cat.fig'));
saveas(figure(6), fullfile(output_folder, 'decoding_matrix_cat.png'));


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
