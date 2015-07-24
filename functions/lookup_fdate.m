function fdate = lookup_fdate(search_corpus, ftset, ix_find, nr_patents)
% Look up filing date

fdate = repmat({''}, nr_patents, 1);

switch ftset.indic_filetype
    case {1, 2}
        indic_fdate_find = regexp(search_corpus, ftset.fdate_findstr);
        indic_fdate_find = ~cellfun(@isempty, indic_fdate_find);
        ix_fdate_find = find(indic_fdate_find);
    
        for ix_patent=1:nr_patents
            switch ftset.indic_filetype
                case 1
                    patl = ix_find(ix_patent);
                    showLarger = find((patl < ix_fdate_find));
                    firstLarger = showLarger(1);
                    ix_fdate = ix_fdate_find(firstLarger);
                    fdate_line = search_corpus{ix_fdate, :};
                    fdate{ix_patent} = fdate_line(ftset.fdate_linestart: ...
                        ftset.fdate_linestop); % don't save the filing day

                case 2
                    ix_fdate = ix_fdate_find(ix_patent);
                    fdate_line = search_corpus{ix_fdate, :};
                    fdate{ix_patent} = fdate_line(ftset.fdate_linestart: ...
                        ftset.fdate_linestop); % don't save the filing day
            end
        end  
        
    case 3
        for ix_patent=1:nr_patents
            patent_text_corpus = get_patent_text_corpus(ix_find, ...
                ix_patent, nr_patents, ftset, search_corpus);

            find_fdate_str1 = '</doc-number>';
            find_fdate_str2 = '<date>';

            indic_fdate_find1 = strfind(patent_text_corpus, find_fdate_str1);
            indic_fdate_find1 = ~cellfun(@isempty, indic_fdate_find1);
            ix_fdate_find1 = find(indic_fdate_find1);
            nextline = patent_text_corpus(ix_fdate_find1 + 1);

            indic_fdate_find = strfind(nextline, find_fdate_str2);
            indic_fdate_find = ~cellfun(@isempty, indic_fdate_find);
            ix_fdate_find = find(indic_fdate_find);
            extract_lines = nextline(ix_fdate_find);
            fdate_line = extract_lines{1}; % take the first occurence
            fdate_extract = fdate_line(ftset.fdate_linestart: ...
                ftset.fdate_linestop);

            % Stack information for all patents in a week under each other
            fdate{ix_patent} = fdate_extract; % not fdate{ix_patent,1} ???
        end
end
