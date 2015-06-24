close all
clear all
clc


load('manclassData.mat')

year_start = 1976;
year_end = 2001;


% Sort data after years. This is important as we'll later loop through
[~, ix_sort] = sort(manclassData.year);
if any(not(diff(ix_sort) == 1))
    error('Patents should already be ordered by year.')
end


nr_years = length(year_start:year_end);

all_matches = [];


% Get the dictionary of words
load('patsearch_results_1976.mat')

manclassData.matches = nan(size(manclassData.patentnr,1), ...
    length(patsearch_results.dictionary));

manclassData.dictionary = patsearch_results.dictionary;


for ix_year=year_start:year_end
    
    % Load matches for year
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
    
    
    % Find hand-coded patents for this year
    % -------------------------------------------------------------
    extract_patyrnr = manclassData.patentnr(find(manclassData.year == ...
        ix_year));
    
    for j=1:length(extract_patyrnr)
        extract_me = extract_patyrnr(j);
        extract_meStr = num2str(extract_me);
        ix_pos_ex = find(strcmp(patsearch_results.patentnr, extract_meStr));
        j_matches = patsearch_results.matches(ix_pos_ex,:);
        
        % Insert found matches into the structure for hand-coded patents
        ixManclassData = find(manclassData.patentnr == extract_me);
        manclassData.matches(ixManclassData, :) = j_matches;
    end
        
    fprintf('Found matches for hand-coded patents in year: %d.\n', ix_year)
end


%% Save to .mat file
% -------------------------------------------------------------------
save_name = 'manclassData.mat';
save(save_name, 'manclassData');    
fprintf('Saved: %s.\n', save_name)
