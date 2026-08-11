function [dataCell, timelock] = eeg2familiarity(EEG)


data = permute(EEG.data, [3 1 2]); % get data in format trials x channels x time
size(data);


% Extract labels
cat_labels = [EEG.epoch.eventcat_i_nr];
fam_labels = [EEG.epoch.eventfam_i_num];

trialinfo = [cat_labels(:) fam_labels(:)]; %gives category and familiarity of stimulus


% create timelock structure
timelock = struct();
timelock.trial = single(data);
timelock.time = EEG.times;
timelock.label = {EEG.chanlocs.labels};
timelock.trialinfo = trialinfo;

famLabel = max(fam_labels);
novLabel = 1;

% Building dataCell
dataCell = familiaritydataCell(timelock, famLabel,novLabel);

end
