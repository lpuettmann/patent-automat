function display_matches_text(search_corpus, ix_find, nr_find, ...
    explore_ix_found, show_char, nr_show_matches, match_disp_choice)
%{
    Display some of the matches that were found in the text corpus. Choose
    between displaying the matches starting at some chosen index or 
    randomly showing matches.      
    %}

switch match_disp_choice
    
    case 1
    % Display some matches starting from a chosen position
    % -----------------------------------------------------------------------
    for ix_found_pos = explore_ix_found:explore_ix_found+nr_show_matches
        choose_ix = ix_found_pos;
        search_corpus(ix_find(choose_ix)-show_char:ix_find(choose_ix) ... 
            + show_char)
        disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    end

    case 2
    % Do a random search through our hits
    % -----------------------------------------------------------------------
    for ix_scrap = 1:nr_show_matches
        choose_ix = randsample(nr_find,1)
        search_corpus(ix_find(choose_ix)-show_char:ix_find(choose_ix) ...
            + show_char)
        disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    end
end
