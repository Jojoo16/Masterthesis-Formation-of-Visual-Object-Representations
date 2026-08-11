function dataCell = familiaritydataCell(timelock, famLabel, novLabel)


%% ----------------------------
% Extract data
%% ----------------------------
data = timelock.trial;
fam_labels = timelock.trialinfo(:,2);



%% Build dataCell for familiarity decoding
% Condition 1 = familiar objects
% Condition 2 = novel objects

dataCell = cell(2,2);

% Familiar trials 
idx_fam = fam_labels == famLabel;
dataCell{1,1} = single(data(idx_fam,:,:));
dataCell{1,2} = 'familiar';

% Novel trials 
idx_new = fam_labels == novLabel;
dataCell{2,1} = single(data(idx_new,:,:));
dataCell{2,2} = 'novel';

%% Sanity check
fprintf('\n===== dataCell created =====\n');
fprintf('Trials per condition:\n');
disp(cellfun(@(x) size(x,1), dataCell));


end