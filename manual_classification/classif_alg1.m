function class_pat = classif_alg1(searchdict, title_matches, ...
    abstract_matches, body_matches)
    % Apply Algorithm1 to classify patents as automation patents
    %
    % (Anwhere:) "automat" OR "robot" OR "movable arm" OR "autonomous" OR 
    % "adaptive" OR "self-generat" OR (in title + abstract) "detect" 
    % OR "program" OR "computer"
    
    anwhere_words = {'automat', 'robot', 'movabl', 'autonom', ...
        'adapt', 'self-generat'};  
    total_matches = title_matches + abstract_matches + body_matches;    
    mat_classif_1 = multiple_class(searchdict, total_matches, ...
        anwhere_words);

    titleabstract_words = {'detect', 'program', 'comput'};
    title_abstract_matches = title_matches + abstract_matches;
    mat_classif_2 = multiple_class(searchdict, title_abstract_matches, ...
        titleabstract_words);

    % Pick those words that contain any of those
    class_pat = max([mat_classif_1, mat_classif_2], [], 2);
    
    % From sparse to full matrix
    class_pat = full( class_pat );
end


function mat_classif = multiple_class(searchdict, matches, choose_dict)
    for i=1:length(choose_dict)
        pick_word = choose_dict{i};
        ix_pos = find( strcmp(searchdict, pick_word) );    
        select_matches = matches(:, ix_pos);
        indic_match = ( select_matches >= 1 );
        mat_classif(:, i) = +indic_match; % logical to double (vector) 
    end
end

