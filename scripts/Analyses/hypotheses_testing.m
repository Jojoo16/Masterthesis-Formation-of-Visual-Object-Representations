
%% Testing of Hypotheses and exploratory analyses
% -------------------------------------------------------------------
% Author:       Johanna Fiege
% Date:         11.08.2026
% Project:      Master's Thesis — Formation of Neural Object Representations

%% Settings

clear; close all; clc

projectRoot = '...\Masterthesis-Formation-of-Visual-Object-Representations';
addpath(genpath(projectRoot));
output_folder = fullfile(projectRoot, 'results', 'stats');

%% Load Infant data

subjects_4 = {'23_2', '24_2', '25_2', '26_2', '27_2', '33_2', '37_2', '38_2', '40_2', '42_2'};
subjects_3 = {'23_1', '24_1', '25_1', '26_1', '27_1', '33_1', '37_1', '38_1', '40_1', '42_1'};

input_folder  = fullfile(projectRoot, 'results', 'stats', 'Infants_100');
ifam = readtable(fullfile(input_folder, 'results_familiar_sub.csv'));
inov = readtable(fullfile(input_folder, 'results_novel_sub.csv'));
ifamiliarity = readtable(fullfile(input_folder, 'results_familiarity_sub.csv'));
icat = readtable(fullfile(input_folder, 'results_cat_sub.csv'));

ifam.MeanAccuracy = ifam.MeanAccuracy_win(:);
inov.MeanAccuracy = inov.MeanAccuracy_win(:);
ifamiliarity.MeanAccuracy = ifamiliarity.MeanAccuracy_win(:);
icat.MeanAccuracy = icat.MeanAccuracy_win(:);

ires_fam = load(fullfile(input_folder, 'results_familiar.mat'));
iperm_fam = ires_fam.perm_results;
ires_fam = ires_fam.results;

ires_nov = load(fullfile(input_folder, 'results_novel.mat'));
iperm_nov = ires_nov.perm_results;
ires_nov = ires_nov.results;

ires_familiarity = load(fullfile(input_folder, 'results_familiarity.mat'));
ifam_3 = ires_familiarity.tbl_sub(ismember(ires_familiarity.tbl_sub.ID, subjects_3), :);
ifam_4 = ires_familiarity.tbl_sub(ismember(ires_familiarity.tbl_sub.ID, subjects_4), :);
icomp_fam = load(fullfile(input_folder, 'famcomp_infants.mat'));
icomp_fam = icomp_fam.res_famcomp;
iperm_familiarity = ires_familiarity.perm_results;
ires_familiarity = ires_familiarity.results;

ires_cat = load(fullfile(input_folder, 'results_cat.mat'));
icat_3 = ires_cat.tbl_sub(ismember(ires_cat.tbl_sub.ID, subjects_3), :);
icat_4 = ires_cat.tbl_sub(ismember(ires_cat.tbl_sub.ID, subjects_4), :);
icomp_cat = load(fullfile(input_folder, 'catcomp_infants.mat'));
icomp_cat = icomp_cat.res_catcomp;
iperm_cat = ires_cat.perm_results;
ires_cat = ires_cat.results;

chance = 50;

%% Load Child data

subjects_4 = {'110_2', '114_2', '119_2', '122_2', '123_2', '124_2', '125_2', '126_2'};
subjects_3 = {'110_1', '114_1', '119_1', '122_1', '123_1', '124_1', '125_1', '126_1'};

input_folder  = fullfile(projectRoot, 'results', 'stats', 'Children_100');
cfam = readtable(fullfile(input_folder, 'results_familiar_sub.csv'));
cnov = readtable(fullfile(input_folder, 'results_novel_sub.csv'));
cfamiliarity = readtable(fullfile(input_folder, 'results_familiarity_sub.csv'));
ccat = readtable(fullfile(input_folder, 'results_cat_sub.csv'));

cfam.MeanAccuracy = cfam.MeanAccuracy_win(:);
cnov.MeanAccuracy = cnov.MeanAccuracy_win(:);
cfamiliarity.MeanAccuracy = cfamiliarity.MeanAccuracy_win(:);
ccat.MeanAccuracy = ccat.MeanAccuracy_win(:);


