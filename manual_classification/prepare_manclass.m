function manclassData = prepare_manclass(filename)


% Load excel file
[manclass_dataRaw, ~, ~] = xlsread(filename);


%% Extract data
patentnr = manclass_dataRaw(:, 1);
indic_year = manclass_dataRaw(:, 2);
manAutomat = manclass_dataRaw(:, 3);
manCognitive = manclass_dataRaw(:, 4);
manManual = manclass_dataRaw(:, 5);
indic_NotSure = manclass_dataRaw(:, 6);
% Column 7 are comments on why not sure
% Column 8 are comments on content of patent
coderID = manclass_dataRaw(:, 9);
coderDate = manclass_dataRaw(:, 10);


%% Make some checks
if length(unique(patentnr)) ~= length(patentnr)
    warning('There are duplicate patents:')
    [duplN, duplBin] = histc(patentnr, ...
        unique(patentnr));
    duplMultiple = find(duplN > 1);
    duplIndex = manclass_dataRaw(find(ismember(duplBin, duplMultiple)), 1)
end
    
if any(not((manAutomat == 1) | (manAutomat == 0)))
    warning('There should be only 0 and 1 here.')
end

if any(not((manAutomat == 1) | (manAutomat == 0)))
    warning('There should be only 0 and 1 here.')
end

if not(isempty(find(isnan(manAutomat), 1) - 1))
    warning('There are not classified patents.')
end

% Check if there any NaN's left in the vector of classifications
if any(isnan(manAutomat))
    fprintf('Some patents not classified (NaN): %d.\n', ...
        find(isnan(manAutomat)))
end


%% Sort patents by year
[~, ix_sort] = sort( indic_year );
manclass_dataRaw = manclass_dataRaw(ix_sort, :);


%% Save data in a structure
manclassData.patentnr = patentnr;
manclassData.indic_year = indic_year;
manclassData.manAutomat = manAutomat;
manclassData.manCognitive = manCognitive;
manclassData.manManual = manManual;
manclassData.indic_NotSure = indic_NotSure;
manclassData.coderID = coderID;
manclassData.coderDate = coderDate;
