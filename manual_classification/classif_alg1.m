function class_pat = classif_alg1(searchdict, title_matches, ...
    abstract_matches, body_matches)
    % Apply Algorithm1 to classify patents as automation patents
    %
    % (Anwhere:) "automat" OR "robot" OR "movable arm" OR "autonomous" OR 
    % "adaptive" OR "self-generat" OR (in title + abstract) "detect" 
    % OR "program" OR "computer"
    
    anwhere_words = {'automat', 'robot', 'movable arm', 'autonomous', ...
        'adaptive', 'self-generat'};  
    total_matches = title_matches + abstract_matches + body_matches;    
    mat_classif_1 = multiple_class(searchdict, total_matches, ...
        anwhere_words);

    titleabstract_words = {'detect', 'program', 'computer'};
    title_abstract_matches = title_matches + abstract_matches;
    mat_classif_2 = multiple_class(searchdict, title_abstract_matches, ...
        titleabstract_words);

    % Pick those words that contain any of those
    class_pat = max([mat_classif_1, mat_classif_2], [], 2);

end


function mat_classif = multiple_class(searchdict, matches, choose_dict)
    for i=1:length(choose_dict)
        pick_word = choose_dict{i};
        ix_pos = find( strcmp(searchdict, pick_word) );    
        mat_classif(:, i) = count_matches_greaterZero(matches, ix_pos);        
    end
end
