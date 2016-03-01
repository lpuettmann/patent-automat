function [cond_prob_yes, cond_prob_no] = calc_cond_probs_toks( ...
    feat_incidMat, find_dictionary, manAutomat, featTok)

feat_occurMat = +( feat_incidMat > 0 );
cond_prob_yes = NaN(length(find_dictionary), 1);
cond_prob_no = NaN(length(find_dictionary), 1);

for t=1:length(find_dictionary)
    pickTok = find_dictionary{t};
    
    j = find( strcmp(featTok, pickTok) );
    
    if isempty( j )
        singleTok_class = zeros(length(manAutomat), 1);
    else  
        singleTok_class = feat_occurMat(:, j);
        singleTok_class = full( singleTok_class );
    end
        
    classifstat = calculate_manclass_stats(manAutomat, singleTok_class);
    cond_prob_yes(t) = classifstat.cond_prob_yes;
    cond_prob_no(t) = classifstat.cond_prob_no;
end

%% Make some checks
assert( isreal( cond_prob_yes ) )
assert( isreal( cond_prob_no ) )
assert( all( cond_prob_yes >= 0 ) )
assert( all( cond_prob_no >= 0 ) )
assert( all( cond_prob_yes <= 1 ) )
assert( all( cond_prob_no <= 1 ) )
