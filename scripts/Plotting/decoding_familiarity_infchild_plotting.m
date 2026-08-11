
%% Decoding in time in infants & children - Plotting Time Course & Decoding Matrices for Familiarity Decoding
% -------------------------------------------------------------------
% Author:       Johanna Fiege
% Date:         11.08.2026
% Project:      Master's Thesis — Formation of Neural Object Representations

%% Settings

clear; close all; clc

projectRoot = '...\Masterthesis-Formation-of-Visual-Object-Representations';
addpath(genpath(projectRoot));
input_folder_i  = fullfile(projectRoot, 'results', 'DA_mean', 'Infants_100', 'familiarity');
input_folder_c  = fullfile(projectRoot, 'results', 'DA_mean', 'Children_100', 'familiarity');
output_folder = fullfile(projectRoot, 'results', 'Plots');


%% Infant Data

res_infant = fullfile(projectRoot, 'results', 'stats', 'Infants_100');
subjects_new = {'23_2', '24_2', '25_2', '26_2', '27_2', '33_2', '37_2', '38_2', '40_2', '42_2'};
subjects_old = {'7_1', '10_1', '15_1', '17_1', '18_1', '7_2', '10_2', '15_2', '17_2', '18_2', '23_1', '24_1', '25_1', '26_1', '27_1', '33_1', '37_1', '38_1', '40_1', '42_1'};

subjects = [subjects_new, subjects_old];

% Loading subject data, including decoding accuracy matrices of all subjects
[data, DA_all] = load_subjects(input_folder_i, subjects);

% Computing DA_avg (mean decoding accuracy), timeCourse, timeCourse_sub, time_mean and time_sem
infant = compute_timecourse(DA_all);

res_inf = load(fullfile(res_infant, 'results_familiarity.mat'));
sig_inf = res_inf.results.pvals < 0.05;
peak_inf = res_inf.results.maxLat;

%% Children Data
res_child = fullfile(projectRoot, 'results', 'stats', 'Children_100');
subjects_new = {'110_2', '114_2', '119_2', '122_2', '123_2', '124_2', '125_2', '126_2'};
subjects_old = {'104_1', '104_2', '105_1', '105_2', '108_1', '108_2', '110_1', '114_1', '119_1', '122_1', '123_1', '124_1', '125_1', '126_1'};

subjects = [subjects_new, subjects_old];

% Loading subject data, including decoding accuracy matrices of all subjects
[data, DA_all] = load_subjects(input_folder_c, subjects);

% Computing DA_avg (mean decoding accuracy), timeCourse, timeCourse_sub, time_mean and time_sem
child = compute_timecourse(DA_all);

res_chi = load(fullfile(res_child, 'results_familiarity.mat'));
sig_chi = res_chi.results.pvals < 0.05;
peak_chi = res_chi.results.maxLat;

%--------------------------------------------------------------------------
%% Plotting Time Course
purple = [0.55 0.35 0.75];
orange = [0.85 0.45 0.20];


orange_fill = [0.95 0.75 0.60];
purple_fill = [0.80 0.70 0.90];

figure(1);
hold on
timePoints = -1000:2:2498;

f1 = fill([timePoints fliplr(timePoints)], ...
         [ (infant.time_mean-infant.time_sem)' fliplr((infant.time_mean+infant.time_sem)') ], ...
         purple_fill, ...
         'EdgeColor', 'none', ...
         'FaceAlpha', 0.4);
     
f2 = fill([timePoints fliplr(timePoints)], ...
         [ (child.time_mean-child.time_sem)' fliplr((child.time_mean+child.time_sem)') ], ...
         orange_fill, ...
         'EdgeColor', 'none', ...
         'FaceAlpha', 0.4);

    
    
    h1 = plot(timePoints, infant.time_mean,  'Color', purple, 'LineWidth', 2);
    h2 = plot(timePoints, child.time_mean, 'Color', orange, 'LineWidth', 2);
    s1 = plot(timePoints(sig_inf), 35*ones(sum(sig_inf),1), '.', 'Color', purple, 'MarkerSize', 12);
    s2 = plot(timePoints(sig_chi), 32*ones(sum(sig_chi),1), '.', 'Color', orange, 'MarkerSize', 12);
    
    box off;
    xlim([-200,2000]);
    ylim([30 80]);
    xlabel('Time (ms)'); 
    ylabel('Decoding accuracy (%)');
%     title('Time course of decoding Familiarity');
    legend([h1 h2 s1 s2], {'Infants', 'Children', 'Infant p < .05', 'Children p < .05'})
    
    
    
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
%% RDM at peak (Infants) 

     t_start = peak_inf;
     s_timeidx = dsearchn(timePoints', t_start); % start
    
     DA_mean_matrix_inf = infant.DA_avg(:,:,s_timeidx);
     DecodingMatrix_inf = triu(DA_mean_matrix_inf.',1) + tril(DA_mean_matrix_inf);
     
     figure(2);
     imagesc(DecodingMatrix_inf);
     set(gca, 'xtick',1:2, 'xticklabel',{'novel', 'familiar'});
     set(gca, 'ytick',1:2, 'yticklabel',{'novel', 'familiar'});
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
        caxis([50 73])
        

%% RDM at peak (Children) 

     t_start = peak_chi;
     s_timeidx = dsearchn(timePoints', t_start); % start
    
     DA_mean_matrix_chi = child.DA_avg(:,:,s_timeidx);
     DecodingMatrix_chi = triu(DA_mean_matrix_chi.',1) + tril(DA_mean_matrix_chi);
     
     figure(3);
     imagesc(DecodingMatrix_chi);
     set(gca, 'xtick',1:2, 'xticklabel',{'novel', 'familiar'});
     set(gca, 'ytick',1:2, 'yticklabel',{'novel', 'familiar'});
     axis equal; axis tight;
     xlabel('Condition'); ylabel ('Condition');
     CH = colorbar('southoutside');
     CH.Label.String = 'Decoding accuracy (%)';
     title(sprintf('B'));
        
        % Set figure position and size
        rectFig = get(gcf,'position');
        width=700;
        height=300;
        set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
        caxis([50 73])   

%--------------------------------------------------------------------------
%% saving results


savefig(figure(1), fullfile(output_folder, 'timcourse_familiarity_infchild_sem.fig'));
saveas(figure(1), fullfile(output_folder, 'timecourse_familiarity_infchild_sem.png'));

savefig(figure(2), fullfile(output_folder, 'decoding_matrix_familiarity_inf.fig'));
saveas(figure(2), fullfile(output_folder, 'decoding_matrix_familiarity_inf.png'));

savefig(figure(3), fullfile(output_folder, 'decoding_matrix_familiarity_child.fig'));
saveas(figure(3), fullfile(output_folder, 'decoding_matrix_familiarity_child.png'));


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------