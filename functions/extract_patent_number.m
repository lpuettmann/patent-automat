function patent_number = extract_patent_number(nr_patents, ...
    search_corpus, ix_pnr, ftset)

% Pre-define empty cell array to hold patent numbers
patent_number = repmat({''}, nr_patents, 1);

for i=1:nr_patents
    patent_nr_line = search_corpus(ix_pnr(i), :);
    patent_nr_line = patent_nr_line{1};

    switch ftset.indic_filetype
        case 1
            if numel(patent_nr_line) < 2
                 fprintf('~~~ Correct for empty string after patent number %d/%d\n', ...
                     i, nr_patents)
                 patent_nr_line = search_corpus(ix_pnr(i) + 1, :); % jump over empty line
                 patent_nr_line = patent_nr_line{1};
                 patent_number{i} = patent_nr_line(6:14);
            else % default standard case, no line between PATN and WKU
                patent_number{i} = patent_nr_line(6:14);
            end

        case 2
            patent_nr_end = regexp(patent_nr_line, '</PDAT>'); 
            patent_number{i} = patent_nr_line(19:patent_nr_end - 1);

        case 3
            patent_nr_start = regexp(patent_nr_line, 'file="US');
            patent_nr_trunc = patent_nr_line(patent_nr_start + 8 : end);
            patent_nr_end = regexp(patent_nr_trunc, '-'); 
            patent_nr_end = patent_nr_end(1);
            patent_number{i} = patent_nr_trunc(1:patent_nr_end-1);
    end

    if numel(patent_number) < 2
        warning('There seems something wrong with the patent number.')
    end
end
