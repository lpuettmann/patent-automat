function uspc_nr = extract_classnr(patentnr, indic_year, ...
    year_start, year_end)
% For the patents in our manually coded sample, extract the USPC technology
% classification numbers.
%
%   OUT: 
%       - uspc_nr: returns a cell array of (number patents)*1 with the
%       full USPC technology numbers.
%

% Check that data is already sorted by years. This is important as we'll 
% later loop through the years.
[~, ix_sort] = sort(indic_year);
if any( not( diff(ix_sort) == 1 ) )
    error('Patents should already be ordered by year.')
end

uspc_nr = repmat({''}, size(patentnr, 1), 1);

for ix_year=year_start:year_end
    
    % Load matches for year
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
    
    % Find hand-coded patents for this year
    % -------------------------------------------------------------
    extract_patyrnr = patentnr( find( indic_year == ix_year ) );
    
    for j=1:length(extract_patyrnr)
        extract_me = extract_patyrnr(j);
        extract_meStr = num2str(extract_me);
        ix_pos_ex = find(strcmp(patsearch_results.patentnr, ...
            extract_meStr));
              
        % Insert found matches into the structure for hand-coded patents
        ixManclassData = find( patentnr == extract_me );
        
        uspc_nr{ixManclassData} = patsearch_results.classnr_uspc{ ...
            ix_pos_ex};
    end
        
    fprintf('Found tech. numbers for classified patents: %d.\n', ix_year)
end
