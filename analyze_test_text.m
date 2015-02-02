clc
clear all
close all


addpath('functions');
addpath('data');


%% Define keyword to look for
% ========================================================================
% find_string = 'autoMATizatiON';

find_string = define_keywords;



%% Define our own test string to see if finding the keyword works
% ========================================================================
test_string = sprintf(['Lorem ipsum automatization dolor sit amet, '...
    'Nullam quis hendrerit  lacus, nec mechani eleifend arcu.' ...
    'Imperdiet aUtoMATization a accumsan odio.']);

% Search through the test string
ix_find = regexpi (test_string, find_string);
nr_find = length(ix_find);

fprintf('Number of times appearance of string: %d.\n', nr_find)
disp('-----------------------------------------------------------------')
break


%% Load the patent website's description text into string
% ========================================================================
file_string = fileread('4354706.txt');

ix_pos_insert = 110;

file_string(ix_pos_insert:ix_pos_insert-1+length(find_string)) = ...
    find_string;


ix_find = strfind (file_string, find_string);
nr_find = length(ix_find);

fprintf('Number of times appearance of string: %d.\n', nr_find)
disp('-----------------------------------------------------------------')







