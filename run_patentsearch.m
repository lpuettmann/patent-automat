clear all
close all


% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()

%% Choose years 
year_start = 1976;
year_end = 2015;


%% Get patent texts
% parent_dname = 'patent_data'; % parent directory name (path to data)

% Download the files from Google Patents (careful, these are 300 GB)
% download_patent_files(year_start, year_end, parent_dname)

% Unzip all files and delete zipped files
% unzip_patent_files(year_start, year_end, parent_dname)


%% Make patent index
% for ix_year=year_start:year_end
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


%% Draw patents to classify manually
% vnum = 15; % give this a version number to refer back to it later
% draw_patents4manclass(vnum, year_start, year_end)


%% Use the manual classifications
% fname = 'manclass_consolidated_v10.xlsx';
% nr_feat_title = 50;
% nr_feat_abstract = 200;
% nr_feat_body = 500;
% indicStemmer = 'snowball'; % Options: 'porter' or 'snowball'
% stop_words = define_stopwords();             
% 
% [find_dictionary, patextr] = analyze_manclasspats(fname, indicStemmer, ...
%     stop_words);
% 
% save('specs/find_dictionary.mat', 'find_dictionary')
% save('output/patextr.mat', 'patextr');


%% Search for keywords
% for ix_year=year_start:year_end
%     tic
%     
%     % Define dictionary to search for
%     find_dictionary = load_full_dict();
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


%% Clean matches
% for ix_year=years
% 
%     patsearch_results = clean_matches(ix_year);
%     
%     save_name = horzcat('cleaned_matches/patsearch_results_', ...
%         num2str(ix_year), '.mat');
%     save(save_name, 'patsearch_results');
% end



%% Compare matches with previous searches
% disp('Compare new keyword searches with old ...')
% disp(' ')
% 
% for ix_year=years
%     
%     compare_matches(ix_year)
%     
%     fprintf('Finished comparing matches for year: %d.\n', ix_year)
%     disp('_________________________________________________')
% end


%% Check matches for plausibility
% check_cleanedmatches_plausability(year_start, year_end)


%% Classify all patents based the manually classified sample

% load('patextr')
% cond_prob_yes = [patextr.title_cond_prob_yes; patextr.abstract_cond_prob_yes; ...
%     patextr.body_cond_prob_yes];
% cond_prob_no = [patextr.title_cond_prob_no; patextr.abstract_cond_prob_no; ...
%     patextr.body_cond_prob_no];
% prior_yes = patextr.prior_automat;
% prior_no = patextr.prior_notautomat;
% clear patextr
% 
% load('find_dictionary')
% 
% for ix_year=year_start:year_end;
%     load(['patsearch_results_', num2str(ix_year), '.mat']);
% 
%     P = length(patsearch_results.patentnr);
% 
%     nb_post.post_yes = NaN(P, 1);
%     nb_post.post_no = NaN(P, 1);
%     share_probs_higherYes = NaN(P, 1);
% 
%     for p=1:P
%         patMatches = [patsearch_results.title_matches(p, :), ...
%             patsearch_results.abstract_matches(p, :), ...
%             patsearch_results.body_matches(p, :)];
%         patOccur = +(patMatches > 0)'; % logical to double
%         indic_appear = logical( full( patOccur ) );
% 
%         % Calculate updated posterior probabilty of the patent belonging to
%         % either class
%         nb_post.post_yes(p) = calc_post_nb(prior_yes, cond_prob_yes, indic_appear);
%         nb_post.post_no(p) = calc_post_nb(prior_no, cond_prob_no, indic_appear);
% 
%         if mod(p, 1000) == 0
%             temp = +(nb_post.post_yes(p - 999 : p) > nb_post.post_no(p - 999 : p));
%             share_temp = sum(temp) / length(temp);
%             fprintf('Patent %d/%d finished: %3.2f percent automation patents.\n', ...
%                 p, P, share_temp)
%         end
%     end
%     
%     save_name = horzcat('nb_posteriors/nb_post_', num2str(ix_year), ...
%         '.mat');
%     save(save_name, 'nb_post');    
%     disp('_____________________________________________________')
%     fprintf('Finished calculating posterior prob''s for year: %d.\n', ix_year)
%     disp(' ')
% 
%     clear nb_post
% end


%% Check Naive Bayes for plausibility
% check_plausible_nb_post(year_start, year_end)


%% Classify patents based on the posterior probabilities
% for ix_year=year_start:year_end;
%     ix_iter = ix_year - year_start + 1;
%     
%     load_name = horzcat('nb_post_', num2str(ix_year), '.mat');
%     load(load_name)
% 
%     is_nbAutomat = +( nb_post.post_yes > nb_post.post_no );
%        
%     fname = ['patsearch_results_', num2str(ix_year), '.mat'];
%     load(fname);
%     patsearch_results.is_nbAutomat = is_nbAutomat;
%     save(['cleaned_matches/', fname], patsearch_results);
%     fprintf('Year: %d.\n', ix_year)
% end

%%
% for ix_year=year_start:year_end;
%     
%     fname = ['patsearch_results_', num2str(ix_year)];
%     load(fname);
%     
%     % Extract and clean the USPC technology numbers
%     classnr_uspc = format_classnr_uspc(patsearch_results.classnr_uspc);
%     % Check which of these to exclude
%     patsearch_results.indic_exclclassnr = check_classnr_uspc(classnr_uspc);
%     
%     save(['cleaned_matches/', fname, '.mat'], 'patsearch_results')
%     
%     fprintf('%d: %3.1f percent excluded.\n', ix_year, ...
%         sum(patsearch_results.indic_exclclassnr) ./ ...
%         length(patsearch_results.patentnr)*100)
% end


%%
% nb_stats = compile_class_stats(year_start, year_end);
% save('output/nb_stats.mat', 'nb_stats');
% 
%
%%
% load('output/nb_stats')
% 
% ix_new_year = diff(nb_stats.weekstats.year);
% ix_new_year(1) = 1; % first year
% ix_new_year = find(ix_new_year);
% 
% plot_nb_overtime(year_start, year_end, nb_stats.weekstats.nrAutomat, ...
%     ix_new_year)
% 
% plot_series = nb_stats.weekstats.shareAutomat;
% plot_nb_share(year_start, year_end, plot_series, ix_new_year)
% 
% 
% 
% plot_nb_autompat_yearly(year_start, year_end, ...
%     nb_stats.yearstats.shareAutomat)


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


% make_table_meancorr_laborm_patentm(manufacturing_ind_data)

% ix_patentmetric = 3;
% ix_labormvar = 5;
% subplot_patentm_vs_laborm(1976, 2014, manufacturing_ind_data, pat2ind, ...
%     ix_patentmetric, ix_labormvar)


