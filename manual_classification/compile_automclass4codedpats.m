function compile_automclass4codedpats(manclassData, ...
    year_start, year_end)

% Sort data after years. This is important as we'll later loop through
[~, ix_sort] = sort(manclassData.indic_year);
if any( not( diff(ix_sort) == 1 ) )
    error('Patents should already be ordered by year.')
end


nr_years = length(year_start:year_end);

all_matches = [];


% Get the dictionary of words
load('patsearch_results_1976.mat')

automclassData.title_matches = nan( size(manclassData.patentnr, 1), ...
    length(patsearch_results.dictionary) );

automclassData.abstract_matches = nan( size(manclassData.patentnr, 1), ...
    length(patsearch_results.dictionary) );

automclassData.body_matches = nan( size(manclassData.patentnr, 1), ...
    length(patsearch_results.dictionary) );

automclassData.dictionary = patsearch_results.dictionary;


for ix_year=year_start:year_end
    
    % Load matches for year
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
    
    
    % Find hand-coded patents for this year
    % -------------------------------------------------------------
    extract_patyrnr = manclassData.patentnr( find( ...
        manclassData.indic_year == ix_year ) );
    
    for j=1:length(extract_patyrnr)
        extract_me = extract_patyrnr(j);
        extract_meStr = num2str(extract_me);
        ix_pos_ex = find(strcmp(patsearch_results.patentnr, extract_meStr));
              
        % Insert found matches into the structure for hand-coded patents
        ixManclassData = find( manclassData.patentnr == extract_me );
        
        automclassData.title_matches(ixManclassData, :) = ...
            patsearch_results.title_matches(ix_pos_ex, :);
        
        automclassData.abstract_matches(ixManclassData, :) = ...
            patsearch_results.abstract_matches(ix_pos_ex, :);
        
        automclassData.body_matches(ixManclassData, :) = ...
            patsearch_results.body_matches(ix_pos_ex, :);        
    end
        
    fprintf('Found matches and technology numbers for hand-coded patents in year: %d.\n', ...
        ix_year)
end


if any( isnan( automclassData.body_matches(:) ) )
    warning('There are NaN in body_matches of automclassData.')
end

% Save to .mat
save_name = 'output/automclassData.mat';
save(save_name, 'automclassData');    
fprintf('Saved: %s.\n', save_name)
