clc
clear all
close all


addpath('functions');
addpath('data');

tic

%% Define keyword to look for
% ========================================================================
% find_str = 'automatization';
find_str = 'automated';
% find_str = 'automat.'; % use a dot as a place holder
% find_str = 'autoMATEd';
% find_str = '4354706'


if length(find_str) < 20 % only display if not too long
    fprintf('Look for the string: >>%s<<\n', find_str)
    disp('---------------------------------------------------------------')
end


%% Load the patent text
% ========================================================================
file_str = fileread('pftaps19821019_wk42.txt');

% Define new search corpus as we might change some things about this
search_corpus = file_str; 


%% Count number of patents in a given week
% ========================================================================

% Count number of appearances of 'PATN'
% ------------------------------------------------------------------------
[ix_PATN_find, nr_PATN_week] = count_nr_string_appearance(file_str, ...
    'PATN');

% Delete entry 257 from our hits. It finds a term "PATNO" which is wrong.
% file_str(ix_PATN_find(257):ix_PATN_find(257)+20) % uncomment to display
ix_PATN_find(257) = [];
nr_PATN_week = nr_PATN_week - 1;



% Pre-define empty cell array to store patent WKU numbers (based on finding) PATN
patent_number_PATN = repmat({''}, nr_PATN_week, 1);

for i=1:nr_PATN_week
    patent_number_PATN{i} = file_str(ix_PATN_find(i) + 11 : ix_PATN_find(i) + 20);
end


% Count number of appearances of 'WKU' (patent numbers)
% ------------------------------------------------------------------------
[ix_find, nr_WKU_week] = count_nr_string_appearance(file_str, ...
    'WKU');

fprintf('Number "PATN": %d, number "WKU": %d. \n', nr_PATN_week, nr_WKU_week)
disp('---------------------------------------------------------------')


% Pre-define empty cell array to store patent WKU numbers
patent_number_WKU = repmat({''}, nr_WKU_week, 1);

for i=1:nr_WKU_week
    patent_number_WKU{i} = file_str(ix_find(i) + 5 : ix_find(i) + 13);
end


%% Run plausibility check
% ========================================================================
% Check which elements in patent_number_PATN and patent_number_WKU differ
for i =1:min(nr_PATN_week, nr_WKU_week)
    pick_patn = patent_number_PATN{i};
    pick_patn = cellstr(pick_patn);
    
    pick_wku = patent_number_WKU{i};
    
    check_equal_patn_wku(i) = strcmp(pick_patn, pick_wku);
end

notequal_patn_wku = find(~check_equal_patn_wku)';

if not(isempty(notequal_patn_wku))
    warning('We are finding different number of PATN and WKU numbers.')
end


% Test if there are any spaces in WKU numbers
test_contains_space = strfind(patent_number_WKU, ' ');
show_ix_contains_space = find(~cellfun(@isempty,test_contains_space));
if not(isempty(show_ix_contains_space))
    warning('There is a space in the patent WKU numbers')
end


% Test if all WKU numbers are 9 digits long
test_is9long = cellfun(@length, patent_number_WKU);
test_vector_nines = repmat(9, nr_WKU_week, 1);
if min(test_is9long == test_vector_nines) < 1
    warning('Not all patent WKU numbers are 9 characters long')
end


%% Search
% ========================================================================
ix_find = regexpi(search_corpus, find_str);
nr_find = length(ix_find);



%% Display some of the found matches
% ========================================================================
% nr_show_matches = 10; 
% show_char = 70;
% explore_ix_found = 1300; % choose starting position
% match_disp_choice = 2; % 1 - choose position, 2 - random pick
% 
% display_matches_text(search_corpus, ix_find, nr_find, ...
%     explore_ix_found, show_char, nr_show_matches, match_disp_choice)



%% Display findings
% ========================================================================
fprintf('Number of times appearance of string: %d.\n', nr_find)
disp('---------------------------------------------------------------')




toc
disp('*** end ***')














