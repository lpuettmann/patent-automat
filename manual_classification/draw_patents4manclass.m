close all
clear all
clc



addpath('../cleaned_matches');
addpath('../functions');

tic


%% Define parameters
% ========================================================================
year_start = 1995;
year_end = 1996;
nr_years = length(year_start:year_end);
week_start = 1;
nr_draw_pat_yr = 2; % how many patents to draw from every year



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
        
    % Stack yearly draws underneath
    rand_pat = [rand_pat; 
                rand_pat_year, repmat(ix_year, size(rand_pat_year))];
    
    fprintf('Year %d completed.\n', ix_year)
end



%% Export
% ========================================================================
% Rearrange elements randomly
rand_pat = rand_pat(randperm(length(rand_pat)),:);

% Create an Excel document which gives the patent number of the drawn
% patent
col_header = {'Patent number', 'Year', 'Classification', 'Technical problem', 'Comment'};
data4exc = [rand_pat, nan(length(rand_pat), length(col_header) - 2)];
output_matrix = [col_header; num2cell(data4exc)];
save_name = 'manual_classif.xlsx';
xlswrite(save_name, output_matrix);
fprintf('Saved: %s.\n', save_name)


toc