cres_fam = load(fullfile(input_folder, 'results_familiar.mat'));
cperm_fam = cres_fam.perm_results;
cres_fam = cres_fam.results;

cres_nov = load(fullfile(input_folder, 'results_novel.mat'));
cperm_nov = cres_nov.perm_results;
cres_nov = cres_nov.results;

cres_familiarity = load(fullfile(input_folder, 'results_familiarity.mat'));
cfam_3 = cres_familiarity.tbl_sub(ismember(cres_familiarity.tbl_sub.ID, subjects_3), :);
cfam_4 = cres_familiarity.tbl_sub(ismember(cres_familiarity.tbl_sub.ID, subjects_4), :);
ccomp_fam = load(fullfile(input_folder, 'famcomp_children.mat'));
ccomp_fam = ccomp_fam.res_famcomp;
cperm_familiarity = cres_familiarity.perm_results;
cres_familiarity = cres_familiarity.results;

cres_cat = load(fullfile(input_folder, 'results_cat.mat'));
ccat_3 = cres_cat.tbl_sub(ismember(cres_cat.tbl_sub.ID, subjects_3), :);
ccat_4 = cres_cat.tbl_sub(ismember(cres_cat.tbl_sub.ID, subjects_4), :);
ccomp_cat = load(fullfile(input_folder, 'catcomp_children.mat'));
ccomp_cat = ccomp_cat.res_catcomp;
cperm_cat = cres_cat.perm_results;
cres_cat = cres_cat.results;

%% Load time generalization data

input_folder  = fullfile(projectRoot, 'results', 'stats');
timegen = load(fullfile(input_folder, 'results_timegeneralization.mat'));
timegen = timegen.res_tg;

%% Descriptives

% Category Decoding
% Mean & SD
fprintf('Infants Category:   M = %.2f, SD = %.2f, Median = %.2f\n', ...
    mean(icat.MeanAccuracy), std(icat.MeanAccuracy), median(icat.MeanAccuracy));

fprintf('Children Category:   M = %.2f, SD = %.2f, Median = %.2f\n', ...
    mean(ccat.MeanAccuracy), std(ccat.MeanAccuracy), median(ccat.MeanAccuracy));
%________________________
% Familiarity Decoding
% Mean & SD
fprintf('Infants Familiarity:   M = %.2f, SD = %.2f, Median = %.2f\n', ...
    mean(ifamiliarity.MeanAccuracy), std(ifamiliarity.MeanAccuracy), median(ifamiliarity.MeanAccuracy));

fprintf('Children Familiarity:   M = %.2f, SD = %.2f, Median = %.2f\n', ...
    mean(cfamiliarity.MeanAccuracy), std(cfamiliarity.MeanAccuracy), median(cfamiliarity.MeanAccuracy));

%________________________
% Category (familiar objects)
% Mean & SD
fprintf('Infants familiar:   M = %.2f, SD = %.2f, Median = %.2f\n', ...
    mean(ifam.MeanAccuracy), std(ifam.MeanAccuracy), median(ifam.MeanAccuracy));

fprintf('Children familiar:   M = %.2f, SD = %.2f, Median = %.2f\n', ...
    mean(cfam.MeanAccuracy), std(cfam.MeanAccuracy), median(cfam.MeanAccuracy));

%_________________________
% Category (novel objects)
% Mean & SD
fprintf('Infants novel:   M = %.2f, SD = %.2f, Median = %.2f\n', ...
    mean(inov.MeanAccuracy), std(inov.MeanAccuracy), median(inov.MeanAccuracy));

fprintf('Children novel:   M = %.2f, SD = %.2f, Median = %.2f\n', ...
    mean(cnov.MeanAccuracy), std(cnov.MeanAccuracy), median(cnov.MeanAccuracy));

%__________________________
% Time-generalization stability
% Mean & SD
fprintf('Children stability: M = %.2f, SD = %.2f\n', ...
    mean(timegen.stability_child), std(timegen.stability_child));

fprintf('Infants stability: M = %.2f, SD = %.2f\n', ...
    mean(timegen.stability_infant), std(timegen.stability_infant));

%--------------------------------------------------------------------------
%% Testing distribution of normality and homogeneity of variances 

