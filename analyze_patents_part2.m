close all
clear all
clc



%% Add path to functions
addpath('functions');



%% Set some inputs
year_start = 2003;
year_end = 2003;



%% Go
% ========================================================================
ix_year = year_start;
tic


build_data_path = horzcat('.\data2\', num2str(ix_year));
addpath(build_data_path);


% Get names of files
% -------------------------------------------------------------------
liststruct = dir(build_data_path);
filenames = {liststruct.name};
filenames = filenames(3:end)'; % truncate first elements . and ..


ix_week = 1;
choose_file_open = filenames{ix_week};

% Load the patent text
unique_file_identifier = fopen(choose_file_open, 'r');   

if unique_file_identifier == -1
    warning('Matlab cannot open the file')
end

open_file_aux = textscan(unique_file_identifier, '%s', ...
    'delimiter', '\n');
file_str = open_file_aux{1,1};


% Define new search corpus as we might change some things about this
search_corpus = file_str; 


% Count number of patents in a given week
% --------------------------------------------------------------------
[indic_find, nr_patents, ix_find] = count_nr_patents(...+
    search_corpus, 'PATN'); 

% Test: did not find patents
if nr_patents < 100
    warning(['The number of patents (= %d) is implausibly small'], ...
        nr_patents)
end    

   


%% End
% ======================================================================
disp('*** end ***')
