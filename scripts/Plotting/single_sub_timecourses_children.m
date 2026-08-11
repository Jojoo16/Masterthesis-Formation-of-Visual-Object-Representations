
%% Plot single participant's decoding Time Course for Category (Children)
% -------------------------------------------------------------------
% Author:       Johanna Fiege
% Date:         11.08.2026
% Project:      Master's Thesis — Formation of Neural Object Representations
% Code:         Adapted from Code by Siying, Xie

%% Settings

clc; clear; close all;

projectRoot = '...\Masterthesis-Formation-of-Visual-Object-Representations';
addpath(genpath(projectRoot));

input_folder  = fullfile(projectRoot, 'results', 'DA_mean', 'Children_100', 'cat');
output_folder = fullfile(projectRoot, 'results', 'Plots', 'Children_100');

%% Load subjects
subjects_new = {'110_2', '114_2', '119_2', '122_2', '123_2', '124_2', '125_2', '126_2'};
subjects_old = {'104_1', '104_2', '105_1', '105_2', '108_1', '108_2', '110_1', '114_1', '119_1', '122_1', '123_1', '124_1', '125_1', '126_1'}

subjects = [subjects_new, subjects_old];

chance = 50;

%% Load data 
[data, DA_all] = load_subjects(input_folder, subjects);
results = extract_decoding_stats(DA_all, chance);
 
timepoints = results.time;          % time vector in ms
resdata    = results.timeCourse_sub; % per-subject decoding time courses
 

fprintf('resdata size: %d x %d | nSubjects = %d | nTimepoints = %d\n', ...
    size(resdata,1), size(resdata,2), numel(subjects), numel(timepoints));
 
nSub = numel(subjects);

nTicks = 5;
xTickValue = round(linspace(0,timepoints(end), nTicks) / 50)*50;
xTickVals = [-200, xTickValue];

%% Plot result

f=figure(1);
nRows = ceil(nSub/4);

for parn=1:nSub % Loop through all participants
    
    subplot(nRows,4,parn);
    
    resdata_ = resdata(:,parn);
    
    H_plot = plot (timepoints, resdata_, 'LineWidth', 1, 'Color', 'r');
    
    % Cosmetic of plots
    box off;
    H_onset = line([0,0], [-200,100],'Color',[0.5 0.5 0.5], 'Linewidth', 0.5);
    set(get(get(H_onset,'Annotation'),'Legendinformation'),'Icondisplaystyle', 'off');
    
    H_chance = line([timepoints(1), timepoints(end)], [chance, chance], 'Color', [0.5 0.5 0.5], 'Linewidth', 0.5);
    set(get(get(H_chance ,'Annotation'),'Legendinformation'),'Icondisplaystyle', 'off');
    
    set(gca,'XTick', xTickVals);
    set(gca,'YTick',10:20:90);
    
    set(gca, 'Fontsize', 8, 'Fontname', 'Arial', ...
        'Xcolor', 'Black', 'Ycolor', 'Black', 'LineWidth', 0.5);
    
    xlim([-200, timepoints(end)]); xtickangle(30); 
    ylim([10,90]);
    
    if parn > nSub - 2
        xlabel('Time(ms)','Fontsize', 10, 'Fontname', 'Arial')
    else
        set(gca,'XTickLabel',[]);
    end
    
    if mod(parn,2)==1
        ylabel(['Decoding',newline,'accuracy(%)'], ...
            'Fontsize', 10, 'Fontname', 'Arial')
    else
        set(gca,'YTickLabel',[]);
    end
    
    title(sprintf('participant %02d', parn), 'FontSize', 10);
end

% Set figure position and size
width=1000;
height=800;
set(gcf,'Position',[1,1,width,height],...
    'Color', 'White','Renderer','Painters');
movegui(f, 'center');

%% Save figure
savefig(figure(1), fullfile(output_folder, 'single_sub_timecourses.fig'));
saveas(figure(1), fullfile(output_folder, 'single_sub_timecourses.png'));

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------