[h,p] = swtest(icat.MeanAccuracy)
qqplot(icat.MeanAccuracy)
histogram(icat.MeanAccuracy)
[h,p] = swtest(ccat.MeanAccuracy)
qqplot(ccat.MeanAccuracy)
histogram(ccat.MeanAccuracy)
[h,p] = swtest(ifam.MeanAccuracy)
qqplot(ifam.MeanAccuracy)
histogram(ifam.MeanAccuracy)
[h,p] = swtest(cfam.MeanAccuracy)
qqplot(cfam.MeanAccuracy)
histogram(cfam.MeanAccuracy)
[h,p] = swtest(inov.MeanAccuracy)
qqplot(inov.MeanAccuracy)
histogram(inov.MeanAccuracy)
[h,p] = swtest(cnov.MeanAccuracy)
qqplot(cnov.MeanAccuracy)
histogram(cnov.MeanAccuracy)
[h,p] = swtest(ifamiliarity.MeanAccuracy)
qqplot(ifamiliarity.MeanAccuracy)
histogram(ifamiliarity.MeanAccuracy)
[h,p] = swtest(cfamiliarity.MeanAccuracy)
qqplot(cfamiliarity.MeanAccuracy)
histogram(cfamiliarity.MeanAccuracy)

[h, p, ci, stats] = vartest2(icat.MeanAccuracy, ccat.MeanAccuracy);
[h, p, ci, stats] = vartest2(ifamiliarity.MeanAccuracy, cfamiliarity.MeanAccuracy);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Hypothesis 1a: Category decoding in infants and children

%-------------INFANTS----------------
[h_cat, p_cat, ci_cat, stats_cat] = ttest(icat.MeanAccuracy, chance, 'Tail', 'right');
fprintf('Infants-Category: t(%d)=%.2f, p=%.4f, mean=%.2f%% (chance=%.0f%%)\n', ...
    stats_cat.df, stats_cat.tstat, p_cat, mean(icat.MeanAccuracy), chance);

d = stats_cat.tstat / sqrt(30);

%--------------CHILDREN--------------
[h_catc, p_catc, ci_catc, stats_catc] = ttest(ccat.MeanAccuracy, chance, 'Tail', 'right');
fprintf('Children-Category: t(%d)=%.2f, p=%.4f, mean=%.2f%% (chance=%.0f%%)\n', ...
    stats_catc.df, stats_catc.tstat, p_catc, mean(ccat.MeanAccuracy), chance);

d = stats_catc.tstat / sqrt(22);

% Correct t-tests with bonferroni:
alpha = 0.05;
alpha_bonf = alpha/2;

pvals = [p_cat p_catc];
p_bonf = min(pvals * 2, 1);

fprintf('\nBonferroni-corrected alpha = %.4f\n',alpha_bonf)
fprintf('Infant category significant: %d, Bonferroni-corrected p = %.4f\n', p_cat < alpha_bonf, p_bonf(1))
fprintf('Child category significant: %d, Bonferroni-corrected p = %.4f\n', p_catc < alpha_bonf,  p_bonf(2))

%--------------------------------------------------------------------------
%% Hypothesis 1b: Decoding accuracy higher in children (category)

% for mean in cluster
meanDiff = mean(ccat.MeanAccuracy) - mean(icat.MeanAccuracy);
[h_catdiff, p_catdiff, ci_catdiff, stats_catdiff] = ttest2(ccat.MeanAccuracy, icat.MeanAccuracy, 'Tail', 'right');
fprintf(['Children: M=%.2f%%, SD=%.2f\n' ...
         'Infants:  M=%.2f%%, SD=%.2f\n' ...
         'Children > Infants: t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n',], ...
         mean(ccat.MeanAccuracy), std(ccat.MeanAccuracy), ...
         mean(icat.MeanAccuracy), std(icat.MeanAccuracy), ...
         stats_catdiff.df, stats_catdiff.tstat, p_catdiff, ...
         meanDiff);

d = stats_catdiff.tstat * sqrt(1/22 + 1/30)

