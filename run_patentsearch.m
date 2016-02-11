clear all
close all


% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()


%% Choose years 
year_start = 1976;
year_end = 2015;



%% Make patent index
% for ix_year = years
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


% %% Clean matches
% clean_matches(year_start, year_end)


%% Check matches for plausibility
% check_cleanedmatches_plausability(year_start, year_end)


%% Transfer matches to CSV (for use in Stata)
% transfer_cleaned_matches2csv(year_start, year_end)


%% Summarize matches for visualizations
% summarize_matches4viz(year_start, year_end)


%% Make some visualizations 
% dim_subplot = [7, 5];

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

% plot_alg1_over_nrpatents_weekly(year_start, year_end)

% make_table_yearsstats(year_start, year_end)



%% Link to sector of use using Silverman concordance
% ipcsicfinalv5 = readtable('IPCSICFINALv5.txt', 'Delimiter', ' ', ...
%     'ReadVariableNames', false);
% 
% % Variables in Silverman concordance table:
% %   - ipc: IPC class and subclass      
% %   - sic: US SIC
% %   - mfgfrq: frequency of patents in IPC assigned to SIC of manufacture
% %   - usefrq: frequency of patents in IPC assigned to SIC of use
% ipcsicfinalv5.Properties.VariableNames = {'ipc', 'sic', 'mfgfrq', 'usefrq'};
% 
% construct_sic_automix(years, ipcsicfinalv5)


%% Compile SIC automatix
% sic_automix_allyears = compile_sic_automix_table(year_start, year_end);
% 
% savename = 'output/sic_automix_allyears.mat';
% save(savename, 'sic_automix_allyears')
% fprintf('Saved: %s.\n', savename)


%% Analyse SIC automatix table
% ========================================================================
% load('output/sic_automix_allyears.mat')

% sic_overcategories = define_sic_overcategories();

% Get some summary series for over-categories of industries
% [aggr_automix, aggr_automix_share] = ...
%     get_sic_ocat_automix_data(year_start, year_end, sic_automix_allyears, ...
%     sic_overcategories);


% Sort the series for plotting
% [~, plot_ix] = sort( aggr_automix_share(end, :) );
% plot_ix = 1:10;
% 
% plot_overcat_sic_automatix_subplot(aggr_automix, ...
%     sic_overcategories, year_start, year_end, plot_ix)
% 
% plot_overcat_sic_automatix_share_subplot_gray(aggr_automix_share, ...
%     sic_overcategories, year_start, year_end, plot_ix)
% 
% plot_overcat_sic_automatix_share_subplot(aggr_automix_share, ...
%     sic_overcategories, year_start, year_end, plot_ix)

% plot_overcat_sic_automatix_share_subplot_gray_allSubCat(...
%     year_start, year_end, sic_overcategories, sic_automix_allyears, ...
%     aggr_automix_share, plot_ix)


% for pick_hl=1:size(sic_overcategories, 1) + 1
%     
%     plot_overcat_sic_automatix_share_circles(aggr_automix_share, ...
%         aggr_automix, sic_overcategories, year_start, year_end, pick_hl)
%     
%     plot_overcat_sic_automatix_share(aggr_automix_share, ...
%         sic_overcategories, year_start, year_end, pick_hl)
%     
%     plot_overcat_sic_automatix(aggr_automix, ...
%         sic_overcategories, year_start, year_end, pick_hl)
%     
%     plot_overcat_sic_lautomatix(aggr_automix, ...
%         sic_overcategories, year_start, year_end, pick_hl)    
%     
%     pause(0.05)
% end



