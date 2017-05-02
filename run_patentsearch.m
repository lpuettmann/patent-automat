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


load('output/cats_yearstats.mat')

%load('nb_stats')
plot_settings_global

figure
subplot(2,1,1)
bar(year_start:year_end, cats_yearstats(:,1:7), 'stacked')
legend('Chemical', 'Computers and Communications', ...
    'Drugs and Medical', 'Electrical and Electronic', 'Mechanic', ...
    'Others', 'Missing data', 'Location', 'NorthWest')
legend boxoff  
xlim([year_start, year_end])
set(gca,'FontSize', 16) % change default font size of axis labels
set(gca,'TickDir','out')  
box off
title('All patents')

subplot(2,1,2)
bar(year_start:year_end, cats_yearstats(:,8:14), 'stacked')
legend('Chemical', 'Computers and Communications', ...
    'Drugs and Medical', 'Electrical and Electronic', 'Mechanic', ...
    'Others', 'Missing data', 'Location', 'NorthWest')
legend boxoff  
xlim([year_start, year_end])
set(gca,'FontSize', 16) % change default font size of axis labels
set(gca,'TickDir','out')  
box off
title('Automation patents')


% subplot(3,1,3)
% bar(year_start:year_end, cats_yearstats(:,8:14) ./ repmat(sum(cats_yearstats(:,1:7), 2), 1, 7), 'stacked')
% legend('Chemical', 'Computers and Communications', ...
%     'Drugs and Medical', 'Electrical and Electronic', 'Mechanic', ...
%     'Others', 'Missing data', 'Location', 'NorthWest')
% legend boxoff  
% xlim([year_start, year_end])
% set(gca,'FontSize', 16) % change default font size of axis labels
% set(gca,'TickDir','out')  
% box off
% title('Automation patents as share of total')


break


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

for i = 1:10
    vnum = 55 + i; % give this a version number to refer back to it later
    tic
    draw_patents4manclass(vnum, 1, year_start, year_end)
    toc
end


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

    % Load matches
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)

    % Load patent_index for year
    % -------------------------------------------------------------------
    build_load_filename = horzcat('patent_index_', num2str(ix_year), ...
        '.mat');
    load(build_load_filename)
    
    patsearch_results = clean_matches(pat_ix, patent_keyword_appear, ...
        ix_year, opt2001);
    
    save_name = horzcat('cleaned_matches/patsearch_results_', ...
        num2str(ix_year), '.mat');
    save(save_name, 'patsearch_results');
end


%% Check matches for plausibility
check_cleanedmatches_plausability(year_start, year_end)


%% Compile a dataset and save in a format that can be opened in R
load('output/patextr.mat')
load('find_dictionary')
[pdata, fDictColNames, dictInc] = create_R_dataset(patextr, ...
    find_dictionary);
save('output/pdata.mat', 'pdata')
save('output/fDictColNames', 'fDictColNames')
save('output/dictInc.mat', 'dictInc')
clear patextr find_dictionary pdata fDictColNames dictInc


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

%% Get overcategories for patents
for ix_year = year_start:year_end

    fname = ['patsearch_results_', num2str(ix_year)];
    load(fname);

    % Extract and clean the USPC technology numbers
    classnr_uspc = format_classnr_uspc(patsearch_results.classnr_uspc, ...
        'verbose');

    % Check for correct inputs
    assert( not( isstr( classnr_uspc ) ) ) % not a string
    assert( not( iscell( classnr_uspc ) ) ) % not a cell array

    load('crosswalk')

    % Check if tech numbers of manually classified patents is one of those
    % chosen to be excluded
    overcat_classnr = nan( size(classnr_uspc) );

    for i=1:size(classnr_uspc,1)   
        pick_classnr = classnr_uspc(i);    
        overcat = crosswalk(find(crosswalk(:, 2) == pick_classnr), 1);
        if isempty(overcat)
            overcat = NaN;
        end
        overcat_classnr(i) = overcat;
    end

    fprintf('[%d] Missing overcategories: %3.2f.\n', ix_year, ...
        sum(isnan(overcat_classnr)) / size(classnr_uspc,1))

    assert(all(overcat_classnr(not(isnan(overcat_classnr))) <= 69))
    assert(all(overcat_classnr(not(isnan(overcat_classnr))) >= 10))
    
    % Check which of these to exclude
    patsearch_results.overcat_classnr = overcat_classnr;

    save(['cleaned_matches/', fname, '.mat'], 'patsearch_results')
end


%% Extract overcategories for all patents and save yearly statistics
for ix_year = year_start:year_end
    t = ix_year - year_start + 1;
    fname = ['patsearch_results_', num2str(ix_year)];
    load(fname);

    missOvercat = isnan(patsearch_results.overcat_classnr);
    overcat = patsearch_results.overcat_classnr(not(missOvercat));
    
    catStr = cellstr(num2str(overcat(:)));
    cats = cellfun(@(x) x(1), catStr, 'UniformOutput', false);
    cats = str2double(cats);
    assert(length(unique(cats)) == 6)
    
    fullCats = nan(length(patsearch_results.patentnr), 1);
    fullCats(not(missOvercat)) = cats;
    
    for i = 1:6
        cats_yearstats(t, i) = sum(fullCats == i);
        cats_yearstats(t, i + 7) = sum(fullCats(find( ... 
            patsearch_results.is_nbAutomat)) == i);
    end
    
    cats_yearstats(t, 7) = sum(missOvercat);
    cats_yearstats(t, 14) = sum(missOvercat(find( ...
        patsearch_results.is_nbAutomat)));
    assert(sum(cats_yearstats(t, 1:7)) == length(patsearch_results.patentnr))
    fprintf('%d\n', ix_year)
end

save('output/cats_yearstats.mat', 'cats_yearstats')



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
plot_ix = 1:10; % is this ok?

plot_overcat_sic_automatix_subplot(aggr_automix, sic_overcategories, ...
    year_start, year_end, plot_ix)

load('output/nb_stats.mat')
normFac = 1 ./ (nb_stats.yearstats.nrAllPats ./ ...
    nb_stats.yearstats.nrAllPats(25));
clear nb_stats

normMat = repmat(normFac, 1, size(aggr_automix, 2))
norm_aggr_automix = aggr_automix .* normMat;

plot_overcat_sic_automatix_subplot_normalized(norm_aggr_automix, ...
    sic_overcategories, year_start, year_end, plot_ix)

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

