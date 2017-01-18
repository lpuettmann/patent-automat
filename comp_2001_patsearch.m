clear all
close all


% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()

% Choose years 
ix_year = 2001;

% parent_dname = 'T:/Puettmann/patent_project/2001_compare_data';

load('comp_2001/patent_index_2001_comp')
load('specs/find_dictionary.mat')

opt2001 = 'xml';

patent_keyword_appear = analyze_patent_text(ix_year, find_dictionary, ...
    opt2001, pat_ix)