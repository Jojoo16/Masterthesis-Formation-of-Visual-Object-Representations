
%% Time-Generalization analysis - Plotting (Infants)
% -------------------------------------------------------------------
% Author:       Johanna Fiege
% Date:         11.08.2026
% Project:      Master's Thesis — Formation of Neural Object Representations

%% Settings

clear; close all; clc

projectRoot = '...\Masterthesis-Formation-of-Visual-Object-Representations';
addpath(genpath(projectRoot));

input_folder  = fullfile(projectRoot, 'results', 'time_gen', 'Infants_100', 'cat');
output_folder = fullfile(projectRoot, 'results', 'Plots', 'Infants_100');

%% Load subjects and data
subjects_new = {'23_2', '24_2', '25_2', '26_2', '27_2', '33_2', '37_2', '38_2', '40_2', '42_2'};
subjects_old = {'7_1', '10_1', '15_1', '17_1', '18_1', '7_2', '10_2', '15_2', '17_2', '18_2', '23_1', '24_1', '25_1', '26_1', '27_1', '33_1', '37_1', '38_1', '40_1', '42_1'};

subjects = [subjects_new, subjects_old];

% Loading subject data, including decoding accuracy matrices of all subjects
[data, DA_all_cat] = load_subjects_timegen(input_folder, subjects);

% Computing DA_avg (mean decoding accuracy), timeCourse, timeCourse_sub,
% time_mean and time_sem
cat = compute_timecourse_timegen(DA_all_cat);

timepoints = -1000:20:2498;
chance = 50;

% Computing p-values
nTime = size(cat.timeCourse_sub,1);

pvals = nan(nTime, nTime);
tvals = nan(nTime, nTime);

for tTrain = 1:nTime
    for tTest = 1:nTime
        data = squeeze(cat.timeCourse_sub(tTrain, tTest, :));
        [~,pvals(tTrain,tTest), ~, stats] = ttest(data, chance, 'Tail', 'right');
        tvals(tTrain, tTest) = stats.tstat;
    end
end

sigvals = pvals < 0.05;

 
%% PLOT Time-generalization Matrix
figure(1);
%subplot(1,2,1)
imagesc(timepoints, timepoints, cat.timeCourse);

axis xy;
axis equal;
axis tight;

% Cosmetics (match paper style)
set(gca,...
    'Fontname','Arial',...
    'Fontsize',10,...
    'Linewidth',1,...
    'Tickdir','in',...
    'Xcolor','black',...
    'Ycolor','black');

xlim([-100 2000]);
ylim([-100 2000]);

xticks(timepoints(1):100:timepoints(end));
yticks(timepoints(1):100:timepoints(end));

xtickangle(45);

xlabel('Training Time (ms)');
ylabel('Testing Time (ms)');
title('A');

% Colormap + scaling
colormap('default');   % or your plotcolors if you prefer
caxis([50 58]);

% Reference lines (stimulus onset)
hold on;
line([0 2000],[0 0],'Color',[0.6 0.6 0.6],'LineWidth',1);
line([0 0],[0 2000],'Color',[0.6 0.6 0.6],'LineWidth',1);

hold on
contour(timepoints, timepoints, sigvals,[1 1], 'k', 'LineWidth', 0.5);


% Set color bar 
cbpos = [0.92 0.4 0.015 0.2];
CBar_Handle = colorbar('position',cbpos);
set(CBar_Handle,'FontSize', 8,'Linewidth', 0.5, 'FontName', 'Arial','Color', 'black');
set(get(CBar_Handle, 'YLabel'), 'String', "Decoding accuracy (%)", ...
    'FontSize', 8, 'FontName', 'Arial','Color', 'black');


set(gcf,'Color','white','Position',[300 200 600 600]);


% Set figure position and size
width=650;
height=680;
set(gcf,'Position',[1,1,width,height],...
    'Color', 'White','Renderer','Painters');
movegui(figure(1), 'center');


%% saving results

savefig(figure(1), fullfile(output_folder, 'timegen_cat.fig'));
saveas(figure(1), fullfile(output_folder, 'timegen_cat.png'));


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
