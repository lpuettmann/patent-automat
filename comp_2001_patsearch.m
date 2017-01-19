clear all
close all


% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()

% Choose years 
ix_year = 2001;

% Load patent index
load('./comp_2001/patent_index_2001_comp.mat')

% Import xml version
load('./comp_2001/patent_keyword_appear_2001.mat')

% Clean matches
patsearch_results = clean_matches(pat_ix, patent_keyword_appear, ix_year)

break

pat_xml = patent_keyword_appear;
clear patent_keyword_appear



% Import txt version
load('./matches/patent_keyword_appear_2001.mat')
pat_txt = patent_keyword_appear;


l_txt = length(pat_txt.patentnr);
l_xml = length(pat_txt.patentnr);

fprintf('# patents txt: %d, # patents xml: %d (change: %3.1f percent).\n', ...
    l_txt, l_xml, l_txt / l_xml * 100 - 100)



% Delete last string 
% load('./cleaned_matches/patsearch_results_2001.mat')