%% Import Routine Task Index (RTI) by Autor, Levy and Murnane (2003)
% rti_data = readtable('idata_rti.xlsx');
% rti_data.rti60 = rti_data.rti60 / 100; % from percentage to share
% 
% 
% [sic_list, ~, ix_map] = unique( sic_automix_allyears.sic );
% 
% sic_automix_allyears.rti60 = nan( size( sic_automix_allyears.sic ) );
% 
% for i=1:length(sic_list)
%     sic_pick = sic_list(i);    
%     ix_extr = find( sic_pick == rti_data.sic );    
%     assert( length(ix_extr) <= 1)
%     
%     sic_summary(i, 2) = sic_pick;
%     if isempty( ix_extr ) 
%         sic_summary(i, 2) = NaN;
%     else
%         sic_summary(i, 2) = rti_data.rti60(ix_extr);
%     end
%     
%     ix_insert = find( ix_map == i );
%     
%     for j=1:length(ix_insert)
%         sic_automix_allyears.rti60(ix_insert(j)) = sic_summary(i, 2);
%     end
% end
% 
% 
% %% Insert the relative automation index in the table
% sic_automix_allyears.rel_automix = sic_automix_allyears.automix_use ./ ...
%     sic_automix_allyears.patents_use;
% 
% 
% %% Get summary statistics for all years
% for i=1:length(rti_data.sic)
%     
%     ix_pick = ( sic_automix_allyears.sic == rti_data.sic(i) );
%     
%     ix_year = ( sic_automix_allyears.year <= 1998 ); 
%     
%     ix_pre1998 = ( ix_pick & ix_year );
%     ix_post1998 = ( ix_pick & not(ix_year) );
%     
%     assert(isequal(ix_pre1998 + ix_post1998, ix_pick), 'Should be equal.')
%     
%     rti_data.automix_use_log_sum_pre1998(i) = log( sum( ...
%         sic_automix_allyears.automix_use(ix_pre1998) ) );   
%     
%     rti_data.automix_use_log_sum_post1998(i) = log( sum( ...
%         sic_automix_allyears.automix_use(ix_post1998) ) ); 
%     
%     rti_data.rel_automix_mean_pre1998(i, 1) = mean( ...
%         sic_automix_allyears.rel_automix(ix_pre1998) );   
%     
%     rti_data.rel_automix_mean_post1998(i, 1) = mean( ...
%         sic_automix_allyears.rel_automix(ix_post1998) );   
%     
%     % Save an indicator of whether this SIC is in manufacturing
%     pick_overcat = sic_automix_allyears.overcat( ix_pick );
%     
%     rti_data.ix_manufact(i, 1) = +strcmp( pick_overcat{1}, 'D');
% end
% 
% if sum(rti_data.ix_manufact) ~= 454
%     warning('Not correct number of manufacturing industries.')
% end
% 
% 
% plot_automix_vs_rti(rti_data.automix_use_log_sum_pre1998, ...
%     rti_data.rel_automix_mean_pre1998, rti_data.rti60, ...
%     rti_data.ix_manufact, 'pre1998')
% 
% plot_automix_vs_rti(rti_data.automix_use_log_sum_post1998, ...
%     rti_data.rel_automix_mean_post1998, rti_data.rti60, ...
%     rti_data.ix_manufact, 'post1998')



%% Prepare conversion table
% fyr_start = 1976;
% fyr_end = 2014;

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

% subplot_industries_mean_alg1(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     pat2ind.ind_corresp)


% idata = extract_idata(fyr_start, fyr_end, pat2ind.ind_corresp(:, 1));
% check_idata(idata)


% laborm_series = idata.employment;
% make_bivariate_employment_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))

% laborm_series = idata.labor_productivity;
% make_bivariate_labor_productivity_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))

% laborm_series = idata.capital;
% make_bivariate_capital_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))

% 
% laborm_series = idata.labor_cost;
% make_bivariate_labor_cost_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))

% laborm_series = idata.capital_cost;
% make_bivariate_capital_cost_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))

% laborm_series = idata.production;
% make_bivariate_production_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))

% laborm_series = idata.output;
% make_bivariate_output_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))

% laborm_series = idata.output_deflator;
% make_bivariate_output_deflator_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))

% laborm_series = idata.output_deflator;
% make_bivariate_output_deflator_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))


% laborm_series = idata.capital_productivity;
% make_bivariate_capital_productivity_plot(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
%     laborm_series, pat2ind.ind_corresp(:, 2), pat2ind.ind_corresp(:, 3))




% make_table_meancorr_laborm_patentm(manufacturing_ind_data)

% ix_patentmetric = 3;
% ix_labormvar = 5;
% subplot_patentm_vs_laborm(1976, 2014, manufacturing_ind_data, pat2ind, ...
%     ix_patentmetric, ix_labormvar)


%% Draw patents to classify manually
% draw_patents4manclass


%% Compare classification with manually coded patents

% Load and prepare the manually classified patents
% manclassData = prepare_manclass('manclass_consolidated_v10.xlsx');


% Get keywords and technology numbers for manually classified patents
% automclassData = compile_automclass4codedpats(manclassData.patentnr, ...
%     manclassData.indic_year, year_start, year_end)
% automclassData.indic_exclclassnr = check_classnr_uspc(automclassData.classnr_uspc);
% save('output/automclassData.mat', 'automclassData'); % save to .mat



