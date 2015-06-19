close all
clear all
clc

addpath('../functions')

%% Load previously extracted data
load('manclass_data.mat')


%% Delete those patents with technology numbers some industries

delete_technr = [430, % Radiation Imagery Chemistry
                 431, % Combustion
                 435, % Chemistry: Molecular Biology and Microbiology
                 514, % Drug, Bio-affecting and Body Treating Compositions
                 530, % Chemistry: Natural Resins or Derivatives; Peptides or Proteins; ...
                % 600, % Surgery
                % 606, % Surgery
                 800]; % Multicellar Living Organisms
             
technr = manclass_data(:, 8);
delete_pat_pos = find(ismember(technr, delete_technr));

del_pat = manclass_data(delete_pat_pos, :);
del_pat_manual1 = find(del_pat(:, 3));
del_pat_automatic1 = find(del_pat(:, 7)>0);
del_pat_manual1_automatic1 = intersect(del_pat_manual1, del_pat_automatic1);
del_pat_manual1_automatic0 = setdiff(del_pat_manual1, del_pat_automatic1);
del_pat_automatic1_manual0 = setdiff(del_pat_automatic1, del_pat_manual1);

fprintf('___________________________________________________________\n');
fprintf('<strong>Discarded technologies</strong>\n');
fprintf(' \n')
fprintf('Delete %d/%d (%3.2f) patents.\n', length(delete_pat_pos), ...
    size(manclass_data, 1), length(delete_pat_pos)/size(manclass_data, 1))
fprintf('Of those: \n')
fprintf('\t %d = manual: 1, automatic: 1.\n', length(del_pat_manual1_automatic1))
fprintf('\t %d = manual: 1, automatic: 0.\n', length(del_pat_manual1_automatic0))
fprintf('\t %d = automatic: 1, manual: 0.\n', length(del_pat_automatic1_manual0))
fprintf(' ')

manclass_data(delete_pat_pos, :) = [];


%% Transform variables

% Figure out how many patents have been classified yet
indic_automat = manclass_data(:, 3);

nr_codpt = length(indic_automat);
sum_automat = sum(indic_automat);
share_automat = sum_automat / nr_codpt;


%% Compare manual classification with automated keyword search
nr_keyword_find = manclass_data(:, 7); % extract number of keyword matches
% Find patents with at least 1 match
pat_1match = (nr_keyword_find > 0); % the plus converts logical to double 

pos_manclass_automat = find(indic_automat);
pos_pat_1match = find(pat_1match);


%% Calculate area under curve (AUROC)
% -------------------------------------------------------------------
classifstat.auc = calculate_auc(indic_automat, pat_1match);


%% Calculate the overall agreement rate

% For  definitions of evaluation measures (accuracy, precision, recall,
% fmeasure...), see:
%   Manning, Raghavan, Schütze "Introduction to Information Retrieval",
%   first edition (2008), section "8. Evaluation in information retrieval"

classifstat.accuracy = sum(indic_automat == pat_1match) / nr_codpt;
complete_class = union(pos_pat_1match, pos_manclass_automat);
overlap_class = intersect(pos_pat_1match, pos_manclass_automat);
differ_class = setdiff(complete_class, overlap_class);

classifstat.precision = length(overlap_class) / sum(pat_1match);
classifstat.recall = length(overlap_class) / sum_automat;

evalalpha = 1/2; % alpha
evalbeta_squared = (1 - evalalpha) / evalalpha; % beta squared

classifstat.fmeasure = ((evalbeta_squared + 1) * classifstat.precision * ...
    classifstat.recall) / (evalbeta_squared * classifstat.precision + ...
    classifstat.recall);


manual1_automatic0 = setdiff(pos_manclass_automat, pos_pat_1match);
automatic1_manual0 = setdiff(pos_pat_1match, pos_manclass_automat);

patents_automatic1_manual0 = manclass_data(automatic1_manual0, :);



%% Save to .mat file
% -------------------------------------------------------------------
save_name = 'patents_automatic1_manual0.mat';
save(save_name, 'patents_automatic1_manual0');    
fprintf('Saved: %s.\n', save_name)


fprintf('Differing classifications: %d/%d (%3.2f).\n', length(differ_class), ...
    length(complete_class), length(differ_class) / length(complete_class))



