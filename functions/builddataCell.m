function dataCell = builddataCell(timelock, cat_field, fam_field, fam_keep)


%% ----------------------------
% Extract data
%% ----------------------------
data = timelock.trial;
trialinfo = timelock.trialinfo;

cat_labels = trialinfo(:,cat_field);
fam_labels = trialinfo(:,fam_field);

%% ----------------------------
% Optional familiarity filtering
%% ----------------------------
if ~isempty(fam_keep)
    idx_fam = ismember(fam_labels, fam_keep);

    data = data(idx_fam,:,:);
    cat_labels = cat_labels(idx_fam);
end

%% ----------------------------
% Build dataCell
%% ----------------------------
conditions = sort(unique(cat_labels));
nCond = length(conditions);

dataCell = cell(nCond,2);

for c = 1:nCond

    idx = (cat_labels == conditions(c));

    dataCell{c,1} = single(data(idx,:,:));
    dataCell{c,2} = sprintf('cat_%d',conditions(c));
   

end


   
%% ----------------------------
% SANITY CHECK OUTPUT
%% ----------------------------
fprintf('\n===== dataCell created =====\n');
fprintf('Conditions: %d\n', length(dataCell));
fprintf('Trials per condition:\n');

disp(cellfun(@(x) size(x,1), dataCell));

end