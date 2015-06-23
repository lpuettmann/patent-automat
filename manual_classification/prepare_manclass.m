close all
clear all
clc

% Load excel file
[manclass_dataRaw, ~, ~] = xlsread('manclass_consolidated.xlsx');

% Figure out how many patents have been classified yet
manclassData.indic_automat = manclass_dataRaw(:, 3);



%% Make some checks
if length(unique(manclass_dataRaw(:, 1))) ~= length(manclass_dataRaw(:, 1))
    warning('There are duplicate patents:')
    [duplN, duplBin] = histc(manclass_dataRaw(:, 1), ...
        unique(manclass_dataRaw(:, 1)));
    duplMultiple = find(duplN > 1);
    duplIndex = manclass_dataRaw(find(ismember(duplBin, duplMultiple)), 1)
end
    
if any(not((manclassData.indic_automat == 1) | (manclassData.indic_automat == 0)))
    warning('There should be only 0 and 1 here.')
end

if any(not((manclassData.indic_automat == 1) | (manclassData.indic_automat == 0)))
    warning('There should be only 0 and 1 here.')
end

if not(isempty(find(isnan(manclassData.indic_automat), 1) - 1))
    warning('There are not classified patents.')
end

% Check if there any NaN's left in the vector of classifications
if any(isnan(manclassData.indic_automat))
    fprintf('Some patents not classified (NaN): %d.\n', ...
        find(isnan(manclassData.indic_automat)))
end


% Check if tech classification numbers are missing
if any(isnan(manclass_dataRaw(:,8)))
    warning('Some tech classification numbers (''OCL'') are missing.')
end

%% Save data in a structure
manclassData.patentnr = manclass_dataRaw(:, 1);
manclassData.classnr = manclass_dataRaw(:, 8);
manclassData.year = manclass_dataRaw(:, 2);
manclassData.coderID = manclass_dataRaw(:, 9);
manclassData.coderDate = manclass_dataRaw(:, 10);
manclassData.matches = manclass_dataRaw(:, 7);
manclassData.manClass = manclass_dataRaw(:, 3);
manclassData.manCognitive = manclass_dataRaw(:, 4);
manclassData.manManual = manclass_dataRaw(:, 5);


%% Save to .mat file
% -------------------------------------------------------------------
save_name = 'manclassData.mat';
save(save_name, 'manclassData');    
fprintf('Saved: %s.\n', save_name)
