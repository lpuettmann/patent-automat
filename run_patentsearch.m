clear all
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
% parfor ix_year = years
%     tic
%  
%     % Search for keywords in the patent grant texts
%     try
%         pat_ix = make_patent_index(ix_year);
%     catch
%         warning('Problem in year: %d. Go to next year.', ix_year)
%         continue
%     end
%     
%     % Print how long the year took
%     print_finish_summary(toc, ix_year)
%     
%     % Save to .mat file
%     save_patix2mat(pat_ix, ix_year)
% end



%% Search for keywords
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
%     
%     % Save to .mat file
%     save_patent_keyword_appear2mat(patent_keyword_appear, ix_year)
% end


%% Deal with tech class numbers

% Rename USPC
% ----------------------------------------------------------------------
% for ix_year=1976:2015
% 
%     % Load matches
%     load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
%     load(load_file_name)
%     
%     oldField = 'classnr';
%     newField = 'classnr_uspc';
%     [patent_keyword_appear.(newField)] = patent_keyword_appear.(oldField);
%     patent_keyword_appear = rmfield(patent_keyword_appear, oldField);
%        
%     save_name = horzcat('patent_keyword_appear_', num2str(ix_year), '.mat');
%     matfile_path_save = fullfile('matches', save_name);
%     save(matfile_path_save, 'patent_keyword_appear');    
%     fprintf('Saved: %s.\n', save_name)
% end



% Insert ICP
% ----------------------------------------------------------------------
for ix_year=1976:2001

    load_file_name = horzcat('patent_index_', num2str(ix_year));
    load(load_file_name)
    
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)

    break
end



break


% %% Clean matches
% clean_matches(year_start, year_end)


%% Check matches for plausibility
% check_cleanedmatches_plausability(year_start, year_end)


%% Transfer matches to CSV (for use in Stata)
% transfer_cleaned_matches2csv(year_start, year_end)


%% Summarize matches for visualizations
% summarize_matches4viz(year_start, year_end)


%% Make some visualizations 
dim_subplot = [7, 5];

% plot_matches_overtime(year_start, year_end, dim_subplot)
% plot_matches_over_nrpatents_weekly(year_start, year_end, dim_subplot)
% plot_mean_len_pattxt(year_start, year_end)
% plot_pat1m_over_nrlines(year_start, year_end)
% plot_nr_pat1m(year_start, year_end)
% plot_error_nr_patents % compares number of yearly patents 1976-2014

% Plot the classified automation patents
% pick_k = 1; % 1: "automat"
% plot_pat1m_over_nrpatents_weekly(year_start, year_end, pick_k)
% plot_pat1m_overtime(year_start, year_end, pick_k)

% plot_alg1_overtime(year_start, year_end)
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\alg1_weekly_1976-2015.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
%
% plot_alg1_over_nrpatents_weekly(year_start, year_end)
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\alg1_over_nrpatents_weekly_1976-2015.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
% 
make_table_yearsstats(year_start, year_end)
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\table_yearsstats.tex', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\tables')


%% Prepare conversion table
fyr_start = 1976;
fyr_end = 2014;

% fname = 'Naics_co13.csv';
% lnumber = 203074; % unfortunately hard-code line number
% tic
% disp('Start preparing conversion table:')
% conversion_table = prepare_conversion_table(fname, lnumber);
% fprintf('Finished preparing conversion table, time = %d minutes.\n', ...
%     round(toc/60))
% save('output/conversion_table', 'conversion_table')


%% Link patents to industries
% load('conversion_table')
% pat2ind = conversion_patent2industry(fyr_start, fyr_end, conversion_table);
% save('output/pat2ind', 'pat2ind')


%% Industry-level analysis
% load('pat2ind')
% 
% max_nr_patlink2ind = max( pat2ind.nr_appear_allyear);
% 
% for i=0:max_nr_patlink2ind
%     ix_iter = i + 1;
%     nr_patlink2ind(ix_iter) = sum(pat2ind.nr_appear_allyear == i) ./ ...
%         length(pat2ind.nr_appear_allyear);
% end





% subplot_industries_alg1(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     pat2ind.ind_corresp)
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\subplot_industries_alg1.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
% 
% subplot_industries_mean_alg1(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     pat2ind.ind_corresp)
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\subplot_industries_mean_alg1.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')


% idata = extract_idata(fyr_start, fyr_end, pat2ind.ind_corresp(:, 1));
% check_idata(idata)


