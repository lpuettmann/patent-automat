clc
clear all
close all


addpath('functions');
addpath('data');

tic

%% Define keyword to look for
% ========================================================================
% find_str = 'automatization';
% find_str = 'automated';
find_str = 'automat.'; % use a dot as a place holder
% find_str = 'autoMATEd';
% find_str = '4354706'


if length(find_str) < 20 % only display if not too long
    fprintf('Look for the string: >>%s<<\n', find_str)
    disp('---------------------------------------------------------------')
end


%% Load the patent text
% ========================================================================
file_str = fileread('pftaps19821019_wk42.txt');

search_corpus = file_str; 


%% Show number of patents in the week
% ========================================================================
[ix_find, nr_patents_week] = count_nr_string_appearance(file_str, ...
    'PATN');

fprintf('Number of patents in week: %d.\n', nr_patents_week)
disp('---------------------------------------------------------------')



%% Search
% ========================================================================
ix_find = regexpi(search_corpus, find_str);
nr_find = length(ix_find);



%% Display some of the found matches
% ========================================================================
nr_show_matches = 10; 
show_char = 70;
explore_ix_found = 1300; % choose starting position
match_disp_choice = 2; % 1 - choose position, 2 - random pick

display_matches_text(search_corpus, ix_find, nr_find, ...
    explore_ix_found, show_char, nr_show_matches, match_disp_choice)




%% Display findings
% ========================================================================
fprintf('Number of times appearance of string: %d.\n', nr_find)
disp('---------------------------------------------------------------')



%% Find number of patent belonging to each hit
% ========================================================================





toc
disp('*** end ***')














