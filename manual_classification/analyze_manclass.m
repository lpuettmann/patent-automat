close all
clear all
clc



% Load excel file
[manclass_data, txt, ~] = xlsread('manclass_consolidated.xlsx');


% Figure out how many patents have been classified yet
indic_automat = manclass_data(:, 3);


if any(not((indic_automat == 1) | (indic_automat == 0)))
    warning('There should be only 0 and 1 here.')
end


last_codpt = find(isnan(indic_automat), 1) - 1;

if not(isempty(last_codpt))
    % Truncate until last coded patent
    indic_automat = indic_automat(1:last_codpt);
    manclass_data = manclass_data(1:last_codpt, :);
end


% Check if there any NaN's left in the vector of classifications
if any(isnan(indic_automat))
    fprintf('Some patents not classified (NaN): %d.\n', ...
        find(isnan(indic_automat)))
end


nr_codpt = length(indic_automat);
sum_automat = sum(indic_automat);
share_automat = sum_automat / nr_codpt;


% Compare manual classification with automated keyword search
nr_keyword_find = manclass_data(:, 7); % extract number of keyword matches
% Find patents with at least 1 match
pat_1match = (nr_keyword_find > 0); % the plus converts logical to double 

pos_manclass_automat = find(indic_automat);
pos_pat_1match = find(pat_1match);

% Calculate the overall agreement rate
agree_rate = sum(indic_automat == pat_1match) / nr_codpt;

complete_class = union(pos_pat_1match, pos_manclass_automat);
overlap_class = intersect(pos_pat_1match, pos_manclass_automat);
differ_class = setdiff(complete_class, overlap_class);

manual1_automatic0 = setdiff(pos_manclass_automat, pos_pat_1match);
automatic1_manual0 = setdiff(pos_pat_1match, pos_manclass_automat);


fprintf('___________________________________________________________\n');
fprintf('<strong>Comparison of manual and automatical patent classification</strong>\n');
fprintf('  \n')

fprintf('Number patents manually coded: %d.\n', ...
    nr_codpt)
fprintf('Of those manually classified as automation patents: %d (%3.2f) .\n', ...
   sum_automat, share_automat)
fprintf('Of those automatically classified as automation patents: %d (%3.2f) .\n', ...
   sum(pat_1match), sum(pat_1match) / nr_codpt)

fprintf('Overall agreement: %d/%d (%3.2f).\n', ...
    sum(indic_automat == pat_1match), nr_codpt, agree_rate)
fprintf('Same classifications: %d/%d (%3.2f).\n', length(overlap_class), ...
    length(complete_class), length(overlap_class) / length(complete_class))
fprintf('manual1_automatic0: %d.\n', length(manual1_automatic0))
fprintf('automatic1_manual0: %d.\n', length(automatic1_manual0))


fprintf('Differing classifications: %d/%d (%3.2f).\n', length(differ_class), ...
    length(complete_class), length(differ_class) / length(complete_class))



% Analyze those patents that were manually classified as automation patents
matches_manclasspt = nr_keyword_find(pos_manclass_automat);
matches_rest = nr_keyword_find(not(indic_automat));















