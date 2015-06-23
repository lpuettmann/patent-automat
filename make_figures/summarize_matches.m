close all
clear all
clc

tic



%% Define parameters
% ========================================================================
year_start = 1976;
year_end = 1990;
nr_years = length(year_start:year_end);
week_start = 1;


%% Make some initializations
% ========================================================================
% Pre-define some vectors to initialize them for the loops
allyr_patstats.total_matches_week = []; 
allyr_patstats.total_mean_matches_per_line = []; 
allyr_patstats.mean_len_pattxt = []; 
allyr_patstats.total_mean_pat1m_meanm_per_l = [];     
allyr_patstats.total_nr_pat1m = [];

% Where new year data starts
ix_new_year = ones(length(year_start:year_end) + 1, 1); 

nr_patents_yr = zeros(nr_years, 1);
mean_patents_yr = zeros(nr_years, 1);
median_patents_yr = zeros(nr_years, 1);
max_patents_yr = zeros(nr_years, 1);
nr_distinct_patents_hits = zeros(nr_years, 1);
mean_nonzero_count = zeros(nr_years, 1);
outlier_cutoff = zeros(nr_years, 1);

allyr_patstats.nr_patents_per_week = repmat({''}, length(year_start: ...
    year_end), 1);

aux_ix_save = 1; % where to save data in vector



%% Loop through data for all years
% ========================================================================

for ix_year=year_start:year_end

    week_end = set_weekend(ix_year); 


    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
    

    patent_match_summary.nr_patents_yr(aux_ix_save) = size(...
        patsearch_results.patentnr, 1);
   
    
    % Add all weekly total matches together
    % -------------------------------------------------------------
    nr_keyword_per_patent = patsearch_results.matches;
    
    
    patent_week = cell2mat(patsearch_results.week);
    
    patent_match_summary.total_matches_yr(aux_ix_save,:) = sum( ...
        nr_keyword_per_patent,1);
    patent_match_summary.mean_patents_yr(aux_ix_save,:) = mean( ...
        nr_keyword_per_patent,1);
    
    
    if size(patent_week, 1) ~= size(nr_keyword_per_patent, 1)
        warning('Number of patents not equal to number of week identifiers')
    end


    total_matches_week = zeros(week_end, 1);
    nr_patents_per_week = zeros(week_end, 1);
    mean_matches_per_line = zeros(week_end, 1);
    mean_len_pattxt = zeros(week_end, 1);
    mean_pat1m_meanm_per_l = zeros(week_end, 1);
    nr_pat1m = zeros(week_end, 1);

    
    length_pattext = patsearch_results.length_pattext;
    
    for ix_week=week_start:week_end
        keywords_week = nr_keyword_per_patent(patent_week==ix_week);
        total_matches_week(ix_week) = sum(keywords_week);
        
        % Calculate average number of matches per line
        length_pattext_week = length_pattext(patent_week==ix_week);
        mean_len_pattxt(ix_week) = mean(length_pattext_week);
        matches_per_line = keywords_week ./ length_pattext_week;
        mean_matches_per_line(ix_week) = mean(matches_per_line);
        
        % Count number of patents per week
        nr_patents_per_week(ix_week) = length(keywords_week);
        
        % Only look at patents with at least one match
        pat1m_matches = keywords_week(keywords_week>1);
        pat1m_len_pattxt = length_pattext_week(keywords_week>1);
        pat1m_meanm_per_l = pat1m_matches ./ pat1m_len_pattxt;
        mean_pat1m_meanm_per_l(ix_week) = mean(pat1m_meanm_per_l);
        nr_pat1m(ix_week) = length(pat1m_matches);
    end
    
    
    if size(total_matches_week, 1) < size(total_matches_week, 2)
        warning('Check if column vector')
    end
    
    allyr_patstats.total_matches_week = [allyr_patstats.total_matches_week;
                                        total_matches_week];
                
    allyr_patstats.mean_len_pattxt = [allyr_patstats.mean_len_pattxt;
                                      mean_len_pattxt];
                           
    allyr_patstats.total_mean_matches_per_line = [...
        allyr_patstats.total_mean_matches_per_line;
                                          mean_matches_per_line];
                                      
    allyr_patstats.total_mean_pat1m_meanm_per_l = [...
        allyr_patstats.total_mean_pat1m_meanm_per_l;
                                            mean_pat1m_meanm_per_l];                        
                                      
    allyr_patstats.total_nr_pat1m = [allyr_patstats.total_nr_pat1m;
                              nr_pat1m];  
    
    allyr_patstats.nr_patents_per_week{ix_year - year_start + 1} = ...
        nr_patents_per_week; 

    
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



%% Save
% ========================================================================
save_name = horzcat('patent_match_summary_', num2str(year_start), '-', ...
    num2str(year_end), '.mat');
save(save_name, 'patent_match_summary')

save_name = horzcat('allyr_patstats_', num2str(year_start), '-', ...
    num2str(year_end), '.mat');
save(save_name, 'allyr_patstats')



%% End
% ======================================================================
toc
disp('*** end ***')
