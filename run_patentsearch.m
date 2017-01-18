clear all
close all


% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()

%% Choose years 
year_start = 1976;
year_end = 2015;
opt2001 = 'txt'; % which version of 2001 files? ('txt' or 'xml')


%% Make patent index
for ix_year=year_start:year_end
    tic
 
    % Search for keywords in the patent grant texts
    try
        pat_ix = make_patent_index(ix_year, opt2001);
    catch
        warning('Problem in year: %d. Go to next year.', ix_year)
        continue
    end
    
    % Print how long the year took
    print_finish_summary(toc, ix_year)
    
    % Save to .mat file
    save_patix2mat(pat_ix, ix_year)
end

clear pat_ix


%% Draw patents to classify manually
vnum = 15; % give this a version number to refer back to it later
draw_patents4manclass(vnum, year_start, year_end)


%% Use the manual classifications
fname = 'manclass_consolidated_v10.xlsx';
nr_feat_title = 50;
nr_feat_abstract = 200;
nr_feat_body = 500;
indicStemmer = 'snowball'; % Options: 'porter' or 'snowball'
stop_words = define_stopwords();             

[find_dictionary, patextr] = analyze_manclasspats(fname, indicStemmer, ...
    stop_words);

save('specs/find_dictionary.mat', 'find_dictionary')
save('output/patextr.mat', 'patextr');
clear patextr


%% Search for keywords
for ix_year=year_start:year_end
    tic
    
    % Load patent_index for year
    load(horzcat('patent_index_', num2str(ix_year), '.mat'))
    
    % Search for keywords in the patent grant texts
    patent_keyword_appear = analyze_patent_text(ix_year, ...
        find_dictionary, opt2001, pat_ix);
    
    % Print how long the year took
    print_finish_summary(toc, ix_year)
    
    % Save to .mat file
    save_patent_keyword_appear2mat(patent_keyword_appear, ix_year)
    
    clear pat_ix
end


%% Clean matches
for ix_year=years

    patsearch_results = clean_matches(ix_year);
    
    save_name = horzcat('cleaned_matches/patsearch_results_', ...
        num2str(ix_year), '.mat');
    save(save_name, 'patsearch_results');
end


%% Check matches for plausibility
check_cleanedmatches_plausability(year_start, year_end)


%% Classify all patents based the manually classified sample
load('patextr')
load('find_dictionary')
nb_classify_patents(year_start, year_end, patextr, find_dictionary);
clear patextr find_dictionary


%% Check for all patents which ones to exclude from analysis based on 
% their technology class
for ix_year=year_start:year_end;
    
    fname = ['patsearch_results_', num2str(ix_year)];
    load(fname);
    
    % Extract and clean the USPC technology numbers
    classnr_uspc = format_classnr_uspc(patsearch_results.classnr_uspc, ...
        'verbose');

    % Check which of these to exclude
    patsearch_results.indic_exclclassnr = check_classnr_uspc(classnr_uspc);

    save(['cleaned_matches/', fname, '.mat'], 'patsearch_results')
    
    fprintf('%d: %3.1f percent excluded.\n', ix_year, ...
        sum(patsearch_results.indic_exclclassnr) ./ ...
        length(patsearch_results.patentnr)*100)
end


%%
nb_stats = compile_class_stats(year_start, year_end);
save('output/nb_stats.mat', 'nb_stats');


%% Link patents to sector of use using Silverman concordance
ipcsicfinalv5 = readtable('IPCSICFINALv5.txt', 'Delimiter', ' ', ...
    'ReadVariableNames', false);

% Variables in Silverman concordance table:
%   - ipc: IPC class and subclass      
%   - sic: US SIC
%   - mfgfrq: frequency of patents in IPC assigned to SIC of manufacture
%   - usefrq: frequency of patents in IPC assigned to SIC of use
ipcsicfinalv5.Properties.VariableNames = {'ipc', 'sic', 'mfgfrq', ...
    'usefrq'};

construct_sic_automix(year_start, year_end, ipcsicfinalv5)


%% Compile SIC automatix
sic_automix_allyears = compile_sic_automix_table(year_start, year_end);

savename = 'output/sic_automix_allyears.mat';
save(savename, 'sic_automix_allyears')
fprintf('Saved: %s.\n', savename)


%% Analyse SIC automatix table
load('output/sic_automix_allyears.mat')

sic_overcategories = define_sic_overcategories();

% Get some summary series for over-categories of industries
[aggr_automix, aggr_automix_share] = ...
    get_sic_ocat_automix_data(year_start, year_end, ...
    sic_automix_allyears, sic_overcategories);

% Sort the series for plotting
[~, plot_ix] = sort( aggr_automix_share(end, :) );
plot_ix = 1:10;

plot_overcat_sic_automatix_subplot(aggr_automix, sic_overcategories, ...
    year_start, year_end, plot_ix)

plot_overcat_sic_automatix_share_subplot_gray(aggr_automix_share, ...
    sic_overcategories, year_start, year_end, plot_ix)

plot_overcat_sic_automatix_share_subplot(aggr_automix_share, ...
    sic_overcategories, year_start, year_end, plot_ix)

plot_overcat_sic_automatix_share_subplot_gray_allSubCat(...
    year_start, year_end, sic_overcategories, sic_automix_allyears, ...
    aggr_automix_share, plot_ix)