% Analyze those patents that were manually classified as automation patents
matches_manclasspt = nr_keyword_find(pos_manclass_automat);
matches_rest = nr_keyword_find(not(indic_automat));


%% Save contingency table to .tex
% -------------------------------------------------------------------

% Print to .txt file in Latex format
printname = 'table_contingency_classfc.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Contingency table}}\n');
fprintf(FID,'\\label{table:contingency_classifications}\n');
fprintf(FID,'\\begin{tabular}{ll|ll|l}\n');

fprintf(FID, '& \\multicolumn{4}{c}{Computerized} \\tabularnewline[0.1cm]\n');
fprintf(FID, '& & No & Yes &   \\tabularnewline\n');
fprintf(FID, '\\cline{2-5}\n');
fprintf(FID, '\\parbox[t]{2mm}{\\multirow{2}{*}{\\rotatebox[origin=c]{90}{Manual}}} & No & %d & %d & %d \\tabularnewline\n', nr_codpt - sum_automat - length(automatic1_manual0), length(automatic1_manual0), nr_codpt - sum_automat);
fprintf(FID, '& Yes & %d & %d & %d \\tabularnewline\n', length(manual1_automatic0), sum_automat - length(manual1_automatic0), sum_automat);
fprintf(FID, '\\cline{2-5}\n');
fprintf(FID, '&  & %d & %d & %d \\tabularnewline\n', nr_codpt - sum(pat_1match), sum(pat_1match), nr_codpt);

fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');

fprintf(FID,'\\floatfoot{');
fprintf(FID,'\\begin{minipage}{0.3\\textwidth}');
fprintf(FID,' \\textit{Statistics:}\\\\\n');
fprintf(FID,'Accuracy = $\\frac{%d + %d}{%d}$ = %3.2f\\\\\n', ...
    length(overlap_class), nr_codpt - sum_automat - ...
    length(automatic1_manual0), nr_codpt, ...
    classifstat.accuracy);
fprintf(FID,'Precision = $\\frac{%d}{%d}$ = %3.2f\\\\\n', ...
    length(overlap_class), sum(pat_1match), classifstat.precision);
fprintf(FID,'Recall = $\\frac{%d}{%d}$ = %3.2f\\\\\n', ...
    length(overlap_class),  sum_automat, classifstat.recall);
fprintf(FID,'$F_{\\beta = %d}$ = %3.2f\\\\\n', sqrt(evalbeta_squared), classifstat.fmeasure);
fprintf(FID,'AUC = %3.3f\n', classifstat.auc);
fprintf(FID,'\\end{minipage}}');

fprintf(FID,'\\end{table}\n');
fclose(FID); 

fprintf('___________________________________________________________\n');
fprintf('Saved: %s.\n', printname)



%% Errors over time
% -------------------------------------------------------------------
year_start = 1976;
year_end = 2015;

% Extract
for ix_year=year_start:year_end
    t = ix_year - year_start + 1;
    
    yr_pos = find(ix_year == manclass_data(:, 2));
    
    yr_indic_automat = manclass_data(yr_pos, 3);
    yr_pat_1match = manclass_data(yr_pos, end)>0;
    
    classifstat.number(t) = length(yr_pos);
    classifstat.summanclass(t) = sum(yr_indic_automat);
    classifstat.sumpat1match(t) = sum(yr_pat_1match);
    classifstat.agreerate(t) = sum(yr_indic_automat==yr_pat_1match) / ...
        length(yr_pos);
    classifstat.manautom(t) = sum(yr_indic_automat) / length(yr_pos);
    classifstat.compautom(t) = sum(yr_pat_1match) / length(yr_pos);
end


%% Plausibility checks
% -------------------------------------------------------------------
if abs(mean(classifstat.manautom) - share_automat) > 0.1 * mean(classifstat.manautom)
    warning('Quite different.')
end

if abs(mean(classifstat.compautom) - (sum(pat_1match) / nr_codpt)) > 0.1 * mean(classifstat.compautom)
    warning('Quite different.')
end


%% Save to .mat file
% -------------------------------------------------------------------
save_name = 'classifstat.mat';
save(save_name, 'classifstat');    
fprintf('Saved: %s.\n', save_name)