%%
% Classify patents based on computerized methods
% load('automclassData')


% computerClass = classify_autom_algorith(automclassData);


%% Compare manual vs. computer classification of patents


% Report contingency table for Algorithm1 only
% ix_alg = find( strcmp(computerClass.algorithm_name, 'Algorithm1') );
% classifstat = calculate_manclass_stats(manclassData.manAutomat, ...
%     computerClass.compAutomat(:, ix_alg));
% make_contingency_table(classifstat)

% make_table_evalstats(classifstat)




% compClass_Yes = computerClass.compAutomat(:, ix_alg);
% classifstat_yrly = calculate_classerror_overtime(manclassData, ...
%     compClass_Yes, year_start, year_end);

% plot_classifstat_yrly(classifstat_yrly, year_start, year_end)
% plot_accuracy_yrly(classifstat_yrly, year_start, year_end)
% plot_accuracy_and_fmeasure_yrly(classifstat_yrly, year_start, year_end)


% Compare some algorithms
% choose_compalg_list = {'Algorithm1', 'automat', 'Bessen-Hunt', ...
%     'Always "No"', 'Always "Yes"'};
% choose_compalg_list = computerClass.algorithm_name; % pick all algorithms
% classalg_comparison = comp_evals_algs(choose_compalg_list, ...
%     computerClass, manclassData);

% plot_bar_fmeasure(classalg_comparison.fmeasure, classalg_comparison.algorithm_name)

% max_line = 9; % choose number of algorithms to put on line for table in paper
% make_table_compare_classalg(classalg_comparison, max_line)


%% Extract texts of manually coded patents
% run(test_extract_pat_fileplace);
% patfplace = extract_pat_fileplace(manclassData.patentnr, ...
%     manclassData.indic_year);
% 
% patextr = manclassData;
% 
% patextr.nr_pat_in_file = patfplace.nr_pat_in_file;
% patextr.week = patfplace.week;
% patextr.line_start = patfplace.line_start;
% patextr.line_end = patfplace.line_end;
% 
% save('output/patextr.mat', 'patextr'); % save to .mat

% load('output/patextr.mat', 'patextr');
% check_correct_patextr(patextr)
% 
% for ix_patent = 1:length(patextr.patentnr)
%     extr_patnr = patextr.patentnr(ix_patent);
%     extr_patyear = patextr.indic_year(ix_patent);
%     extr_patweek = patextr.week(ix_patent);
%     extr_patline_start = patextr.line_start(ix_patent);
%     extr_patline_end = patextr.line_end(ix_patent);
% 
%     patparts = extract_specific_patpart(extr_patnr, extr_patyear, ...
%         extr_patweek, extr_patline_start, extr_patline_end);
% 
%     patextr.title_str{ix_patent, 1} = patparts.title_str;
%     patextr.abstract_str{ix_patent, 1} = patparts.abstract_str;
%     patextr.body_str{ix_patent, 1} = patparts.body_str;
%     
%     fprintf('Finished patent: %d/%d.\n', ix_patent, ...
%         length(patextr.patentnr))
% end

% save('output/patextr.mat', 'patextr'); % save to .mat

% load('output/patextr.mat', 'patextr');
% %
% 
% patextr.title_tokens = [];
% patextr.abstract_tokens = [];
% patextr.body_tokens = [];
% 
% stop_words = define_stopwords();
% patextr = extract_tokens_patparts(patextr, stop_words, 'snowball');
% 
% save('output/patextr.mat', 'patextr'); % save to .mat
% load('output/patextr.mat', 'patextr');


%% Summary plots about tokens
% tok_stats = collect_tok_stats(patextr);
% plot_hist_nr_tok(tok_stats)


%% Get unique tokens
% patextr.unique_titleT = unique( extract_nested_cellarray( ...
%     patextr.title_tokens) );
% patextr.unique_abstractT = unique( extract_nested_cellarray( ...
%     patextr.abstract_tokens) );
% patextr.unique_bodyT = unique( extract_nested_cellarray(...
%     patextr.body_tokens) );

% save('output/patextr.mat', 'patextr'); % save to .mat
% load('output/patextr.mat', 'patextr');


