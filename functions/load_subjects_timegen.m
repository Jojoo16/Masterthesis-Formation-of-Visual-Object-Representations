function [data, DA_all] = load_subjects_timegen(input_folder, subjects)

files = dir(fullfile(input_folder, '*.mat'));
nFiles = length(files);

fileIDs = cell(nFiles,1);

for i = 1:nFiles
    fileIDs{i} = regexp(files(i).name, '^\d+_\d+', 'match', 'once');
end

keep = ismember(fileIDs, subjects);

files = files(keep);
fileIDs = fileIDs(keep);

%% load data

for i = 1:length(files) % subject loop
    
    filename = fullfile(input_folder, files(i).name);
    s = load(filename);
    data(i).ID = fileIDs{i};
    data(i).DA = s.DA_mean;
    
end 

nSub = length(data);
for i = 1:nSub
    DA_all(:,:,:,:,i) = data(i).DA;
end

end
