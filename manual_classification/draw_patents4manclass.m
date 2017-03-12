function draw_patents4manclass(vnum, nrDrawYr, year_start, year_end)

%% Define parameters
% ========================================================================
nr_years = length(year_start:year_end);
week_start = 1;

% Determine how many patents to draw from every year
nr_draw_pat_yr = repmat(nrDrawYr, nr_years, 1);

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
    patentnr = patsearch_results.patentnr;
    
    % Change random variable generation depending on current time
    rng('shuffle') 
    draw_patentnr = randsample(patentnr, nr_draw);
    draw_patentnr = cellfun(@str2num, draw_patentnr); 
    
    % Stack yearly draws underneath
    rand_pat = [rand_pat; 
                draw_patentnr, repmat(ix_year, size(draw_patentnr))];
    
    fprintf('Year %d completed.\n', ix_year)
end



%% Export to CSV file
% ========================================================================
% Rearrange elements randomly
rand_pat = rand_pat(randperm( length(rand_pat) ), :);

col_header = {'Patent number', 'Year', ...
    'Classification', 'Cognitive', 'Manual', 'Highly uncertain', ...
    'Comment', 'Coder ID', 'Coding date'};
save_name = horzcat('output/manclass_v', num2str(vnum), '.csv');

fid = fopen(save_name, 'wt');
assert(fid > 0)
     
fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s\n', col_header{1}, ...
    col_header{2}, col_header{3}, col_header{4}, col_header{5}, ...
    col_header{6}, col_header{7}, col_header{8}, col_header{9});

for k = 1:size(rand_pat,1)
    fprintf(fid, '%f,%f,,,,,,,\n', rand_pat(k,1), rand_pat(k,2));
end

fclose(fid);
fprintf('Saved: %s.\n', save_name)
