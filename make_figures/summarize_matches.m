close all
clear all
clc

tic



%% Define parameters
% ========================================================================
year_start = 1976;
year_end = 1997;
nr_years = length(year_start:year_end);
week_start = 1;


%% Make some initializations
% ========================================================================
% Pre-define some vectors to initialize them for the loops
allyr_patstats.total_matches_week = []; 

% Where new year data starts
ix_new_year = ones(length(year_start:year_end) + 1, 1); 

allyr_patstats.nr_patents_per_week = [];

aux_ix_save = 1; % where to save data in vector



%% Loop through data for all years
% ========================================================================

for ix_year=year_start:year_end

    week_end = set_weekend(ix_year); 


    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
    

    patsumstats.nr_patents_yr(aux_ix_save) = size(...
        patsearch_results.patentnr, 1);
  
    
    % Add all weekly total matches together
    % -------------------------------------------------------------
    nr_keyword_per_patent = patsearch_results.matches;
    
    
    patent_week = cell2mat(patsearch_results.week);
    
    patsumstats.total_matches_yr(aux_ix_save,:) = sum( ...
        nr_keyword_per_patent,1);
    patsumstats.mean_patents_yr(aux_ix_save,:) = mean( ...
        nr_keyword_per_patent,1);
    
    
    if size(patent_week, 1) ~= size(nr_keyword_per_patent, 1)
        warning('Number of patents not equal to number of week identifiers')
    end

    
    nr_worddict = length(patsearch_results.dictionary);

    total_matches_week = zeros(week_end, nr_worddict);
    nr_patents_per_week = zeros(week_end, 1);
    nr_pat1m = zeros(week_end, 1);

    
    length_pattext = patsearch_results.length_pattext;
    
    for ix_week=week_start:week_end

        keywords_week = nr_keyword_per_patent(patent_week==ix_week,:);
        total_matches_week(ix_week, :) = sum(keywords_week, 1);

        % Count number of patents per week
        nr_patents_per_week(ix_week) = length(keywords_week);
    end
    

    allyr_patstats.total_matches_week = [allyr_patstats.total_matches_week;
                                        total_matches_week];

    allyr_patstats.nr_patents_per_week = [allyr_patstats.nr_patents_per_week;
                                         nr_patents_per_week];

    
    % Subtract one from saving index because of the zero in the beginning
    % that we need for the initialization.
    ix_new_year(aux_ix_save + 1) = size(...
        allyr_patstats.total_matches_week, 1);
    aux_ix_save = aux_ix_save + 1;
    
    
    fprintf('Year %d completed.\n', ix_year)
end


% Re-formate the index showing where new year data starts
ix_new_year = ix_new_year(1:end-1);

if length(ix_new_year) ~= length(year_start:year_end)
    warning('Should be the same.')
end

allyr_patstats.ix_new_year = ix_new_year;
allyr_patstats.dictionary = patsearch_results.dictionary;


%% Save
% ========================================================================
save_name = horzcat('patsumstats_', num2str(year_start), '-', ...
    num2str(year_end), '.mat');
matfile_path_save = fullfile('output', save_name);
save(matfile_path_save, 'patsumstats')
fprintf('Saved: %s.\n', save_name)

save_name = horzcat('allyr_patstats_', num2str(year_start), '-', ...
    num2str(year_end), '.mat');
matfile_path_save = fullfile('output', save_name);
save(matfile_path_save, 'allyr_patstats')
fprintf('Saved: %s.\n', save_name)


toc
