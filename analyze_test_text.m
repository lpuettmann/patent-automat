clc
clear all
close all


addpath('functions');
addpath('data');


%% Define keyword to look for
% ========================================================================
% find_string = 'automat.';
find_str = 'support';



%% Load the patent website's description text into string
% ========================================================================

open_file_aux = textscan(fopen('patent_testsample.txt', 'r'), '%s','delimiter', '\n');
find_str = open_file_aux{1,1};



ix_find = regexpi(find_str, find_str);
ix_find = ix_find(~cellfun('isempty',ix_find));


nr_find = length(ix_find);

fprintf('Number of times appearance of string: %d.\n', nr_find)
disp('-----------------------------------------------------------------')


% For keyword "support"
% file_string(210)
% file_string(385)



