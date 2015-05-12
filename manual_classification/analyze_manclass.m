close all
clear all
clc



% Load excel file
[manclass_data, txt, ~] = xlsread('manclass_FULL.xlsx');


% Figure out how many patents have been classified yet
indic_automat = manclass_data(:, 3);

last_codpt = find(isnan(indic_automat), 1) - 1;
indic_automat = indic_automat(1:last_codpt);

% Truncate until last coded patent
manclass_data = manclass_data(1:last_codpt, :);


% Check if there any NaN's left in the vector of classifications
if any(isnan(indic_automat))
    fprintf('Some patents not classified (NaN): %d.\n', ...
        find(isnan(indic_automat)))
end


nr_codpt = length(indic_automat);
sum_automat = sum(indic_automat);
share_automat = sum_automat / nr_codpt;

fprintf('Number patents manually coded: %d, of those %d (%3.2f) automation patents.\n', ...
    nr_codpt, sum_automat, share_automat)


% Compare manual classification with automated keyword search
nr_keyword_find = manclass_data(:, 7); % extract number of keyword matches
% Find patents with at least 1 match
pat_1match = (nr_keyword_find > 0); % the plus converts logical to double 

pos_manclass_automat = find(indic_automat);
pos_pat_1match = find(pat_1match);

complete_class = union(pos_pat_1match, pos_manclass_automat);
overlap_class = intersect(pos_pat_1match, pos_manclass_automat);
differ_class = setdiff(complete_class, ...
    overlap_class);

fprintf('___________________________________________________________\n');
fprintf('<strong>Comparison of manual and automatical patent classification</strong>\n');
fprintf('  \n')
fprintf('Same classifications: %d (%3.2f).\n', length(overlap_class), ...
    length(overlap_class) / length(complete_class))
fprintf('Differing classifications: %d (%3.2f).\n', length(differ_class), ...
    length(differ_class) / length(complete_class))



% Analyze those patents that were manually classified as automation patents
matches_manclasspt = nr_keyword_find(pos_manclass_automat)

matches_rest = nr_keyword_find(not(indic_automat))













