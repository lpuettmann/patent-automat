function check_plausible_nb_post(year_start, year_end)
% Check plausibility of Naive Bayes posterior probabilities. This throws an
% error if something is wrong.

for ix_year=year_start:year_end;
    
    load_name = horzcat('nb_post_', num2str(ix_year), '.mat');
    load(load_name)
    
    assert( all( nb_post.post_yes < 0 ) )
    assert( all( nb_post.post_no < 0 ) )
    
    assert( not( any( isnan(nb_post.post_yes) ) ) )
    assert( not( any( isnan(nb_post.post_no) ) ) )
    
    assert( length( nb_post.post_yes ) == length( nb_post.post_no ) )
    
    % Check if same number of posteriors as patents
    load(['patsearch_results_', num2str(ix_year), '.mat']);
    P = length(patsearch_results.patentnr);
    assert( P == length(nb_post.post_yes) )
    
    fprintf('NB posteriors look fine so far: %d.\n', ix_year)
end
