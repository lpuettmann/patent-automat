close all
clear all
clc


% Add path to functions
% -------------------------------------------------------------------
addpath('functions');


% Set some inputs
% -------------------------------------------------------------------
year_start = 1920;
year_end = 1929;


% Add path to filse
% -------------------------------------------------------------------
build_data_path = horzcat('T:\Puettmann\patent_OCRdata_save\', ...
    strcat(num2str(year_start), '_', num2str(year_end)));
addpath(build_data_path);


% Get names of files
% -------------------------------------------------------------------
liststruct = dir(build_data_path);
filenames = {liststruct.name};
filenames = filenames(3:end)'; % truncate first elements . and ..
filenames = ifmac_truncate_more(filenames);

if length(year_start:year_end) ~= length(filenames)
    warning('Should be same number of years as files.')
end


ix_year = 1920;
iter = ix_year - year_start + 1;

choose_file_open = filenames{iter};


unique_file_identifier = fopen(choose_file_open, 'r');  

%% Load the patent text
tic
open_file_aux = textscan(unique_file_identifier, '%s', ...
    'delimiter', '\n');
fprintf('Time to *textscan* "%s": %3.1f seconds.\n', choose_file_open, toc)

file_str = open_file_aux{1,1};



%% Inspect files

%% Print first lines of document
clc
disp('-------------------------------------------------------------------')
pick_line2startshow = 1;
nr_lines2show = 500;
disp( file_str(pick_line2startshow:pick_line2startshow+nr_lines2show, :) );
disp('-------------------------------------------------------------------')


%%
nr_lines = size(file_str, 1);
fprintf('Number of lines in document: %d (%3.1f million).\n', nr_lines, ...
    nr_lines / 1000000)


% As a test, extract some lines from the document
explore_lines = round(nr_lines * 0.1);
search_corpus = file_str(1:explore_lines, :);

% 60.6 seconds for 28. mio lines, 55817 occurences. 


tic
[indic_find, nr_patents, ix_find] = count_nr_patents(...
    search_corpus, '*** BRS DOCUMENT BOUNDARY ***'); 
fprintf('Time to count patents: %3.2f seconds.\n', toc)

fprintf('Number of occurences of keyphrase found: %d.\n', nr_patents)






%%
% fclose(unique_file_identifier);
% check_open_files








