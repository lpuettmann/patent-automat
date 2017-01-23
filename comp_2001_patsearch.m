clear all
close all


% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()

% Choose years 
ix_year = 2001;
opt2001 = 'xml';

%% Compare raw matches
% 
% load('./comp_2001/patent_keyword_appear_2001.mat')
% pat_xml = patent_keyword_appear;
% 
% load('./matches/patent_keyword_appear_2001.mat')
% pat_txt = patent_keyword_appear;
% clear patent_keyword_appear
% 
% l_txt = length(pat_txt.patentnr);
% l_xml = length(pat_xml.patentnr);
% 
% fprintf('# patents txt: %d, # patents xml: %d (change: %3.1f percent).\n', ...
%     l_txt, l_xml, l_txt / l_xml * 100 - 100)


%% Compare cleaned matches
% load('./cleaned_matches/patsearch_results_2001.mat')
% pclean_txt = patsearch_results;
% 
% load('./comp_2001/patsearch_results_2001_comp.mat')
% pclean_xml = patsearch_results;
% clear patsearch_results
% 
% lclean_txt = length(pclean_txt.patentnr);
% lclean_xml = length(pclean_xml.patentnr);
% 
% fprintf('# patents txt: %d, # patents xml: %d (change: %3.1f percent).\n', ...
%     lclean_txt, lclean_xml, lclean_txt / lclean_xml * 100 - 100)
% 
% % Convert strings to numbers
% pclean_txt.patentnr = cellfun(@str2num, pclean_txt.patentnr);
% pclean_xml.patentnr = cellfun(@str2num, pclean_xml.patentnr);
% 
% pint.patentnr = intersect(pclean_txt.patentnr, pclean_xml.patentnr);
% pdiff.patentnr = setdiff(pclean_txt.patentnr, pclean_xml.patentnr);
% 
% pdiff.ix = find( ismember(pclean_txt.patentnr, pdiff.patentnr) );
% 
% ndiff = length(pdiff.ix);
% assert(ndiff == length(pdiff.patentnr))
% 
% fprintf('Number missing patents: %d (%3.1f percent).\n', ndiff, ...
%     ndiff / lclean_txt * 100)
% 
% pdiff.classnr_uspc = pclean_txt.classnr_uspc(pdiff.ix);
% pdiff.week = pclean_txt.week(pdiff.ix);
% pdiff.classnr_ipc = pclean_txt.classnr_ipc(pdiff.ix);
% pdiff.title_matches = pclean_txt.title_matches(pdiff.ix);
% pdiff.abstract_matches = pclean_txt.abstract_matches(pdiff.ix);
% pdiff.body_matches = pclean_txt.body_matches(pdiff.ix);
% pdiff.length_pattext = pclean_txt.length_pattext(pdiff.ix);
% pdiff.is_nbAutomat = pclean_txt.is_nbAutomat(pdiff.ix);
% pdiff.indic_exclclassnr = pclean_txt.indic_exclclassnr(pdiff.ix);
% 
% fprintf('Number of missing patents classified as automation patents: %3.1f percent.\n', ...
%     sum(pdiff.is_nbAutomat) / ndiff * 100)


%%
load('patextr')
load('find_dictionary')

%% Calculate posterior probabilities for all patents
cond_prob_yes = [patextr.title_cond_prob_yes; ...
    patextr.abstract_cond_prob_yes; patextr.body_cond_prob_yes];
cond_prob_no = [patextr.title_cond_prob_no; ...
    patextr.abstract_cond_prob_no; patextr.body_cond_prob_no];
prior_yes = patextr.prior_automat;
prior_no = patextr.prior_notautomat;
clear patextr

load('comp_2001/patsearch_results_2001_comp');

P = length(patsearch_results.patentnr);

nb_post.post_yes = NaN(P, 1);
nb_post.post_no = NaN(P, 1);
share_probs_higherYes = NaN(P, 1);

disp('Start calculating posteriors:')

for p=1:P
    patMatches = [patsearch_results.title_matches(p, :), ...
        patsearch_results.abstract_matches(p, :), ...
        patsearch_results.body_matches(p, :)];
    patOccur = +(patMatches > 0)'; % logical to double
    indic_appear = logical( full( patOccur ) );

    % Calculate updated posterior probabilty of the patent belonging to
    % either class
    nb_post.post_yes(p) = calc_post_nb(prior_yes, cond_prob_yes, indic_appear);
    nb_post.post_no(p) = calc_post_nb(prior_no, cond_prob_no, indic_appear);

    if mod(p, 1000) == 0
        temp = +(nb_post.post_yes(p - 999 : p) > nb_post.post_no(p - 999 : p));
        share_temp = sum(temp) / length(temp);
        fprintf('Patent %d/%d finished, share automation: %3.2f.\n', ...
            p, P, share_temp)
    end
end

save('comp_2001/nb_post_2001.mat', 'nb_post');    


%% Check Naive Bayes for plausibility
assert( all( nb_post.post_yes < 0 ) )
assert( all( nb_post.post_no < 0 ) )

assert( not( any( isnan(nb_post.post_yes) ) ) )
assert( not( any( isnan(nb_post.post_no) ) ) )

assert( length( nb_post.post_yes ) == length( nb_post.post_no ) )

% Check if same number of posteriors as patents
P = length(patsearch_results.patentnr);
assert( P == length(nb_post.post_yes) )

fprintf('NB posteriors look fine so far: %d.\n', ix_year)


%% Classify patents based on the posterior probabilities
is_nbAutomat = +( nb_post.post_yes > nb_post.post_no );


patsearch_results.is_nbAutomat = is_nbAutomat;

save('comp_2001/patsearch_results_2001_comp.mat', 'patsearch_results');