%% Compile huge incidence matrices showing which patent contains which term
% tic
% patextr.incidMat_title = compile_incidence_matrix(patextr.unique_titleT, ...
%     patextr.title_tokens);
% toc
% 
% tic
% patextr.incidMat_abstract = compile_incidence_matrix(patextr.unique_abstractT, ...
%     patextr.abstract_tokens);
% toc
% 
% tic
% patextr.incidMat_body = compile_incidence_matrix(patextr.unique_bodyT, ...
%     patextr.body_tokens);
% toc

% save('output/patextr.mat', 'patextr'); % save to .mat
% load('output/patextr.mat', 'patextr');


%% Get some summary statistics on most frequent terms in both groups of 
% documents (automation and non-automation patents)
% patextr.title_occurstats = get_occurstats(patextr.incidMat_title, ...
%     patextr.unique_titleT, patextr.manAutomat);
% 
% patextr.abstract_occurstats = get_occurstats(patextr.incidMat_abstract, ...
%     patextr.unique_abstractT, patextr.manAutomat);
% 
% patextr.body_occurstats = get_occurstats(patextr.incidMat_body, ...
%     patextr.unique_bodyT, patextr.manAutomat);

% save('output/patextr.mat', 'patextr'); % save to .mat
load('output/patextr.mat', 'patextr');


%% Don't use chemical or pharmaceutical patents in manual sample

% Keep first 3 numbers or until first space
classnr_tok = strtok( patextr.uspc_nr );

classnr_3dig = repmat({''}, length(classnr_tok), 1);
for i=1:length(classnr_uspc)
    extrstr = classnr_tok{i};
    
    if numel(extrstr) >=3
        classnr_3dig{i, 1} = extrstr(1:3);
    else
        classnr_3dig{i, 1} = extrstr;
    end
end

% !!! To do: insert "classnr_3dig" in "check_classnr_uspc" and make sure
% it works (no cell array error)
patextr.indic_exclclassnr = check_classnr_uspc()




break
%% Calculate mutual information statistic for every term

feat_incidMat = [patextr.incidMat_title, patextr.incidMat_abstract, ...
    patextr.incidMat_body];

feat_occurMat = +( feat_incidMat > 0 );

manAutomat = patextr.manAutomat;

mutInf = zeros(size(feat_occurMat, 2), 1);

tic
for t = 1:size(feat_occurMat, 2)
    singleTok_class = feat_occurMat(:, t);
    classifstat = calculate_manclass_stats(manAutomat, singleTok_class);
    mutInf(t) = classifstat.mutual_information;
end
toc

mutInf_noNaN = mutInf;
mutInf_noNaN( isnan(mutInf_noNaN) ) = -Inf;

% featTok = [cellfun(@(c) [c ' [title]'], patextr.unique_titleT, 'uni', false);
%            cellfun(@(c) [c ' [abstract]'], patextr.unique_abstractT, 'uni', false);
%            cellfun(@(c) [c ' [body]'], patextr.unique_bodyT, 'uni', false)];
       
featTok = [cellfun(@(c) c, patextr.unique_titleT, 'uni', false);
           cellfun(@(c) c, patextr.unique_abstractT, 'uni', false);
           cellfun(@(c) c, patextr.unique_bodyT, 'uni', false)];

% All patent parts together
% [~, ix_sort] = sort(mutInf_noNaN, 'descend');
% featTok( ix_sort(1:30) )

% % Title
% j = 1:length(patextr.unique_titleT);
% [~, ix_sort] = sort(mutInf_noNaN(j), 'descend');
% aux_featTok = featTok(j);
% aux_featTok( ix_sort(1:30) )
% 
% % Abstract
% j = length(patextr.unique_titleT) + 1 : ...
%     length(patextr.unique_titleT) + length(patextr.unique_abstractT);
% [~, ix_sort] = sort(mutInf_noNaN(j), 'descend');
% aux_featTok = featTok(j);
% aux_featTok( ix_sort(1:30) )
% 
% Patent body
j = length(patextr.unique_titleT) + length(patextr.unique_abstractT) + 1 : ...
    length(patextr.unique_titleT) + length(patextr.unique_abstractT) + ...
    length(patextr.unique_bodyT);
[sort_mutInf, ix_sort] = sort(mutInf_noNaN(j), 'descend');
aux_featTok = featTok(j);

nr_meaningfulTok = 500;
meaningfulTok = aux_featTok( ix_sort(1:nr_meaningfulTok) );








