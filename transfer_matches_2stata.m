clc
clear all
close all

tic

addpath('matches');
addpath('functions');


year = 2001;


% Load matches
load_file_name = horzcat('patent_keyword_appear_', num2str(year));
load(load_file_name)


cleaned_full_info = patent_keyword_appear;



% Number of patents per year
nr_patents_yr = size(patent_keyword_appear, 1);


% Extract keyword matches per patent
nr_keyword_per_patent = cell2mat(patent_keyword_appear(:, 2));

patent_numbers = patent_keyword_appear(:, 1);
    
ix_save = 1; % initalize saving index

for ix_patent = 1:nr_patents_yr

    extract_row = patent_numbers{ix_patent}

    if strcmp(extract_row(1), 'D')
       save_row_delete(ix_save) = ix_patent;
       ix_save = ix_save + 1;
    end
end




toc




