function ix_pnr = get_patent_number_line(ix_find, search_corpus, ftset) 

switch ftset.indic_filetype
    case 1
        % For the first filetype 1976-2015, the patent number always
        % appears one below where the new patent grant texts starts.
        ix_pnr = ix_find + 1; 

    case {2, 3}
        indic_class_pnr = regexp(search_corpus, ftset.pnr_find_str);
        indic_class_pnr = ~cellfun(@isempty, ftset.indic_class_pnr); % make logical array
        ix_pnr = find( ftset.indic_class_pnr );
end

if not( length(ix_find) == length(ix_pnr) )
    warning('Number of patents should be equal when searching for both terms.')
end

if not( length(indic_class_pnr) == size(search_corpus, 1))
    warning('Should be equal.')
end
