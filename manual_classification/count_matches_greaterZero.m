function ix_classif = count_matches_greaterZero(matches, ix_keyword)

ix_classif = ( matches(:, ix_keyword) >= 1 );
ix_classif = +ix_classif; % logical to double (vector)
