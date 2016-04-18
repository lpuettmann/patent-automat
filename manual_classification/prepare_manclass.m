function manclassData = prepare_manclass(filename)

%% Load excel file
[manclass_dataRaw, ~, ~] = xlsread(filename);

%% Sort patents by year
indic_year_unsorted = manclass_dataRaw(:, 2);
[~, ix_sort] = sort( indic_year_unsorted );
manclass_dataRaw = manclass_dataRaw(ix_sort, :);

%% Extract data
patentnr = manclass_dataRaw(:, 1);
indic_year = manclass_dataRaw(:, 2);
manAutomat = manclass_dataRaw(:, 3);
manCognitive = manclass_dataRaw(:, 4);
manManual = manclass_dataRaw(:, 5);
indic_NotSure = manclass_dataRaw(:, 6);
% Column 7 are comments, don't import them here
coderID = manclass_dataRaw(:, 8);
coderDate = manclass_dataRaw(:, 9);

%% Get list with technology numbers to be excluded from analysis

%% Make some checks
if length(unique(patentnr)) ~= length(patentnr)
    [duplN, duplBin] = histc(patentnr, ...
        unique(patentnr));
    duplMultiple = find(duplN > 1);
    duplIndex = manclass_dataRaw(find(ismember(duplBin, duplMultiple)), 1)
    error('There are duplicate patents.')
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

if any( diff(indic_year) < 0 )
    warning('Years should be increasing.')
end

%% Save data in a structure
manclassData.patentnr = patentnr;
manclassData.indic_year = indic_year;
manclassData.manAutomat = manAutomat;
manclassData.manCognitive = manCognitive;
manclassData.manManual = manManual;
manclassData.indic_NotSure = indic_NotSure;
manclassData.coderID = coderID;
manclassData.coderDate = coderDate;
