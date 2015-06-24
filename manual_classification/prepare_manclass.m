close all
clear all
clc

% Load excel file
[manclass_dataRaw, ~, ~] = xlsread('manclass_consolidated.xlsx');

% Figure out how many patents have been classified yet
indic_automat_unsorted = manclass_dataRaw(:, 3);


%% Make some checks
if length(unique(manclass_dataRaw(:, 1))) ~= length(manclass_dataRaw(:, 1))
    warning('There are duplicate patents:')
    [duplN, duplBin] = histc(manclass_dataRaw(:, 1), ...
        unique(manclass_dataRaw(:, 1)));
    duplMultiple = find(duplN > 1);
    duplIndex = manclass_dataRaw(find(ismember(duplBin, duplMultiple)), 1)
end
    
if any(not((indic_automat_unsorted == 1) | (indic_automat_unsorted == 0)))
    warning('There should be only 0 and 1 here.')
end

if any(not((indic_automat_unsorted == 1) | (indic_automat_unsorted == 0)))
    warning('There should be only 0 and 1 here.')
end

if not(isempty(find(isnan(indic_automat_unsorted), 1) - 1))
    warning('There are not classified patents.')
end

% Check if there any NaN's left in the vector of classifications
if any(isnan(indic_automat_unsorted))
    fprintf('Some patents not classified (NaN): %d.\n', ...
        find(isnan(indic_automat_unsorted)))
end


% Check if tech classification numbers are missing
if any(isnan(manclass_dataRaw(:,8)))
    warning('Some tech classification numbers (''OCL'') are missing.')
end


% Sort patents by year
[~, ix_sort] = sort(manclass_dataRaw(:,2));
manclass_dataRaw = manclass_dataRaw(ix_sort, :);


%% Save data in a structure
manclassData.patentnr = manclass_dataRaw(:, 1);
manclassData.year = manclass_dataRaw(:, 2);
manclassData.manAutomat = manclass_dataRaw(:, 3);
manclassData.manCognitive = manclass_dataRaw(:, 4);
manclassData.manManual = manclass_dataRaw(:, 5);
% Column 6 were the comments
% Leave out the matches (we'll later add matchse for all dictionary)
manclassData.classnr = manclass_dataRaw(:, 8);
manclassData.coderID = manclass_dataRaw(:, 9);
manclassData.coderDate = manclass_dataRaw(:, 10);



%% Save to .mat file
% -------------------------------------------------------------------
save_name = 'manclassData.mat';
save(save_name, 'manclassData');    
fprintf('Saved: %s.\n', save_name)
