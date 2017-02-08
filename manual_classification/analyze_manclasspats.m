function [find_dictionary, patextr] = analyze_manclasspats(fname, ...
    indicStemmer, stop_words, opt2001)
% Analyze the manually classified patents.


%% Load and prepare the manually classified patents
patextr = prepare_manclass(fname);


%% Extract full texts of manually coded patents
run(test_extract_pat_fileplace);

patextr = prepare_manclass(fname);

patfplace = extract_pat_fileplace(patextr.patentnr, patextr.indic_year);

patextr.nr_pat_in_file = patfplace.nr_pat_in_file;
patextr.week = patfplace.week;
patextr.line_start = patfplace.line_start;
patextr.line_end = patfplace.line_end;
patextr.uspc_nr = patfplace.uspc_nr % USPC technology numbers

% Determine which patents from analysis to exclude based on tech. class
patextr.indic_exclclassnr = get_indic_exclclassnr(patextr.uspc_nr);

% Check that things look plausible
check_correct_patextr(patextr)

% For all manually classified patents, extract full patent text parts.
for ix_patent = 1:length(patextr.patentnr)
for ix_patent = 349:length(patextr.patentnr)
    extr_patnr = patextr.patentnr(ix_patent);
    extr_patyear = patextr.indic_year(ix_patent);
    extr_patweek = patextr.week(ix_patent);
    extr_patline_start = patextr.line_start(ix_patent);
    extr_patline_end = patextr.line_end(ix_patent);

    patparts = extract_specific_patpart(extr_patnr, extr_patyear, ...
        extr_patweek, extr_patline_start, extr_patline_end, opt2001);

    patextr.title_str{ix_patent, 1} = patparts.title_str;
    patextr.abstract_str{ix_patent, 1} = patparts.abstract_str;
    patextr.body_str{ix_patent, 1} = patparts.body_str;
    
    fprintf('Extracted text parts for patent: %d/%d.\n', ix_patent, ...
        length(patextr.patentnr))
end

patextr.title_tokens = [];
patextr.abstract_tokens = [];
patextr.body_tokens = [];

patextr = extract_tokens_patparts(patextr, stop_words, indicStemmer);


%% Summary plots about tokens
tok_stats = collect_tok_stats(patextr);
plot_hist_nr_tok(tok_stats)


%% Get unique tokens
patextr.unique_titleT = unique( extract_nested_cellarray( ...
    patextr.title_tokens) );
patextr.unique_abstractT = unique( extract_nested_cellarray( ...
    patextr.abstract_tokens) );
patextr.unique_bodyT = unique( extract_nested_cellarray(...
    patextr.body_tokens) );


%% Compile huge incidence matrices showing which patent contains which term
tic
patextr.incidMat_title = compile_incidence_matrix(patextr.unique_titleT, ...
    patextr.title_tokens, 'verbose');
toc

tic
patextr.incidMat_abstract = compile_incidence_matrix(...
    patextr.unique_abstractT, patextr.abstract_tokens, 'verbose');
toc

tic
patextr.incidMat_body = compile_incidence_matrix(patextr.unique_bodyT, ...
    patextr.body_tokens, 'verbose');
toc


%% Get some summary statistics on most frequent terms in both groups of 
% documents (automation and non-automation patents)
patextr.title_occurstats = get_occurstats(patextr.incidMat_title, ...
    patextr.unique_titleT, patextr.manAutomat);

patextr.abstract_occurstats = get_occurstats(patextr.incidMat_abstract, ...
    patextr.unique_abstractT, patextr.manAutomat);

patextr.body_occurstats = get_occurstats(patextr.incidMat_body, ...
    patextr.unique_bodyT, patextr.manAutomat);


%% Calculate mutual information statistic for every term
i = not( patextr.indic_exclclassnr ); % which patents to include

patextr.tokRanking_title = rank_tokens(...
    patextr.incidMat_title(i, :), patextr.manAutomat(i), ...
    patextr.unique_titleT);

patextr.tokRanking_abstract = rank_tokens(patextr.incidMat_abstract(i, :), ...
    patextr.manAutomat(i), patextr.unique_abstractT);

patextr.tokRanking_body = rank_tokens(patextr.incidMat_body(i, :), ...
    patextr.manAutomat(i), patextr.unique_bodyT);


%% Make the union of the top ranked tokens in all parts and check overlap
all_rankedTok = [patextr.tokRanking_title.meaningfulTok(1:nr_feat_title); 
     patextr.tokRanking_abstract.meaningfulTok(1:nr_feat_abstract);
     patextr.tokRanking_body.meaningfulTok(1:nr_feat_body)];

selectedTok = unique( all_rankedTok )

original_findTok = tokenize_string( strjoin( define_dictionary() ), ...
    indicStemmer, define_stopwords() );

find_dictionary = unique([selectedTok; original_findTok]);


%%
i = not(patextr.indic_exclclassnr); % which patents to include

tokstats = calc_cond_probs_toks(patextr.incidMat_title(i, :), ...
    find_dictionary, patextr.manAutomat(i), patextr.unique_titleT);
patextr.title_cond_prob_yes = tokstats.cond_prob_yes;
patextr.title_cond_prob_no = tokstats.cond_prob_no;

tokstats = calc_cond_probs_toks(patextr.incidMat_abstract(i, :), ...
    find_dictionary, patextr.manAutomat(i), patextr.unique_abstractT);
patextr.abstract_cond_prob_yes = tokstats.cond_prob_yes;
patextr.abstract_cond_prob_no = tokstats.cond_prob_no;

tokstats = calc_cond_probs_toks(patextr.incidMat_body(i, :), ...
    find_dictionary, patextr.manAutomat(i), patextr.unique_bodyT);
plotmatrix_tokstats([tokstats.cond_prob_yes, tokstats.cond_prob_no, ...
    tokstats.mutual_information, tokstats.nr_appear]);
patextr.body_cond_prob_yes = tokstats.cond_prob_yes;
patextr.body_cond_prob_no = tokstats.cond_prob_no;

patextr.prior_automat = sum(patextr.manAutomat(i)) / ...
    length(patextr.manAutomat(i));
patextr.prior_notautomat = 1 - patextr.prior_automat;

% Plot conditional probabilities for tokens
plot_cprob_tokclass(patextr)

