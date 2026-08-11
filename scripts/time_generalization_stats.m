
%% Extracting statistics of Time-Generalization analysis
% -------------------------------------------------------------------
% Author:       Johanna Fiege
% Date:         11.08.2026
% Project:      Master's Thesis — Formation of Neural Object Representations

%% Settings

clear; close all; clc

projectRoot = '...\Masterthesis-Formation-of-Visual-Object-Representations';
addpath(genpath(projectRoot));

input_folder_i  = fullfile(projectRoot, 'results', 'time_gen', 'Infants_100', 'cat');
input_folder_c  = fullfile(projectRoot, 'results', 'time_gen', 'Children_100', 'cat');
output_folder = fullfile(projectRoot, 'results', 'stats');

%% Load infant data
subjects_new = {'23_2', '24_2', '25_2', '26_2', '27_2', '33_2', '37_2', '38_2', '40_2', '42_2'};
subjects_old = {'7_1', '10_1', '15_1', '17_1', '18_1', '7_2', '10_2', '15_2', '17_2', '18_2', '23_1', '24_1', '25_1', '26_1', '27_1', '33_1', '37_1', '38_1', '40_1', '42_1'};

subjects_i = [subjects_new, subjects_old];

% Loading subject data, including decoding accuracy matrices of all subjects
[data, DA_all_infant] = load_subjects_timegen(input_folder_i, subjects_i);

% Computing DA_avg (mean decoding accuracy), timeCourse, timeCourse_sub, time_mean and time_sem
infant = compute_timecourse_timegen(DA_all_infant);

%% load child data

subjects_new = {'110_2', '114_2', '119_2', '122_2', '123_2', '124_2', '125_2', '126_2'};
subjects_old = {'104_1', '104_2', '105_1', '105_2', '108_1', '108_2', '110_1', '114_1', '119_1', '122_1', '123_1', '124_1', '125_1', '126_1'};

subjects_c = [subjects_new, subjects_old];
[data, DA_all_child] = load_subjects_timegen(input_folder_c, subjects_c);

% Computing DA_avg (mean decoding accuracy), timeCourse, timeCourse_sub, time_mean and time_sem
child = compute_timecourse_timegen(DA_all_child);

timepoints = -1000:20:2498;
chance = 50;

%% Infants

% Calculate mean off-diagnoal decoding accuracy after stimulus onset
idx_post = timepoints >= 0;

nSub = size(infant.timeCourse_sub, 3);

TG_stab_i = nan(nSub,1);

for s = 1:nSub
    TG_i = infant.timeCourse_sub(:,:,s);
    TG_i = TG_i(idx_post, idx_post);
    offdiag = ~eye(size(TG_i));
    TG_stab_i(s) = mean(TG_i(offdiag));
end

%% Children

% Calculate mean off-diagnoal decoding accuracy after stimulus onset
idx_post = timepoints >= 0;

nSub = size(child.timeCourse_sub, 3);

TG_stab_c = nan(nSub,1);

for s = 1:nSub
    TG_c = child.timeCourse_sub(:,:,s);
    TG_c = TG_c(idx_post, idx_post);
    offdiag = ~eye(size(TG_c));
    TG_stab_c(s) = mean(TG_c(offdiag));
end


res_tg = struct();
res_tg.stability_child = TG_stab_c;
res_tg.stability_infant = TG_stab_i;

%--------------------------------------------------------------------------
%% save results
save(fullfile(output_folder, 'results_timegeneralization.mat'),'res_tg');

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------