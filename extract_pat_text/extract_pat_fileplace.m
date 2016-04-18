function patfplace = extract_pat_fileplace(patentnr, indic_year)

%% Run some checks
% -------------------------------------------------------------

% Check that data is already sorted by years. This is important as we'll 
% later loop through the years.
[~, ix_sort] = sort(indic_year);

if any( not( diff(ix_sort) == 1 ) )
    error('Patents should already be ordered by year.')
end

assert( isnumeric(patentnr), 'Patent number should be numeric.' )
assert( isnumeric(indic_year) )
assert( length(patentnr) == length(indic_year) )


%% Find out which file the patent text belong to the patent number is in
% -------------------------------------------------------------

for j=1:length(patentnr)

    % Load patent index for year
    load_file_name = horzcat('patent_index_', num2str(indic_year(j)));
    load(load_file_name)

    for i=1:size(pat_ix, 1)         
        ix_match = strfind(pat_ix{i, 1}, num2str( patentnr(j) ) );
        nr_pat_in_file = find( ~cellfun('isempty', ix_match) );

        assert( length(nr_pat_in_file) <= 1, ...
            'The patent should only be found once in the patent index [patent number: %d, week: %d].', ...
            patentnr(j), i)
        
        if not( isempty( nr_pat_in_file ) ) 
            patfplace.nr_pat_in_file(j, 1) = nr_pat_in_file;
            patfplace.week(j, 1) = i;
            
            % Save information on technology classification numbers (USPC
            % and IPC)
            patfplace.uspc_nr(j, 1) = pat_ix{i, 3}(nr_pat_in_file);
            patfplace.ipc_nr(j, 1) = pat_ix{i, 5}(nr_pat_in_file);
            
            % Save on which line of weekly text file this patent starts and
            % ends
            patfplace.line_start(j, 1) = pat_ix{i, 2}(nr_pat_in_file);

            if nr_pat_in_file < size(pat_ix{i, 2}, 1)
                patfplace.line_end(j, 1) = pat_ix{i, 2}(nr_pat_in_file + 1);

            elseif nr_pat_in_file == size(pat_ix{i, 2}, 1)
                warning('Patent is last in list. There could be a problem with finding the end of the text corpus.')
                patfplace.line_end(j, 1) = NaN;

            else
                error('Should not be reached [patent number: %d, week: %d].', ...
                    patentnr(j), i)
            end
        end
    end
    
    fprintf('%d/%d.\n', j, length(patentnr))
end
