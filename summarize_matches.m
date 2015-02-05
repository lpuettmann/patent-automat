close all
clear all
clc

tic

addpath('matches');
addpath('functions');


%% Define parameters
% ========================================================================
find_str = 'automat'; 

year_start = 1976;
year_end = 2001;
week_start = 1;


%% Loop through data for all years
% ========================================================================

% Pre-define some vectors to initialize them for the loops
allyear_total_matches_week = 0; % delete this afterwards
allyear_total_automix = 0; % delete this afterwards

ix_new_year = ones(length(year_start:year_end) + 1, 1); % where new year data starts

nr_patents_yr = zeros(length(year_start:year_end), 1);
mean_patents_yr = zeros(length(year_start:year_end), 1);
median_patents_yr = zeros(length(year_start:year_end), 1);
max_patents_yr = zeros(length(year_start:year_end), 1);
nr_distinct_patents_hits = zeros(length(year_start:year_end), 1);
mean_nonzero_count = zeros(length(year_start:year_end), 1);
outlier_cutoff = zeros(length(year_start:year_end), 1);

aux_ix_save = 1; % where to save data in vector


for ix_year=year_start:year_end
    year = ix_year;

    if year == 1980 | year == 1985 | year == 1991 | year == 1996
        week_end = 53;
    else
        week_end = 52;
    end


    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patent_keyword_appear_', num2str(year));
    load(load_file_name)

    patent_match_summary.nr_patents_yr(aux_ix_save) = size(patent_keyword_appear, 1);
   
    
    % Add all weekly total matches together
    % -------------------------------------------------------------
    nr_keyword_per_patent = cell2mat(patent_keyword_appear(:, 2));
    
    % Check for outlier above 99th percentile and report separate mean
    patent_match_summary.perc_99(aux_ix_save) = prctile(nr_keyword_per_patent, 99);
    trunc_nr_keyword = nr_keyword_per_patent;
    trunc_nr_keyword = trunc_nr_keyword(trunc_nr_keyword < ...
        patent_match_summary.perc_99(aux_ix_save));
    patent_match_summary.trunc_mean(aux_ix_save) = mean(trunc_nr_keyword);
   
    
    patent_week = cell2mat(patent_keyword_appear(:, 5));
    
    
    patent_match_summary.mean_patents_yr(aux_ix_save) = mean(nr_keyword_per_patent);
    patent_match_summary.median_patents_yr(aux_ix_save) = median(nr_keyword_per_patent);
    patent_match_summary.max_patents_yr(aux_ix_save) = max(nr_keyword_per_patent);
    
    nonzero_count = nr_keyword_per_patent;
    nonzero_count(nr_keyword_per_patent==0) = [];
    patent_match_summary.mean_nonzero_count(aux_ix_save) = mean(nonzero_count);
    patent_match_summary.nr_distinct_patents_hits(aux_ix_save) = length(nonzero_count);

    
    if size(patent_week, 1) ~= size(nr_keyword_per_patent, 1)
        warning('Number of patents not equal to number of week identifiers')
    end


    total_matches_week = zeros(week_end, 1);
    total_automix = zeros(week_end, 1);
    
    % Make an index of a patent
    automix = log(1 + nr_keyword_per_patent);
    
    
    for ix_week=week_start:week_end
        keywords_week = nr_keyword_per_patent(patent_week==ix_week);
        total_matches_week(ix_week) = sum(keywords_week);
        
        automix_week = automix(patent_week==ix_week);
        total_automix(ix_week) = sum(automix_week);
    end
    
    if size(total_matches_week, 1) < size(total_matches_week, 2)
        warning('Check if column vector')
    end

    allyear_total_matches_week = [allyear_total_matches_week;
                                  total_matches_week];
    
    allyear_total_automix = [allyear_total_automix;
                            total_automix];
    
    % Subtract one from saving index because of the sero in the beginning
    % that we need for the initialization.
    ix_new_year(aux_ix_save + 1) = size(allyear_total_matches_week, 1);
    aux_ix_save = aux_ix_save + 1;
    
    
    fprintf('Year %d completed.\n', year)
end

% Cut of the first zero used for pre-defining
allyear_total_matches_week = allyear_total_matches_week(2:end);
allyear_total_automix = allyear_total_automix(2:end);

% Re-formate the index showing where new year data starts
ix_new_year = ix_new_year(1:end-1);

if length(ix_new_year) ~= length(year_start:year_end)
    warning('Should be the same.')
end




%% Save
% ========================================================================
save_name = horzcat('patent_match_summary_', num2str(year_start), '-',  num2str(year_end), '.mat');
save(save_name, 'patent_match_summary')

save_name = horzcat('total_matches_week_', num2str(year_start), '-',  num2str(year_end), '.mat');
save(save_name, 'allyear_total_matches_week', 'ix_new_year', 'allyear_total_automix')


%% End
% ======================================================================
toc
disp('*** end ***')
