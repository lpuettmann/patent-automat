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
%     load_file_name = horzcat('patsearch_results_', num2str(ix_year));
      
    load_file_name = horzcat('patent_index_', num2str(ix_year));
    load(load_file_name)
    
    % Get list of patent numbers in year
    patentnr = vertcat( pat_ix{:, 1} );
    
    % Delete "named" patents (starting with letter)
    save_row_delete = delete_named_pat(patentnr);
    patentnr(save_row_delete) = [];
    
    % Delete first (and last [for some]) letter of patent numbers
    patentnr = strip_patentnr(patentnr, ix_year);
        
    rand_pat_year = randsample(length(patentnr), nr_draw);
        
    draw_patentnr = patentnr( rand_pat_year );
    draw_patentnr = cellfun(@str2num, draw_patentnr); 
    
    % Stack yearly draws underneath
    rand_pat = [rand_pat; 
                draw_patentnr, repmat(ix_year, size(rand_pat_year))];
    
    fprintf('Year %d completed.\n', ix_year)
end



%% Export to excel files
% ========================================================================
% Rearrange elements randomly
rand_pat = rand_pat(randperm( length(rand_pat) ), :);

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
