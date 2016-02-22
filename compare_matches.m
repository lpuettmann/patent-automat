function compare_matches(year_start, year_end)

disp('Compare new keyword searches with old ...')
disp(' ')

for ix_year = year_start:year_end
    
    load(['patsearch_results_', num2str(ix_year), '.mat'])
    search_new = patsearch_results;

    load(['old_patsearch_results_', num2str(ix_year), '.mat'])


    old = patsearch_results.patentnr;
    new = search_new.patentnr;

    assert( length(old) == length(new) )
    assert( all( strcmp(old, new) ) )
    disp('Patent numbers fine.')

    old = patsearch_results.length_pattext;
    new = search_new.length_pattext;

    assert( length(old) == length(new) )
    assert( all( old == new ) )
    disp('Length of patent texts fine.')


    %%

    overlap_dict = intersect(search_new.dictionary, ...
        patsearch_results.dictionary);

    for i=1:length(overlap_dict)
        pickTok = overlap_dict{i};
        ix_old = find( strcmp(patsearch_results.dictionary, pickTok) );

        if length(ix_old) > 1
            ix_old = ix_old(1);
            fprintf('More than one occurence of token %s.\n', pickTok)
        end

        ix_new = find( strcmp(search_new.dictionary, pickTok) );

        old_hits = patsearch_results.title_matches(:, ix_old);
        new_hits = full(search_new.title_matches(:, ix_new));

        try
            assert( sum(old_hits) == sum(new_hits) ), ...
                assert( all( old_hits == new_hits ) )
        catch
            fprintf('Error in token: %s.\n', pickTok) 
            break
        end
    end
    disp('Keyword matches are the same as in previous search.')
    
    fprintf('<strong>Year finished: %d.</strong>\n', ix_year)
    disp('_________________________________________________')
end