% for peak
meanDiff = mean(ccat.PeakAccuracy) - mean(icat.PeakAccuracy);
[h_catdiffp, p_catdiffp, ci_catdiffp, stats_catdiffp] = ttest2(ccat.PeakAccuracy, icat.PeakAccuracy, 'Tail', 'right');
fprintf(['Children: M=%.2f%%, SD=%.2f\n' ...
         'Infants:  M=%.2f%%, SD=%.2f\n' ...
         'Children > Infants: t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n',], ...
         mean(ccat.PeakAccuracy), std(ccat.PeakAccuracy), ...
         mean(icat.PeakAccuracy), std(icat.PeakAccuracy), ...
         stats_catdiffp.df, stats_catdiffp.tstat, p_catdiffp, ...
         meanDiff);
     
d = stats_catdiffp.tstat * sqrt(1/22 + 1/30)

     
% Correct t-tests with bonferroni:
alpha = 0.05;
alpha_bonf = alpha/2;

pvals = [p_catdiff p_catdiffp];
p_bonf = min(pvals * 2, 1);

fprintf('\nBonferroni-corrected alpha = %.4f\n',alpha_bonf)
fprintf('Difference Mean Accuracy: %d, Bonferroni-corrected p = %.4f\n', p_catdiff < alpha_bonf, p_bonf(1))
fprintf('Difference Peak Accuracy: %d, Bonferroni-corrected p = %.4f\n', p_catdiffp < alpha_bonf,  p_bonf(2))

%--------------------------------------------------------------------------
%% Hypothesis 1b: Temporal stability higher in children (category) 

[h, p, ci, stats] = ttest2(timegen.stability_child, timegen.stability_infant, 'Tail', 'right')
fprintf('Temporal stability: t(%d)=%.2f, p=%.4f\n', ...
        stats.df, stats.tstat, p);

d = stats.tstat*sqrt(1/22 + 1/30)

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Hypothesis 2: Category generalization (familiar vs novel exemplars)

%-------------INFANTS----------------
% 1. familiar
[h_fam, p_fam, ci_fam, stats_fam] = ttest(ifam.MeanAccuracy, chance, 'Tail', 'right');
fprintf('Infants-Familiar objects: t(%d)=%.2f, p=%.4f, mean=%.2f%% (chance=%.0f%%)\n', ...
    stats_fam.df, stats_fam.tstat, p_fam, mean(ifam.MeanAccuracy), chance);

d = stats_fam.tstat / sqrt(30);

% 2. novel
[h_nov, p_nov, ci_nov, stats_nov] = ttest(inov.MeanAccuracy, chance, 'Tail', 'right');
fprintf('Infants-Novel objects: t(%d)=%.2f, p=%.4f, mean=%.2f%% (chance=%.0f%%)\n', ...
    stats_nov.df, stats_nov.tstat, p_nov, mean(inov.MeanAccuracy), chance);

d = stats_nov.tstat / sqrt(30);

% Correct t-tests with bonferroni:
alpha = 0.05;
alpha_bonf = alpha/2; 

pvals = [p_fam p_nov];
p_bonf = min(pvals * 2, 1);

fprintf('\nBonferroni-corrected alpha = %.4f\n',alpha_bonf)
fprintf('Infant familiar significant: %d, Bonferroni-corrected p = %.4f\n', p_fam < alpha_bonf, p_bonf(1))
fprintf('Infant novel significant: %d, Bonferroni-corrected p = %.4f\n', p_nov < alpha_bonf,  p_bonf(2))

%--------------------------------------------------------------------------
%--------------CHILDREN----------------
% 1. familiar
[h_cfam, p_cfam, ci_cfam, stats_cfam] = ttest(cfam.MeanAccuracy, chance, 'Tail', 'right');
fprintf('Children-Familiar objects: t(%d)=%.2f, p=%.4f, mean=%.2f%% (chance=%.0f%%)\n', ...
    stats_cfam.df, stats_cfam.tstat, p_cfam, mean(cfam.MeanAccuracy), chance);

d = stats_cfam.tstat / sqrt(22);


% 2. novel 
[h_cnov, p_cnov, ci_cnov, stats_cnov] = ttest(cnov.MeanAccuracy, chance, 'Tail', 'right');
fprintf('Children-Novel objects: t(%d)=%.2f, p=%.4f, mean=%.2f%% (chance=%.0f%%)\n', ...
    stats_cnov.df, stats_cnov.tstat, p_cnov, mean(cnov.MeanAccuracy), chance);

d = stats_cnov.tstat / sqrt(22);


