function [ix_find, nr_patents] = look4patents(search_corpus, ftset, ...
    ix_year, ix_week)

    switch ftset.indic_filetype
        case 1
            [indic_find, nr_patents, ix_find] = special_cases_part1(...
                search_corpus, ftset.patent_findstr, ftset.nr_trunc, ...
                ix_year, ix_week);

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
end


function [indic_find, nr_patents, ix_find] = special_cases_part1(...
        search_corpus, patent_findstr, nr_trunc, ix_year, ix_week)

    if ix_year == 2001 % special case: problem with 80 numel text file
        fprintf('*** Enter special case, year: %d, week: %d.\n', ix_year, ix_week)

        [indic_find, nr_patents, ix_find] = count_nr_patents_trunccorpus(...
            search_corpus, patent_findstr, nr_trunc);           

    % Something is wrong in year 1978
    elseif ix_year == 1978 && (ix_week == 25 | ix_week == 26)  
        fprintf('*** Enter special case, year: %d, week: %d.\n', ix_year, ix_week)

        [indic_find, nr_patents, ix_find] = count_nr_patents_trunccorpus(...
            search_corpus, patent_findstr, nr_trunc);  

      elseif ix_year == 1979 && (ix_week == 11 | ix_week == 12)
        fprintf('*** Enter special case, year: %d, week: %d.\n', ix_year, ix_week)

        [indic_find, nr_patents, ix_find] = count_nr_patents_trunccorpus(...
            search_corpus, patent_findstr, nr_trunc);  

      % I can probably delete the following special case: 
      % The problem was with the empty lines in week 50

     elseif ix_year == 1984 && (ix_week == 1 | ix_week == 49 ...
             | ix_week == 50) 
         fprintf('*** Enter special case, year: %d, week: %d.\n', ix_year, ix_week)

        [indic_find, nr_patents, ix_find] = count_nr_patents_trunccorpus(...
            search_corpus, patent_findstr, nr_trunc);  

    elseif ix_year == 1997 && (ix_week >= 38) 
        fprintf('*** Enter special case, year: %d, week: %d.\n', ix_year, ix_week)

        [indic_find, nr_patents, ix_find] = count_nr_patents_trunccorpus(...
            search_corpus, patent_findstr, nr_trunc);  

    elseif ix_year == 1998
        fprintf('*** Enter special case, year: %d, week: %d.\n', ix_year, ix_week)

        [indic_find, nr_patents, ix_find] = count_nr_patents_trunccorpus(...
        search_corpus, patent_findstr, nr_trunc);  

    else
        [indic_find, nr_patents, ix_find] = count_occurences(...
            search_corpus, patent_findstr); % not truncated
    end
end


function [indic_find, nr_patents, ix_find] = ...
        count_nr_patents_trunccorpus(search_corpus, find_str, nr_trunc)

    search_corpus_trunc = truncate_corpus(search_corpus, nr_trunc);
    
    [indic_find, nr_patents, ix_find] = count_occurences(...
        search_corpus_trunc, find_str);
end