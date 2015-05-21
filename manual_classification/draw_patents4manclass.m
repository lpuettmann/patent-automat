close all
clear all
clc



addpath('../cleaned_matches');
addpath('../functions');

tic


%% Define parameters
% ========================================================================
year_start = 1976;
year_end = 2015;
nr_years = length(year_start:year_end);
week_start = 1;
nr_draw_pat_yr = 1; % how many patents to draw from every year



%% Loop through data for all years
% ========================================================================
rand_pat = [];

for ix_year=year_start:year_end

    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
    
    nr_patents_yr = size(patsearch_results, 1);

    % Draw a random sample without replacement from the patents in year
    rand_pat_year = randsample(nr_patents_yr, nr_draw_pat_yr);
        
    patent_number = patsearch_results(rand_pat_year, 1);
    patent_number = cellfun(@str2num, patent_number); 
    
    nr_keyword_find = patsearch_results(rand_pat_year, 2);
    nr_keyword_find = cell2mat(nr_keyword_find);
       
    
    % Stack yearly draws underneath
    rand_pat = [rand_pat; 
                patent_number, repmat(ix_year, size(rand_pat_year)), ...
                nr_keyword_find];
    
    fprintf('Year %d completed.\n', ix_year)
end



%% Export to excel files
% ========================================================================
% Rearrange elements randomly
rand_pat = rand_pat(randperm(length(rand_pat)), :);

% Assign a version number
vnum = 5;

% Create an Excel document which gives the patent number of the drawn
% patent
col_header = {'Patent number', 'Year', ...
    'Classification', 'Cognitive', 'Manual', 'Comment', ...
    'Number matches'};
data4exc = [rand_pat(:, 1:2), nan(length(rand_pat), ...
    length(col_header) - 3), rand_pat(:, 3)];
output_matrix = [col_header; num2cell(data4exc)];
save_name = horzcat('manclass_FULL_v', num2str(vnum), '.xlsx');
xlswrite(save_name, output_matrix);
fprintf('Saved: %s.\n', save_name)

% Create an Excel document which gives the patent number of the drawn
% patent
col_header = {'Patent number', 'Year', ...
    'Classification', 'Cognitive', 'Manual', 'Comment'};
data4exc = [rand_pat(:, 1:2), nan(length(rand_pat), ...
    length(col_header) - 2)];
output_matrix = [col_header; num2cell(data4exc)];
save_name = horzcat('manclass_v', num2str(vnum), '.xlsx');
xlswrite(save_name, output_matrix);
fprintf('Saved: %s.\n', save_name)



toc




