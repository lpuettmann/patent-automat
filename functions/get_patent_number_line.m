function ix_pnr = get_patent_number_line(ix_find, search_corpus, ftset, ...
    nr_patents) 

switch ftset.indic_filetype
    case 1
        % For the first filetype 1976-2015, the patent number always
        % appears one below where the new patent grant texts starts.
        ix_pnr = ix_find + 1; 

    case {2, 3}
        ix_pnr = get_ix_cellarray_str(search_corpus, ftset.pnr_find_str);
end

if not( nr_patents == length(ix_pnr) )
    warning('Number of patents should be equal when searching for both terms.')
end
