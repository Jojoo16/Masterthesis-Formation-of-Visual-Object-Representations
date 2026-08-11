
%% Statistical Analyses across conditions and age groups
% -------------------------------------------------------------------
% Author:       Johanna Fiege
% Date:         11.08.2026
% Project:      Master's Thesis — Formation of Neural Object Representations

%% Settings
clear; close all; clc

projectRoot = '...\Masterthesis-Formation-of-Visual-Object-Representations';
addpath(genpath(projectRoot));

rng(1);

chance = 50;

%% Subject lists

subjects_children = {'110_2','114_2','119_2','122_2','123_2','124_2','125_2','126_2', ...
    '104_1','104_2','105_1','105_2','108_1','108_2','110_1','114_1','119_1','122_1', ...
    '123_1','124_1','125_1','126_1'};

subjects_infants = {'23_2','24_2','25_2','26_2','27_2','33_2','37_2','38_2','40_2','42_2', ...
    '7_1','10_1','15_1','17_1','18_1','7_2','10_2','15_2','17_2','18_2', ...
    '23_1','24_1','25_1','26_1','27_1','33_1','37_1','38_1','40_1','42_1'};

%% Define all conditions to run: {subfolder, output_prefix, subjects}
conditions_children = {
    'cat',         'results_cat',         subjects_children;
    'fam',         'results_familiar',    subjects_children;
    'familiarity', 'results_familiarity', subjects_children;
    'novel',       'results_novel',       subjects_children;
};

conditions_infants = {
    'cat',         'results_cat',         subjects_infants;
    'fam',         'results_familiar',    subjects_infants;
    'familiarity', 'results_familiarity', subjects_infants;
    'novel',       'results_novel',       subjects_infants;
};

%% Run — Children
for i = 1:size(conditions_children,1)
    subfolder = conditions_children{i,1};
    prefix    = conditions_children{i,2};
    subs      = conditions_children{i,3};

    input_folder  = fullfile(projectRoot, 'results', 'DA_mean', 'Children_100', subfolder);
    output_folder = fullfile(projectRoot, 'results', 'stats', 'Children_100');

    fprintf('\n--- Children: %s ---\n', prefix);
    analyze_condition(input_folder, output_folder, subs, prefix, chance);
end

%% Run — Infants
for i = 1:size(conditions_infants,1)
    subfolder = conditions_infants{i,1};
    prefix    = conditions_infants{i,2};
    subs      = conditions_infants{i,3};

    input_folder  = fullfile(projectRoot, 'results', 'DA_mean', 'Infants_100', subfolder);
    output_folder = fullfile(projectRoot, 'results', 'stats', 'Infants_100');

    fprintf('\n--- Infants: %s ---\n', prefix);
    analyze_condition(input_folder, output_folder, subs, prefix, chance);
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------