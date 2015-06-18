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

% Load the patent text
unique_file_identifier = fopen(choose_file_open, 'r');  

tic
open_file_aux = textscan(unique_file_identifier, '%s', ...
    'delimiter', '\n');
fprintf('Time to *textscan* "%s": %3.1fs.\n', choose_file_open, toc)

file_str = open_file_aux{1,1};



%% Inspect files

% Print first 100 lines of document
disp( file_str(1:100, :) )



% As a test, extract some lines from the document
search_corpus = file_str(1:50000, :);





[indic_find, nr_patents, ix_find] = count_nr_patents(...
    search_corpus, 'PATN'); 




%%
% fclose(unique_file_identifier);
% check_open_files








