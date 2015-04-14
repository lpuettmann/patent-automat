
clc
clear all
close all

tic

addpath('matches');
addpath('functions');

%%
year_start = 1976;
year_end = 1976;


%%

for ix_year = year_start:year_end

    % Load matches
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)

end



fprintf('Finished, time = %d.', toc)
