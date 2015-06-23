close all
clear all
clc



year_start = 1976;
year_end = 1990;


for ix_year = year_start:year_end
    
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)
    
    nr_patents = size(patent_keyword_appear.patentnr, 1);
    
    unique_nrpat = unique(patent_keyword_appear.patentnr);
    
    if not(size(unique_nrpat) == size(nr_patents))
        warning('There are duplicates.')
    end
    
    
    if any(diff(find((cell2mat(patent_keyword_appear.week) == 1))) > 1)
        warning('Week 1 appears not consecutively.')
        fprintf('Changes: %d.\n', find(diff(find((cell2mat( ... 
            patent_keyword_appear.week) == 1))) > 1))
    end
                
    
    tableMatches = table(sum(patent_keyword_appear.matches,1)', ...
        'RowNames', patent_keyword_appear.dictionary, 'Variablenames', ...
        {'number_of_matches'});
    
    fprintf('\t<strong>Year: %d</strong>\n', ix_year)
    fprintf('\tNumber of patents: %d.\n', nr_patents)
    disp(tableMatches)
    disp('--------------------------------------------------------------')
end










