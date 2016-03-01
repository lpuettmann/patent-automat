function post = calc_post_nb(prior, cond_prob, indic_appear)
% Calculate the log posterior from the prior and the conditional
% probabilities. See Manning, Raghavan, Schuetze (2008) chapter 13.
% 
% IN:
%       - prior: a probability between 0 and 1.
%       - cond_prob: a vector (n times 1) of conditional probabilities.
%       - indic_appear: a vector (n times 1) with 1 showing that this token
%       appears in the document and 0 meaning this token does not appear in
%       the document.

assert( length(cond_prob) == length( indic_appear ) )

cp_inDoc = cond_prob( indic_appear );

% The Bernoulli model for the Naive Bayes classifier penalizes for tokens
% that do NOT appear in the document.
penalty = 1 - cond_prob( not( indic_appear ) );

assert( (length(cp_inDoc) + length(penalty)) == length(indic_appear) )

% Calculate posterior probability for the document to belong to this class
post = log( prior ) + sum( log( cp_inDoc ) ) + sum( log( penalty ) );
