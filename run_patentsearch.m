clear all
close all
clc

% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path


%% Choose years
year_start = 1976;
year_end = 2001;
years = 2008;


%% Make patent index
% for ix_year = years
%     tic
%  
%     % Search for keywords in the patent grant texts
%     pat_ix = make_patent_index(ix_year);
%     
%     % Print how long the year took
%     print_finish_summary(toc, ix_year)
%     
%     % Save to .mat file
%     save_patix2mat(pat_ix, ix_year)
% end
% 
% 
% Search for keywords
% for ix_year = years
%     tic
%     
%     % Define dictionary to search for
%     find_dictionary = define_dictionary();
%     
%     % Search for keywords in the patent grant texts
%     patent_keyword_appear = analyze_patent_text(ix_year, find_dictionary);
%     
%     % Print how long the year took
%     print_finish_summary(toc, ix_year)
    
    % Save to .mat file
%     save_patent_keyword_appear2mat(patent_keyword_appear, ix_year)
% end


%% Clean matches
% clean_matches(year_start, year_end)


%% Check matches for plausibility
check_cleanedmatches_plausability(year_start, year_end)


%% Transfer matches to CSV (for use in Stata)
%transfer_cleaned_matches2csv(year_start, year_end)


%% Summarize matches for visualizations
% summarize_matches4viz(year_start, year_end)


%% Make some visualizations 
% dim_subplot = [6, 5];
% 
% plot_matches_overtime(year_start, year_end, dim_subplot)
% plot_matches_over_nrpatents_weekly(year_start, year_end, dim_subplot)
% plot_mean_len_pattxt(year_start, year_end)
% plot_pat1m_over_nrlines(year_start, year_end)
% plot_nr_pat1m(year_start, year_end)
% plot_error_nr_patents % compares number of yearly patents 1976-2014
% 
% % Plot the classified automation patents
% pick_k = 1; % 1: "automat"
% plot_pat1m_over_nrpatents_weekly(year_start, year_end, pick_k)
% plot_pat1m_overtime(year_start, year_end, pick_k)


%% Link patents to industries
% pat2ind = conversion_patent2industry();
% save('output/pat2ind', 'pat2ind')


%% Industry-level analysis
% load('pat2ind')

% manufacturing_ind_data = analyze_industries(1976, ...
%     2014, pat2ind);

% make_table_meancorr_laborm_patentm(manufacturing_ind_data)

% subplot_patentm_vs_laborm(1976, 2014, ... 
%     manufacturing_ind_data, pat2ind)


%% Compare classification with manually coded patents





