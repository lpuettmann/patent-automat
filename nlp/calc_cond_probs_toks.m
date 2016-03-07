function tstats = calc_cond_probs_toks( ...
    feat_incidMat, find_dictionary, manAutomat, featTok)
% Compile some statistics on the chosen tokens.

feat_occurMat = +( feat_incidMat > 0 );
tstats.cond_prob_yes = NaN(length(find_dictionary), 1);
tstats.cond_prob_no = NaN(length(find_dictionary), 1);
tstats.nr_appear = NaN(length(find_dictionary), 1);
tstats.mutual_information = NaN(length(find_dictionary), 1);

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
    tstats.cond_prob_yes(t) = classifstat.cond_prob_yes;
    tstats.cond_prob_no(t) = classifstat.cond_prob_no;
    tstats.nr_appear(t) = classifstat.true_positive + ...
        classifstat.false_positive;
    tstats.mutual_information(t) = classifstat.mutual_information;
end

%% Make some checks
assert( isreal( tstats.cond_prob_yes ) )
assert( isreal( tstats.cond_prob_no ) )
assert( all( tstats.cond_prob_yes >= 0 ) )
assert( all( tstats.cond_prob_no >= 0 ) )
assert( all( tstats.cond_prob_yes <= 1 ) )
assert( all( tstats.cond_prob_no <= 1 ) )
assert( all( tstats.nr_appear >= 0 ) )
