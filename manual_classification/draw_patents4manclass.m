close all
clear all
clc


tic


%% Define parameters
% ========================================================================
year_start = 1976;
year_end = 2015;
nr_years = length(year_start:year_end);
week_start = 1;

% Determine how many patents to draw from every year
nr_draw_pat_yr = [1; 0; 2; 1; 0; 4; 1; 1; 5; 2; 5; 5; 4; 3; 0; 7; 7; ...
    6; 5; 2; 3; 5; 7; 5; 6; 2; 2; 4; 1; 4; 6; 3; 0; 0; 3; 2; 5; 4; 3; 0];

assert( length(nr_draw_pat_yr) == length( year_start:year_end ) )


%% Loop through data for all years
% ========================================================================
rand_pat = [];

for ix_year=year_start:year_end
    ix_iter = ix_year - year_start + 1;

    % Draw a random sample without replacement from the patents in year
    nr_draw = nr_draw_pat_yr(ix_iter);
    
    if nr_draw == 0
        % If we don't want to draw patents for this year, go to next
        % iteration of loop.
        fprintf('Year %d completed (no patents drawn).\n', ix_year)
        continue
    end
    
    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
    
    nr_patents_yr = size(patsearch_results.patentnr, 1);
    
    rand_pat_year = randsample(nr_patents_yr, nr_draw);
        
    patent_number = patsearch_results.patentnr(rand_pat_year);
    patent_number = cellfun(@str2num, patent_number); 
          
    tech_nr = patsearch_results.classnr(rand_pat_year);
    tech_nr = cellfun(@str2num, tech_nr, 'UniformOutput', false);
    tech_nr = cell2mat(tech_nr);
    
    % Stack yearly draws underneath
    rand_pat = [rand_pat; 
                patent_number, repmat(ix_year, size(rand_pat_year)), ...
                tech_nr];
    
    fprintf('Year %d completed.\n', ix_year)
end



%% Export to excel files
% ========================================================================
% Rearrange elements randomly
rand_pat = rand_pat(randperm(length(rand_pat)), :);

% Assign a version number
vnum = 10;

% Create an Excel document which gives the patent number of the drawn
% patent
col_header = {'Patent number', 'Year', ...
    'Classification', 'Cognitive', 'Manual', 'Highly uncertain', ...
    'Comment', 'Tech class nr', ...
    'Coder ID', 'Coding date'};
data4exc = [rand_pat(:, 1:2), nan(length(rand_pat), 5), rand_pat(:, 3), ...
    nan(length(rand_pat), 2)];
output_matrix = [col_header; num2cell(data4exc)];
save_name = horzcat('output/manclass_FULL_v', num2str(vnum), '.xlsx');
xlswrite(save_name, output_matrix);
fprintf('Saved: %s.\n', save_name)

% Create an Excel document which gives the patent number of the drawn
% patent
col_header = {'Patent number', 'Year', ...
    'Classification', 'Cognitive', 'Manual', 'Highly uncertain', 'Comment'};
data4exc = [rand_pat(:, 1:2), nan(length(rand_pat), 5)];
output_matrix = [col_header; num2cell(data4exc)];
save_name = horzcat('output/manclass_v', num2str(vnum), '.xlsx');
xlswrite(save_name, output_matrix);
fprintf('Saved: %s.\n', save_name)


toc