% Correct t-tests with bonferroni:
alpha = 0.05;
alpha_bonf = alpha/2; 

pvals = [p_cfam p_cnov];
p_bonf = min(pvals * 2, 1);

fprintf('\nBonferroni-corrected alpha = %.4f\n',alpha_bonf)
fprintf('Child familiar significant: %d, Bonferroni-corrected p = %.4f\n', p_cfam < alpha_bonf,  p_bonf(1))
fprintf('Child novel significant: %d, Bonferroni-corrected p = %.4f\n', p_cnov < alpha_bonf, p_bonf(2))



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Hypothesis 3: Familiarity decoding in infants and children  

%-------------INFANTS----------------
% 1. familiarity level
[h_familiarity, p_familiarity, ci_familiarity, stats_familiarity] = ttest(ifamiliarity.MeanAccuracy, chance, 'Tail', 'right');
fprintf('Infants-Familiarity: t(%d)=%.2f, p=%.4f, mean=%.2f%% (chance=%.0f%%)\n', ...
    stats_familiarity.df, stats_familiarity.tstat, p_familiarity, mean(ifamiliarity.MeanAccuracy), chance);

d = stats_familiarity.tstat / sqrt(30);


%--------------CHILDREN---------------
% 2. familiarity level
[h_cfamiliarity, p_cfamiliarity, ci_cfamiliarity, stats_cfamiliarity] = ttest(cfamiliarity.MeanAccuracy, chance, 'Tail', 'right');
fprintf('Children-Familiarity: t(%d)=%.2f, p=%.4f, mean=%.2f%% (chance=%.0f%%)\n', ...
    stats_cfamiliarity.df, stats_cfamiliarity.tstat, p_cfamiliarity, mean(cfamiliarity.MeanAccuracy), chance);

d = stats_cfamiliarity.tstat / sqrt(22);


% Correct t-tests with bonferroni:
alpha = 0.05;
alpha_bonf = alpha/2;

pvals = [p_familiarity p_cfamiliarity];
p_bonf = min(pvals * 2, 1);

fprintf('\nBonferroni-corrected alpha = %.4f\n',alpha_bonf)
fprintf('Infant familiarity significant: %d, Bonferroni-corrected p = %.4f\n', p_familiarity < alpha_bonf, p_bonf(1))
fprintf('Child familiarity significant: %d, Bonferroni-corrected p = %.4f\n', p_cfamiliarity < alpha_bonf,  p_bonf(2))

%--------------------------------------------------------------------------
%% Hypothesis 3b: Decoding accuracy higher in children (familiarity)

% for mean cluster
meanDiff = mean(cfamiliarity.MeanAccuracy) - mean(ifamiliarity.MeanAccuracy);
[h_famim, p_famim, ci_famim, stats_famim] = ttest2(cfamiliarity.MeanAccuracy, ifamiliarity.MeanAccuracy, 'Tail', 'right');
fprintf(['Children: M=%.2f%%, SD=%.2f\n' ...
         'Infants:  M=%.2f%%, SD=%.2f\n' ...
         'Children > Infants: t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n',], ...
         mean(cfamiliarity.MeanAccuracy), std(cfamiliarity.MeanAccuracy), ...
         mean(ifamiliarity.MeanAccuracy), std(ifamiliarity.MeanAccuracy), ...
         stats_famim.df, stats_famim.tstat, p_famim, ...
         meanDiff);

d = stats_famim.tstat * sqrt(1/22 + 1/30)

     
% for peak    
meanDiff = mean(cfamiliarity.PeakAccuracy) - mean(ifamiliarity.PeakAccuracy);
[h_fami, p_fami, ci_fami, stats_fami] = ttest2(cfamiliarity.PeakAccuracy, ifamiliarity.PeakAccuracy, 'Tail', 'right');
fprintf(['Children: M=%.2f%%, SD=%.2f\n' ...
         'Infants:  M=%.2f%%, SD=%.2f\n' ...
         'Children > Infants: t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n',], ...
         mean(cfamiliarity.PeakAccuracy), std(cfamiliarity.PeakAccuracy), ...
         mean(ifamiliarity.PeakAccuracy), std(ifamiliarity.PeakAccuracy), ...
         stats_fami.df, stats_fami.tstat, p_fami, ...
         meanDiff);
     
