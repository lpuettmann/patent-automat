% Check out some of the results for a specific patent:
%   Title: "Automatic Taco Machine"
%   Patent: 5531156
%   Year granted: 1996

% Set paths to all underlying directories
setup_path()

load('cleaned_matches/patsearch_results_1996.mat')

% Automatic taco machine
atm = find( strcmp(patsearch_results.patentnr, '5531156') );

tm = find( full ( patsearch_results.title_matches(atm, :) ) );
am = find( full ( patsearch_results.abstract_matches(atm, :) ) );
bm = find( full ( patsearch_results.body_matches(atm, :) ) );


patsearch_results.dictionary(tm)


patsearch_results.dictionary(am)
patsearch_results.dictionary(bm)


load('patextr')

cond_prob_yes = [patextr.title_cond_prob_yes; ...
    patextr.abstract_cond_prob_yes; patextr.body_cond_prob_yes];
cond_prob_no = [patextr.title_cond_prob_no; ...
    patextr.abstract_cond_prob_no; patextr.body_cond_prob_no];
prior_yes = patextr.prior_automat;
prior_no = patextr.prior_notautomat;

patMatches = [patsearch_results.title_matches(atm, :), ...
            patsearch_results.abstract_matches(atm, :), ...
            patsearch_results.body_matches(atm, :)];
patOccur = +(patMatches > 0)'; % logical to double
indic_appear = logical( full( patOccur ) );

cp_inDoc = cond_prob_yes( indic_appear )
cp_inDoc = cond_prob_no( indic_appear )

post_yes = calc_post_nb(prior_yes, cond_prob_yes, indic_appear)
post_no = calc_post_nb(prior_no, cond_prob_no, indic_appear)

% Bernoulli Naive Bayes

cp_inDoc = cond_prob( indic_appear );

% The Bernoulli model for the Naive Bayes classifier penalizes for tokens
% that do NOT appear in the document.
penalty = 1 - cond_prob( not( indic_appear ) );

assert( (length(cp_inDoc) + length(penalty)) == length(indic_appear) )

% Calculate posterior probability for the document to belong to this class
post = log( prior ) + sum( log( cp_inDoc ) ) + sum( log( penalty ) );

% Check if same as in files
load('nb_post_1996.mat') 

nb_post.post_yes(atm)
nb_post.post_no(atm)


