function [ix_find, nr_patents] = look4patents(search_corpus, ftset, ix_year, ix_week)

switch ftset.indic_filetype
    case 1
        [indic_find, nr_patents, ix_find] = special_cases_part1(...
            search_corpus, ftset.patent_findstr, ftset.nr_trunc, ix_year, ix_week);

    case 2
        indic_find = strcmp(search_corpus, ftset.patent_findstr);
        ix_find = find(indic_find);
        nr_patents = length(ix_find);

    case 3
        indic_find = regexp(search_corpus, ftset.patent_findstr);             
        emptyIndex = cellfun(@isempty, indic_find);
        indic_find(emptyIndex) = {0};
        indic_find = cell2mat(indic_find);
        % Subtract 1, as the patent text starts one line before the
        % phrase we're looking for here.
        ix_find = find(indic_find) - 1;
        nr_patents = length(ix_find);  
end


if nr_patents ~= length( unique(ix_find) )
    warning('Elements in ix_find should all be different.')
end

if nr_patents < 100
    warning('The number of patents (= %d) is implausibly small', ...
        nr_patents)
end  