% laborm_series = idata.employment;
% make_bivariate_employment_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\bivariate_autompat_vs_employment.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
% 
% 
% laborm_series = idata.labor_productivity;
% make_bivariate_labor_productivity_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\bivariate_autompat_vs_labor_productivity.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
% 
% 
% laborm_series = idata.capital;
% make_bivariate_capital_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\bivariate_autompat_vs_capital.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
% 
% 
% laborm_series = idata.labor_cost;
% make_bivariate_labor_cost_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\bivariate_autompat_vs_labor_cost.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
% 
% 
% laborm_series = idata.capital_cost;
% make_bivariate_capital_cost_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\bivariate_autompat_vs_capital_cost.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
% 
% 
% laborm_series = idata.production;
% make_bivariate_production_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\bivariate_autompat_vs_production.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
% 
% 
% laborm_series = idata.output;
% make_bivariate_output_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\bivariate_autompat_vs_output.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
% 
% 
% laborm_series = idata.output_deflator;
% make_bivariate_output_deflator_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\bivariate_autompat_vs_output_deflator.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
% 
% 
% laborm_series = idata.output_deflator;
% make_bivariate_output_deflator_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\bivariate_autompat_vs_output_deflator.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')
% 
% 
% laborm_series = idata.capital_productivity;
% make_bivariate_capital_productivity_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\bivariate_autompat_vs_capital_productivity.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')




% make_table_meancorr_laborm_patentm(manufacturing_ind_data)
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\table_meancorr_laborm_patentm.tex', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\tables')


% ix_patentmetric = 3;
% ix_labormvar = 5;
% subplot_patentm_vs_laborm(1976, 2014, manufacturing_ind_data, pat2ind, ...
%     ix_patentmetric, ix_labormvar)


%% Draw patents to classify manually
% draw_patents4manclass


%% Compare classification with manually coded patents

% Load and prepare the manually classified patents
manclassData = prepare_manclass('manclass_consolidated_v10.xlsx');
% manclassData = prepare_manclass('manclass_unseen_eval_alg1.xlsx');

% Use patents classified by Bessen and Hunt (2007) 
    % patent: patent number
    % sw: manual classification
    % mowpat: classification by Mowery
    % swpat2: algorithm used for classification
% bh_manclass = readtable('bessen-hunt-classifications.csv')
% 
% 
% overlap_manclass = intersect(manclassData.patentnr, bh_manclass.patent);
% 
% if not( isempty(overlap_manclass) )
%     fprintf('Patent classified by us and BH: %d.\n', overlap_manclass)
% end



% Get keywords and technology numbers for manually classified patents
% automclassData = compile_automclass4codedpats(manclassData.patentnr, ...
%     manclassData.indic_year, year_start, year_end)
% automclassData.indic_exclclassnr = check_classnr(automclassData.classnr);
% save('output/automclassData.mat', 'automclassData'); % save to .mat



%%
% Classify patents based on computerized methods
load('automclassData')


computerClass = classify_autom_algorith(automclassData);


%% Compare manual vs. computer classification of patents


% Report contingency table for Algorithm1 only
ix_alg = find( strcmp(computerClass.algorithm_name, 'Algorithm1') );
classifstat = calculate_manclass_stats(manclassData.manAutomat, ...
    computerClass.compAutomat(:, ix_alg));
make_contingency_table(classifstat)

% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\table_contingency.tex', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\tables')

make_table_evalstats(classifstat)

copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\table_evalstats.tex', ...
    'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\tables')



compClass_Yes = computerClass.compAutomat(:, ix_alg);
classifstat_yrly = calculate_classerror_overtime(manclassData, ...
    compClass_Yes, year_start, year_end);


plot_classifstat_yrly(classifstat_yrly, year_start, year_end)
% copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\classifstat_yrly.pdf', ...
%     'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\figures')


% Compare some algorithms
choose_compalg_list = {'Algorithm1', 'automat', 'Bessen-Hunt', ...
    'Always "No"', 'Always "Yes"'};
% choose_compalg_list = computerClass.algorithm_name; % pick all algorithms
classalg_comparison = comp_evals_algs(choose_compalg_list, ...
    computerClass, manclassData);

plot_bar_fmeasure(classalg_comparison.fmeasure, classalg_comparison.algorithm_name)

max_line = 9; % choose number of algorithms to put on line for table in paper
make_table_compare_classalg(classalg_comparison, max_line)

copyfile('D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\output\table_compare_classalg.tex', ...
    'D:\Dropbox\MannPuettmann\2_writing\paper-patent-automat\tables')


