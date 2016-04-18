function draw_patents4manclass(vnum, year_start, year_end)

tic

%% Define parameters
% ========================================================================
nr_years = length(year_start:year_end);
week_start = 1;

% Determine how many patents to draw from every year
nr_draw_pat_yr = repmat(5, nr_years, 1);

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
    
    % Stack yearly draws underneath
    rand_pat = [rand_pat; 
                patent_number, repmat(ix_year, size(rand_pat_year))];
    
    fprintf('Year %d completed.\n', ix_year)
end



%% Export to excel files
% ========================================================================
% Rearrange elements randomly
rand_pat = rand_pat(randperm(length(rand_pat)), :);

% Assign a version number
vnum = 14;

% Create an Excel document which gives the patent number of the drawn
% patent
col_header = {'Patent number', 'Year', ...
    'Classification', 'Cognitive', 'Manual', 'Highly uncertain', ...
    'Comment', 'Coder ID', 'Coding date'};
data4exc = [rand_pat, nan(size(rand_pat, 1), 7)];
output_matrix = [col_header; num2cell(data4exc)];
save_name = horzcat('output/manclass_v', num2str(vnum), '.xlsx');
xlswrite(save_name, output_matrix);
fprintf('Saved: %s.\n', save_name)

toc
