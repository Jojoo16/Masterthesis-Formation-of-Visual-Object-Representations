
%% Time-Generalization analysis, decoding for category (Children)
% -------------------------------------------------------------------
% Author:       Johanna Fiege
% Date:         11.08.2026
% Project:      Master's Thesis — Formation of Neural Object Representations
% Code:         Adapted from Code by Siying, Xie

%% Settings

clear; close all; clc

projectRoot = '...\Masterthesis-Formation-of-Visual-Object-Representations';
addpath(genpath(projectRoot));

input_folder  = fullfile(projectRoot, 'data');
output_folder = fullfile(projectRoot, 'results', 'time_gen', 'Children_100', 'cat');

% Start timing
tic;

%% Load subjects

files = dir(fullfile(input_folder, '*.set'));
subjects_new = {'110_2', '114_2', '119_2', '122_2', '123_2', '124_2', '125_2', '126_2'};
subjects_old = {'104_1', '104_2', '105_1', '105_2', '108_1', '108_2', '110_1', '114_1', '119_1', '122_1', '123_1', '124_1', '125_1', '126_1'}

subjects = [subjects_new, subjects_old];

fileIDs = cell(length(files),1);
for i = 1:length(files)
    fileIDs{i} = regexp(files(i).name, '^\d+_\d+', 'match', 'once');
end
keep = ismember(fileIDs, subjects);
files = files(keep);
fileIDs = fileIDs(keep);
nSub = length(files);


%%--------------------------------------------------------------------------
%% Decoding Pipeline
% run for dataCell.all


for s = 1:nSub
    

% Load data
EEG = pop_loadset('filename', files(s).name, 'filepath', input_folder);
for e = 1:length(EEG.epoch)
    if iscell(EEG.epoch(e).eventcat_i_nr)
       EEG.epoch(e).eventcat_i_nr = EEG.epoch(e).eventcat_i_nr{1};
    end
    if iscell(EEG.epoch(e).eventfam_i_num)
        EEG.epoch(e).eventfam_i_num = EEG.epoch(e).eventfam_i_num{1};
    end
end
size(EEG.data);
[dataCell,timelock] = eeg2dataCell(EEG);

% choose condition
dataCell = dataCell.all


% Check timelock
timelock


% Sort trials into three category conditions
[dataCell{1:3,2}]=deal('art','monster', 'toy');


% Check dataCell
dataCell


%% Time-generalization analysis

% NOTE: Randomization is used within averagetrials.m so results might
% differ between computations.

% Repetition
permutationX = 100;

% Object categories as conditions
conditionM = 3;

% downsampling EEG data to a sampling rate of 50 Hz by averaging the raw EEG data in 20ms bins
origTempRes = 500; % 500 Hz
resTempRes = 50; % 50 Hz
timePoints2Average = origTempRes/resTempRes;
[dataCell, timepointT] = averagetimepoints(dataCell, timePoints2Average);


% Pre-allocate result matrix
DA = nan(permutationX, conditionM, conditionM, timepointT, timepointT);


for permX = 1:permutationX % Loop through repetitions
    
    pseudoTrialN = 4;
    pseudoData = averagetrials(dataCell, pseudoTrialN);
    
    % Additional whitening data procedure
    pseudoData = cvmvnn(pseudoData,1:3);
    
    for condA = 1:conditionM % Loop for condition A
        for condB = condA+1:conditionM % Loop for condition B
            
            for timeA = 1:timepointT % Loop for time point A
                
                % Implement leave-one-pseudo-trial-out cross validated
                % classification approach.
                
                training_data = ...
                    double([squeeze(pseudoData(condA, 1:end - 1, :, timeA)); ...
                    squeeze(pseudoData(condB, 1:end - 1, :, timeA))]);
                labels_train = [ones(pseudoTrialN-1,1);...
                    2*ones(pseudoTrialN - 1,1)];
                
                % Train model
                model = svmtrain(labels_train, training_data, '-s 0 -t 0 -q');
                
                for timeB = 1:timepointT % Loop for time point B
                    
                   
                    testing_data = double([squeeze(pseudoData(condA, end, :, timeB))'; ...
                        squeeze(pseudoData(condB, end, :, timeB))']);
                    labels_test = [1;2];
                    
                    % Test model
                    [~, accuracy, ~] = svmpredict(labels_test, testing_data, model, '-q');
                    
                    % Assign the decoding result into DA matrix
                    DA(permX, condB, condA, timeA, timeB) = accuracy(1);
                end
            end
        end
    end
end

% Average the DA matrix across repetetions
DA_mean = squeeze(nanmean(DA,1));

% Display run time
disp("Decoding done.")
runTime_minutes = toc/60

% Save subject file
subID = fileIDs{s};

save(fullfile(output_folder, [subID '_time_gen_cat.mat']),'DA_mean', '-v7.3');
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------