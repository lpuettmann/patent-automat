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
    [indic_find, nr_patents, ix_find] = count_nr_patents(...
        search_corpus, patent_findstr); % not truncated
end