d = stats_fami.tstat * sqrt(1/22 + 1/30)

     
% Correct t-tests with bonferroni:
alpha = 0.05;
alpha_bonf = alpha/2;

pvals = [p_famim p_fami];
p_bonf = min(pvals * 2, 1);

fprintf('\nBonferroni-corrected alpha = %.4f\n',alpha_bonf)
fprintf('Familiarity difference mean: %d, Bonferroni-corrected p = %.4f\n', p_famim < alpha_bonf, p_bonf(1))
fprintf('Familiarity difference peak: %d, Bonferroni-corrected p = %.4f\n', p_fami < alpha_bonf,  p_bonf(2))


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------    
%% Exploratory Analyses: Peak latency

% Check for variability in latency 

fprintf('Infants Category:\n')
mean(icat.PeakLatency_ms)
std(icat.PeakLatency_ms)
min(icat.PeakLatency_ms)
max(icat.PeakLatency_ms)
median(icat.PeakLatency_ms)

fprintf('\nChildren Category:\n')
mean(ccat.PeakLatency_ms)
std(ccat.PeakLatency_ms)
min(ccat.PeakLatency_ms)
max(ccat.PeakLatency_ms)
median(ccat.PeakLatency_ms)

fprintf('Infants Familiarity:\n')
mean(ifamiliarity.PeakLatency_ms)
std(ifamiliarity.PeakLatency_ms)
min(ifamiliarity.PeakLatency_ms)
max(ifamiliarity.PeakLatency_ms)
median(ifamiliarity.PeakLatency_ms)

fprintf('\nChildren Familiarity:\n')
mean(cfamiliarity.PeakLatency_ms)
std(cfamiliarity.PeakLatency_ms)
min(cfamiliarity.PeakLatency_ms)
max(cfamiliarity.PeakLatency_ms)
median(cfamiliarity.PeakLatency_ms)

fprintf('Infants familiar exemplars:\n')
mean(ifam.PeakLatency_ms)
std(ifam.PeakLatency_ms)
min(ifam.PeakLatency_ms)
max(ifam.PeakLatency_ms)
median(ifam.PeakLatency_ms)

fprintf('Infants novel exemplars:\n')
mean(inov.PeakLatency_ms)
std(inov.PeakLatency_ms)
min(inov.PeakLatency_ms)
max(inov.PeakLatency_ms)
median(inov.PeakLatency_ms)


fprintf('Children familiar exemplars:\n')
mean(cfam.PeakLatency_ms)
std(cfam.PeakLatency_ms)
min(cfam.PeakLatency_ms)
max(cfam.PeakLatency_ms)
median(cfam.PeakLatency_ms)

fprintf('Children novel exemplars:\n')
mean(cnov.PeakLatency_ms)
std(cnov.PeakLatency_ms)
min(cnov.PeakLatency_ms)
max(cnov.PeakLatency_ms)
median(cnov.PeakLatency_ms)

%--------------------------------------------------------------------------
% Differences between latencies across age groups and conditions

[h, p, ci, stats] = ttest2(icat.PeakLatency_ms, ccat.PeakLatency_ms);
fprintf('Peak Latency Category: t(%d)=%.2f, p=%.4f\n', ...
    stats.df, stats.tstat, p);

[h, p, ci, stats] = ttest2(ifamiliarity.PeakLatency_ms, cfamiliarity.PeakLatency_ms);
fprintf('Peak Latency Familiarity: t(%d)=%.2f, p=%.4f\n', ...
    stats.df, stats.tstat, p);

[h, p, ci, stats] = ttest(inov.PeakLatency_ms, ifam.PeakLatency_ms);
fprintf('Peak Latency Novel-Familiar Infants: t(%d)=%.2f, p=%.4f\n', ...
    stats.df, stats.tstat, p);

[h, p, ci, stats] = ttest(cnov.PeakLatency_ms, cfam.PeakLatency_ms);
fprintf('Peak Latency Novel-Familiar Children: t(%d)=%.2f, p=%.4f\n', ...
    stats.df, stats.tstat, p);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Exploratory Analyses: Decoding accuracy differences between novel and familiar objects (category)

