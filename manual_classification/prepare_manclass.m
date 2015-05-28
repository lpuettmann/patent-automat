close all
clear all
clc

addpath('../functions')
addpath('../cleaned_matches')

% Load excel file
[manclass_data, ~, ~] = xlsread('manclass_consolidated.xlsx');

% Figure out how many patents have been classified yet
indic_automat = manclass_data(:, 3);


%% Make some checks
if length(unique(manclass_data(:, 1))) ~= length(manclass_data(:, 1))
    warning('There are duplicate patents.')
end

if any(not((indic_automat == 1) | (indic_automat == 0)))
    warning('There should be only 0 and 1 here.')
end

if any(not((indic_automat == 1) | (indic_automat == 0)))
    warning('There should be only 0 and 1 here.')
end

if not(isempty(find(isnan(indic_automat), 1) - 1))
    warning('There are not classified patents.')
end

% Check if there any NaN's left in the vector of classifications
if any(isnan(indic_automat))
    fprintf('Some patents not classified (NaN): %d.\n', ...
        find(isnan(indic_automat)))
end


%% Extract those patents that don't have tech class numbers yet
indic_pat_no_technr = isnan(manclass_data(:,8));

pat_no_technr = manclass_data(find(indic_pat_no_technr), :);
pat_with_technr = manclass_data(find(not(indic_pat_no_technr)), :);


%% Sort data by years. IMPORTANT: We'll later loop through them.
[~, ix_sort] = sort(pat_no_technr(:,2));
pat_no_technr = pat_no_technr(ix_sort, :);

patent_numbers = pat_no_technr(:, 1);
patent_years = pat_no_technr(:, 2);

year_start = 1976;
year_end = 2015;
nr_years = length(year_start:year_end);

all_technr = [];

ix_extract_start = 1;


%% Extract the technology numbers for patents
for ix_year=year_start:year_end
    
    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
    
    patentyr_numbers = patsearch_results(:, 1);
    patentyr_technr = patsearch_results(:, 3);
    
    nr_yearlength = length(find(patent_years == ix_year));
    
    ix_extract_stop = ix_extract_start + nr_yearlength - 1;
    
    extract_patyrnr = patent_numbers(ix_extract_start:ix_extract_stop);
    
    if length(extract_patyrnr) ~= nr_yearlength
        warning('Check if length is right.')
    end
    
    j_technr = zeros(nr_yearlength,1);
    
    for j=1:length(extract_patyrnr)
        extract_me = extract_patyrnr(j,:);
        extract_me = num2str(extract_me);
        ix_pos_ex = find(strcmp(patentyr_numbers, extract_me));
        j_technr(j) = str2num(patentyr_technr{ix_pos_ex});
    end
    all_technr = [all_technr; j_technr];
    
    ix_extract_start = ix_extract_stop + 1;
    
    fprintf('Year finished: %d.\n', ix_year)
end


%% Check that extracted series have right size
if not(length(patent_years) == length(all_technr))
    warning('Should have same length.')
end

pat_no_technr = [pat_no_technr, all_technr];

% Reattach those patents that already before had their tech classes
manclass_data = [pat_no_technr;
                pat_with_technr];

%% Save to .mat file
% -------------------------------------------------------------------
save_name = 'manclass_data.mat';
save(save_name, 'manclass_data');    
fprintf('Saved: %s.\n', save_name)