for pick_hl=1:size(sic_overcategories, 1) + 1
    
    plot_overcat_sic_automatix_share_circles(aggr_automix_share, ...
        aggr_automix, sic_overcategories, year_start, year_end, pick_hl)
    
    plot_overcat_sic_automatix_share(aggr_automix_share, ...
        sic_overcategories, year_start, year_end, pick_hl)
    
    plot_overcat_sic_automatix(aggr_automix, ...
        sic_overcategories, year_start, year_end, pick_hl)
    
    plot_overcat_sic_lautomatix(aggr_automix, ...
        sic_overcategories, year_start, year_end, pick_hl)    
    
    pause(1.5)
end



%% Import Routine Task Index (RTI) by Autor, Levy and Murnane (2003)
rti_data = readtable('idata_rti.xlsx');
rti_data.rti60 = rti_data.rti60 / 100; % from percentage to share

[sic_list, ~, ix_map] = unique( sic_automix_allyears.sic );

sic_automix_allyears.rti60 = nan( size( sic_automix_allyears.sic ) );

for i=1:length(sic_list)
    sic_pick = sic_list(i);    
    ix_extr = find( sic_pick == rti_data.sic );    
    assert( length(ix_extr) <= 1)
    
    sic_summary(i, 2) = sic_pick;
    if isempty( ix_extr ) 
        sic_summary(i, 2) = NaN;
    else
        sic_summary(i, 2) = rti_data.rti60(ix_extr);
    end
    
    ix_insert = find( ix_map == i );
    
    for j=1:length(ix_insert)
        sic_automix_allyears.rti60(ix_insert(j)) = sic_summary(i, 2);
    end
end


%% Insert the relative automation index in the table
sic_automix_allyears.rel_automix = sic_automix_allyears.automix_use ./ ...
    sic_automix_allyears.patents_use;


%% Create CSV file with the full SIC industry year observations
tic
fname = './output/sic_automix_allyears.csv';
writetable(sic_automix_allyears, fname)
toc


%% Get summary statistics for all years
for i=1:length(rti_data.sic)
    
    ix_pick = ( sic_automix_allyears.sic == rti_data.sic(i) );
    
    ix_year = ( sic_automix_allyears.year <= 1998 ); 
    
    ix_pre1998 = ( ix_pick & ix_year );
    ix_post1998 = ( ix_pick & not(ix_year) );
    
    assert(isequal(ix_pre1998 + ix_post1998, ix_pick), 'Should be equal.')
    
    rti_data.automix_use_log_sum_pre1998(i) = log( sum( ...
        sic_automix_allyears.automix_use(ix_pre1998) ) );   
    
    rti_data.automix_use_log_sum_post1998(i) = log( sum( ...
        sic_automix_allyears.automix_use(ix_post1998) ) ); 
    
    rti_data.rel_automix_mean_pre1998(i, 1) = mean( ...
        sic_automix_allyears.rel_automix(ix_pre1998) );   
    
    rti_data.rel_automix_mean_post1998(i, 1) = mean( ...
        sic_automix_allyears.rel_automix(ix_post1998) );   
    
    % Save an indicator of whether this SIC is in manufacturing
    pick_overcat = sic_automix_allyears.overcat( ix_pick );
    
    rti_data.ix_manufact(i, 1) = +strcmp( pick_overcat{1}, 'D');
end

if sum(rti_data.ix_manufact) ~= 454
    warning('Not correct number of manufacturing industries.')
end


plot_automix_vs_rti(rti_data.automix_use_log_sum_pre1998, ...
    rti_data.rel_automix_mean_pre1998, rti_data.rti60, ...
    rti_data.ix_manufact, 'pre1998')

plot_automix_vs_rti(rti_data.automix_use_log_sum_post1998, ...
    rti_data.rel_automix_mean_post1998, rti_data.rti60, ...
    rti_data.ix_manufact, 'post1998')



%% Prepare conversion table
fyr_start = 1976;
fyr_end = 2014;

fname = 'Naics_co13.csv';
lnumber = 203074; % unfortunately hard-code line number
tic
disp('Start preparing conversion table:')
conversion_table = prepare_conversion_table(fname, lnumber);
fprintf('Finished preparing conversion table, time = %d minutes.\n', ...
    round(toc/60))
save('output/conversion_table', 'conversion_table')


%% Link patents to industries
load('conversion_table')
pat2ind = conversion_patent2industry(fyr_start, fyr_end, conversion_table);
save('output/pat2ind', 'pat2ind')


%% Industry-level analysis
load('pat2ind')

max_nr_patlink2ind = max( pat2ind.nr_appear_allyear);

for i=0:max_nr_patlink2ind
    ix_iter = i + 1;
    nr_patlink2ind(ix_iter) = sum(pat2ind.nr_appear_allyear == i) ./ ...
        length(pat2ind.nr_appear_allyear);
end





subplot_industries_alg1(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
    pat2ind.ind_corresp)

subplot_industries_mean_alg1(fyr_start, fyr_end, pat2ind.industry_sumstats, ...
    pat2ind.ind_corresp)


idata = extract_idata(fyr_start, fyr_end, pat2ind.ind_corresp(:, 1));
check_idata(idata)


make_table_meancorr_laborm_patentm(manufacturing_ind_data)

ix_patentmetric = 3;
ix_labormvar = 5;
subplot_patentm_vs_laborm(1976, 2014, manufacturing_ind_data, pat2ind, ...
    ix_patentmetric, ix_labormvar)