%-------------INFANTS----------------
% for mean cluster
meanDiff = mean(ifam.MeanAccuracy) - mean(inov.MeanAccuracy);
[h_diffm, p_diffm, ci_diffm, stats_diffm] = ttest(ifam.MeanAccuracy, inov.MeanAccuracy);
fprintf('Familiar vs Novel (mean): t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n', ...
    stats_diffm.df, stats_diffm.tstat, p_diffm, ...
    meanDiff);

% for peak
meanDiff = mean(ifam.PeakAccuracy) - mean(inov.PeakAccuracy);
[h_diffp, p_diffp, ci_diffp, stats_diffp] = ttest(ifam.PeakAccuracy, inov.PeakAccuracy);
fprintf('Familiar vs Novel (Peak): t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n', ...
    stats_diffp.df, stats_diffp.tstat, p_diffp, ...
    meanDiff);


%-------------CHILDREN----------------
% for mean cluster
meanDiff = mean(cfam.MeanAccuracy) - mean(cnov.MeanAccuracy);
[h_cdiffm, p_cdiffm, ci_cdiffm, stats_cdiffm] = ttest(cfam.MeanAccuracy, cnov.MeanAccuracy);
fprintf('Familiar vs Novel (mean): t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n', ...
    stats_cdiffm.df, stats_cdiffm.tstat, p_cdiffm, ...
    meanDiff);

%for peak
meanDiff = mean(cfam.PeakAccuracy) - mean(cnov.PeakAccuracy);
[h_cdiffp, p_cdiffp, ci_cdiffp, stats_cdiffp] = ttest(cfam.PeakAccuracy, cnov.PeakAccuracy);
fprintf('Familiar vs Novel (Peak): t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n', ...
    stats_cdiffp.df, stats_cdiffp.tstat, p_cdiffp, ...
    meanDiff);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Exploratory Analyses: Comparison of day 3 vs day 4 - Category Representations

%-------------INFANTS----------------
meanDiff = mean(icat_4.PeakAccuracy) - mean(icat_3.PeakAccuracy);
[h_inf, p_inf, ci_inf, stats_inf] = ttest(icat_4.PeakAccuracy, icat_3.PeakAccuracy);
fprintf('Category - Day 4 vs day 3 (Infants): t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n', ...
    stats_inf.df, stats_inf.tstat, p_inf, ...
    meanDiff);

std(icat_3.PeakAccuracy)
std(icat_4.PeakAccuracy)

%-------------CHILDREN----------------
meanDiff = mean(ccat_4.PeakAccuracy) - mean(ccat_3.PeakAccuracy);
    [h_chi, p_chi, ci_chi, stats_chi] = ttest(ccat_4.PeakAccuracy, ccat_3.PeakAccuracy);
fprintf('Category - Day 4 vs day 3 (Children): t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n', ...
    stats_chi.df, stats_chi.tstat, p_chi, ...
    meanDiff);

std(ccat_3.PeakAccuracy)
std(ccat_4.PeakAccuracy)

%--------------------------------------------------------------------------
%% Exploratory Analyses: Comparison of day 3 vs day 4 - Familiarity Representations

%-------------INFANTS----------------
meanDiff = mean(ifam_4.PeakAccuracy) - mean(ifam_3.PeakAccuracy);
    [h_inf, p_inf, ci_inf, stats_inf] = ttest(ifam_4.PeakAccuracy, ifam_3.PeakAccuracy);
fprintf('Familiarity - Day 4 vs day 3 (Infants): t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n', ...
    stats_inf.df, stats_inf.tstat, p_inf, ...
    meanDiff);

std(ifam_3.PeakAccuracy)
std(ifam_4.PeakAccuracy)

%-------------CHILDREN----------------
meanDiff = mean(cfam_4.PeakAccuracy) - mean(cfam_3.PeakAccuracy);
    [h_chi, p_chi, ci_chi, stats_chi] = ttest(cfam_4.PeakAccuracy, cfam_3.PeakAccuracy);
fprintf('Familiarity - Day 4 vs day 3 (Children): t(%d)=%.2f, p=%.4f, mean diff=%.2f%%\n', ...
    stats_chi.df, stats_chi.tstat, p_chi, ...
    meanDiff);

std(cfam_3.PeakAccuracy)
std(cfam_4.PeakAccuracy)

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------