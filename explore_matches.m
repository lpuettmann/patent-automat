close all
clear all
clc

addpath('matches')

ix_year = 1976;

load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
load(load_file_name)


%%
tableMatches = table(sum(patent_keyword_appear.matches,1)', 'RowNames', ...
    patent_keyword_appear.dictionary, 'Variablenames', ...
    {'number_of_matches'});

disp(tableMatches)




