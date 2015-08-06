% clear all
close all
clc

% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path


%% Choose years
year_start = 1976;
year_end = 2015;
years = year_start:year_end;


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


%% Search for keywords
% parfor ix_year = years
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
%     
% %     Save to .mat file
%     save_patent_keyword_appear2mat(patent_keyword_appear, ix_year)
% end
% 
% 
% %% Clean matches
% clean_matches(year_start, year_end)


%% Check matches for plausibility
% check_cleanedmatches_plausability(year_start, year_end)


%% Transfer matches to CSV (for use in Stata)
% transfer_cleaned_matches2csv(year_start, year_end)


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


%% Draw patents to classify manually
% draw_patents4manclass


%% Compare classification with manually coded patents

% Load and prepare the manually classified patents
% manclassData = prepare_manclass('manclass_consolidated_v7.xlsx');

% Get keywords and technology numbers for those patents that were manually
% classified
% automclassData = compile_automclass4codedpats(manclassData, year_start, ...
%     year_end);

% Classify patents based on computerized methods
clear computerClass classalg_comparison
computerClass = classify_autom_algorith(automclassData);

% Make a contingency table comparing the manual vs. the computer
% classification of patents

for i=1:size(computerClass.compAutomat, 2)
    classifstat = calculate_manclass_stats(manclassData.manAutomat, ...
        computerClass.compAutomat(:, i));
    
    classalg_comparison.accuracy(i) = classifstat.accuracy;
    classalg_comparison.precision(i) = classifstat.precision;
    classalg_comparison.recall(i) = classifstat.recall;
    classalg_comparison.fmeasure(i) = classifstat.fmeasure;
    classalg_comparison.auc(i) = classifstat.auc;
    classalg_comparison.matthewscorrcoeff(i) = classifstat.matthewscorrcoeff;
    classalg_comparison.nr_Yes(i) = classifstat.false_positive + ...
        classifstat.true_positive;
end

classalg_comparison.algorithm_name = computerClass.algorithm_name;

% plot_bar_fmeasure(classalg_comparison.fmeasure, computerClass.algorithm_name)


classifstat = calculate_manclass_stats(manclassData.manAutomat, ...
    computerClass.compAutomat(:, 1));

make_contingency_table(classifstat)

max_line = 10;
make_table_compare_classalg(classalg_comparison, max_line)


%% Copy tables
copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\table_compare_classalg.tex', ...
    'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\tables')










