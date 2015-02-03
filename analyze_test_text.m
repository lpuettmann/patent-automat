clc
clear all
close all


addpath('functions');
addpath('data');


%% Define keyword to look for
% ========================================================================
% find_string = 'automat.';
find_string = 'support';



%% Load the patent website's description text into string
% ========================================================================

fid  = fopen('patent_testsample.txt', 'r');
C = textscan(fid, '%s','delimiter', '\n');
file_string = C{1,1};



ix_find = regexpi(file_string, find_string);
ix_find = ix_find(~cellfun('isempty',ix_find))


nr_find = length(ix_find);

fprintf('Number of times appearance of string: %d.\n', nr_find)
disp('-----------------------------------------------------------------')


% For keyword "support"
% file_string(210)
% file_string(385)



