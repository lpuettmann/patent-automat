function extract_pat_text(patentnr, indic_year, year_start, year_end)

%% Run some checks
% Check that data is already sorted by years. This is important as we'll 
% later loop through the years.
[~, ix_sort] = sort(indic_year);
if any( not( diff(ix_sort) == 1 ) )
    error('Patents should already be ordered by year.')
end

assert(isnumeric(patentnr))
assert(isnumeric(indic_year))
assert(length(patentnr) == length(indic_year))
assert(year_start < year_end)


%% Find out which file the patent text belong to the patent number is in

pick_patentnr = patentnr(1);
ix_year = indic_year(1);



% Load patent index for year
% -------------------------------------------------------------
load_file_name = horzcat('patent_index_', num2str(ix_year));
load(load_file_name)

patentnr_list = [];
for i=1:size(pat_ix, 1)
    patentnr_list = [patentnr_list; 
                     pat_ix{i, 1}];
end

ix_match = strfind(patentnr_list, num2str( pick_patentnr ) );
ix_find = find( ~cellfun('isempty', ix_match) );



%%





