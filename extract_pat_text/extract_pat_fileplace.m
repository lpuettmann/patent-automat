function patextr = extract_pat_fileplace(patentnr, indic_year)

% Run some checks

% Check that data is already sorted by years. This is important as we'll 
% later loop through the years.10
[~, ix_sort] = sort(indic_year);
if any( not( diff(ix_sort) == 1 ) )
    error('Patents should already be ordered by year.')
end

assert( isnumeric(patentnr) )
assert( isnumeric(indic_year) )
assert( length(patentnr) == length(indic_year) )
assert( year_start < year_end )


% Find out which file the patent text belong to the patent number is in

% for j=1:length(patentnr)
for j=1:3
    patextr.patentnr(j, 1) = patentnr(j);
    patextr.indic_year(j, 1) = indic_year(j);

    % Load patent index for year
    % -------------------------------------------------------------
    load_file_name = horzcat('patent_index_', num2str(patextr.indic_year(j)));
    load(load_file_name)

    for i=1:size(pat_ix, 1)         
        ix_match = strfind(pat_ix{i, 1}, num2str( patextr.patentnr(j) ) );
        nr_pat_in_file = find( ~cellfun('isempty', ix_match) );

        if not( isempty( nr_pat_in_file ) ) 
            patextr.nr_pat_in_file(j, 1) = nr_pat_in_file;
            patextr.week(j, 1) = i;
            patextr.line_start(j, 1) = pat_ix{i, 2}(nr_pat_in_file);

            if nr_pat_in_file < size(pat_ix{i, 2}, 1)
                patextr.line_end(j, 1) = pat_ix{i, 2}(nr_pat_in_file + 1);

            elseif nr_pat_in_file == size(pat_ix{i, 2}, 1)
                warning('Patent is last in list. There could be a problem with finding the end of the text corpus.')
                patextr.line_end(j, 1) = NaN;

            else
                error('Should not be reached [patent number: %d, week: %d].', ...
                    patextr.patentnr(j), i)
            end
        end
    end
    
    fprintf('%d/%d.\n', j, length(patentnr))
end
