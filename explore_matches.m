close all
clear all
clc



year_start = 1976;
year_end = 1990;


for ix_year = year_start:year_end
    
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)
    
        
    tableMatches = table(sum(patent_keyword_appear.matches,1)', ...
        'RowNames', patent_keyword_appear.dictionary, 'Variablenames', ...
        {'number_of_matches'});
    
    fprintf('\tYear: %d', ix_year)
    disp(tableMatches)
    disp('--------------------------------------------------------------')
end










