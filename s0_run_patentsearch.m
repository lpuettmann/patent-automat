clear all
close all


% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()

%% Choose years 
year_start = 1976;
year_end = 2014;
opt2001 = 'txt'; % which version of 2001 files? ('txt' or 'xml')

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
[pdata, fDictColNames, dictInc] = func(patextr, ...
    find_dictionary);
save('output/pdata.mat', 'pdata')
save('output/fDictColNames', 'fDictColNames')
save('output/dictInc.mat', 'dictInc')
clear patextr find_dictionary pdata fDictColNames dictInc


%% Classify all patents with Naive Bayes
load('patextr')
load('find_dictionary')
nb_classify_patents(year_start, year_end, patextr, find_dictionary);
clear patextr find_dictionary


%% Extract posterior probabilities and save in format for R
nb_stats.year = [];
nb_stats.patentnr = [];
nb_stats.post_yes = [];
nb_stats.post_no = [];

for ix_year=1976:2015;
    ix_iter = ix_year - year_start + 1;

    fname = ['patsearch_results_', num2str(ix_year), '.mat'];
    load(fname)
   
    nb_stats.year = [nb_stats.year; 
        repmat(ix_year, length(patsearch_results.patentnr), 1)];

    nb_stats.patentnr = [nb_stats.patentnr; patsearch_results.patentnr];
     
    load_name = horzcat('nb_post_', num2str(ix_year), '.mat');
    load(load_name)
    
    nb_stats.post_yes = [nb_stats.post_yes; nb_post.post_yes];
    nb_stats.post_no = [nb_stats.post_no; nb_post.post_no];
    
    fprintf('Posteriors for year: %d.\n', ix_year)
    clear patsearch_results nb_post
end

save('output/nb_stats.mat', 'nb_stats')
clear np_stats

% Save in smaller chunks
load('output/nb_stats.mat')

nb_stats_patentnr = nb_stats.patentnr;
csvwrite('output/nb_stats_patentnr.csv', nb_stats_patentnr)

nb_stats_post_yes = nb_stats.post_yes;
csvwrite('output/nb_stats_post_yes.csv', nb_stats_post_yes)

nb_stats_post_no = nb_stats.post_no;
csvwrite('output/nb_stats_post_no.csv', nb_stats_post_no)

nb_stats_year = nb_stats.year;
csvwrite('output/nb_stats_year.csv', nb_stats_year)



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
    
    autompatsIncl = find(patsearch_results.is_nbAutomat & ...
        not(patsearch_results.indic_exclclassnr));

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
        cats_yearstats(t, i + 7) = sum(fullCats(autompatsIncl) == i);
    end
    
    cats_yearstats(t, 7) = sum(missOvercat);
    cats_yearstats(t, 14) = sum(missOvercat(autompatsIncl));
    assert(sum(cats_yearstats(t, 1:7)) == length(patsearch_results.patentnr))
    fprintf('%d\n', ix_year)
end

save('output/cats_yearstats.mat', 'cats_yearstats')

% Make plot
load('output/cats_yearstats.mat')
plot_patent_types(cats_yearstats)
clear cats_yearstats


