close all
clear all
clc

tic

addpath('../cleaned_matches');
addpath('../functions');


%% Define parameters
% ========================================================================
year_start = 1976;
year_end = 2015;
nr_years = length(year_start:year_end);
week_start = 1;


%% Make some initializations
% ========================================================================
% Pre-define some vectors to initialize them for the loops
allyear_total_matches_week = []; 
allyear_total_automix = []; 
allyear_total_mean_matches_per_line = []; 
allyear_mean_len_pattxt = []; 
allyear_total_mean_pat1m_meanm_per_l = [];     
allyear_total_nr_pat1m = [];

ix_new_year = ones(length(year_start:year_end) + 1, 1); % where new year data starts

nr_patents_yr = zeros(nr_years, 1);
mean_patents_yr = zeros(nr_years, 1);
median_patents_yr = zeros(nr_years, 1);
max_patents_yr = zeros(nr_years, 1);
nr_distinct_patents_hits = zeros(nr_years, 1);
mean_nonzero_count = zeros(nr_years, 1);
outlier_cutoff = zeros(nr_years, 1);

allyear_nr_patents_per_week = repmat({''}, length(year_start:year_end), 1);

aux_ix_save = 1; % where to save data in vector



%% Loop through data for all years
% ========================================================================

for ix_year=year_start:year_end

    week_end = set_weekend(ix_year); 


    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
    

    patent_match_summary.nr_patents_yr(aux_ix_save) = size(patsearch_results, 1);
   
    
    % Add all weekly total matches together
    % -------------------------------------------------------------
    nr_keyword_per_patent = cell2mat(patsearch_results(:, 2));
    
    % Check for outlier above 99th percentile and report separate mean
    patent_match_summary.perc_99(aux_ix_save) = prctile(nr_keyword_per_patent, 99);
    trunc_nr_keyword = nr_keyword_per_patent;
    trunc_nr_keyword = trunc_nr_keyword(trunc_nr_keyword < ...
        patent_match_summary.perc_99(aux_ix_save));
    patent_match_summary.trunc_mean(aux_ix_save) = mean(trunc_nr_keyword);
   
    
    patent_week = cell2mat(patsearch_results(:, 4));
    
    patent_match_summary.total_matches_yr(aux_ix_save) = sum(nr_keyword_per_patent);
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
    nr_patents_per_week = zeros(week_end, 1);
    mean_matches_per_line = zeros(week_end, 1);
    mean_len_pattxt = zeros(week_end, 1);
    mean_pat1m_meanm_per_l = zeros(week_end, 1);
    nr_pat1m = zeros(week_end, 1);
    
    % Make an index of a patent
    automix = log(1 + nr_keyword_per_patent);
    
    length_pattext = cell2mat(patsearch_results(:, 5));
    
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
                
        automix_week = automix(patent_week==ix_week);
        total_automix(ix_week) = sum(automix_week);
    end
    
    
    if size(total_matches_week, 1) < size(total_matches_week, 2)
        warning('Check if column vector')
    end
    
    allyear_total_matches_week = [allyear_total_matches_week;
                                  total_matches_week];
                
    allyear_mean_len_pattxt = [allyear_mean_len_pattxt;
                               mean_len_pattxt];
    
    allyear_total_automix = [allyear_total_automix;
                            total_automix];
                        
    allyear_total_mean_matches_per_line = [allyear_total_mean_matches_per_line;
                                          mean_matches_per_line];
                                      
    allyear_total_mean_pat1m_meanm_per_l = [allyear_total_mean_pat1m_meanm_per_l;
                                            mean_pat1m_meanm_per_l];                        
                                      
    allyear_total_nr_pat1m = [allyear_total_nr_pat1m;
                              nr_pat1m];  
    
    allyear_nr_patents_per_week{ix_year - year_start + 1} = nr_patents_per_week; 
                        
    patent_match_summary.total_automix_yr(aux_ix_save) = sum(allyear_total_automix);
    
    % Subtract one from saving index because of the zero in the beginning
    % that we need for the initialization.
    ix_new_year(aux_ix_save + 1) = size(allyear_total_matches_week, 1);
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
save_name = horzcat('patent_match_summary_', num2str(year_start), '-',  ...
    num2str(year_end), '.mat');
save(save_name, 'patent_match_summary')

save_name = horzcat('total_matches_week_', num2str(year_start), '-', ...
    num2str(year_end), '.mat');
save(save_name, 'allyear_total_matches_week', ...
    'allyear_nr_patents_per_week', 'ix_new_year', ...
    'allyear_total_automix', 'allyear_total_mean_matches_per_line', ...
    'allyear_mean_len_pattxt', 'allyear_total_mean_pat1m_meanm_per_l', ...
    'allyear_total_nr_pat1m')



%% End
% ======================================================================
toc
disp('*** end ***')
