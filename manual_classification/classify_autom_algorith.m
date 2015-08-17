function computerClass = classify_autom_algorith(automclassData)

    total_matches = automclassData.title_matches + ...
        automclassData.abstract_matches + automclassData.body_matches;
   
    compAutomat = [];
    algorithm_name = {'deleteMe'};
    
    % Classify as automation patents if they have at least one keyword
    % match
    for ix_keyword=1:length( automclassData.dictionary )
        compAutomat = [compAutomat, count_matches_greaterZero( ...
            total_matches, ix_keyword)];
        name_pick = [automclassData.dictionary{ix_keyword}, '$_{t+a+b}$'];
        algorithm_name = [algorithm_name, name_pick];
    end

    
    % (Anwhere:) "automat" OR "robot" OR "movable arm" OR "autonomous" OR 
    % "adaptive" OR "self-generat" OR (in title + abstract) "detect" 
    % OR "program" OR "computer"
    anwhere_words = {'automat', 'robot', 'movable arm', 'autonomous', ...
        'adaptive', 'self-generat'};  
    mat_classif_1 = multiple_class(automclassData.dictionary, total_matches, anwhere_words);
    
    titleabstract_words = {'detect', 'program', 'computer'};
    mat_classif_2 = multiple_class(automclassData.dictionary, ...
        automclassData.title_matches + automclassData.abstract_matches, ...
        titleabstract_words);
    
    % Pick those words that contain any of those
    max([mat_classif_1, mat_classif_2], [], 2) % CONTINUE HERE !!!!!!!!!!!!!!
    
    
    % Bessen-Hunt classification of software patents
    bh_software_patents = bessen_hunt(automclassData, 1);
    compAutomat = [compAutomat, bh_software_patents];
    algorithm_name = [algorithm_name, 'Bessen-Hunt'];

    
    % "Guessing" algorithms
    always_No = zeros(size(automclassData.title_matches, 1), 1);
    always_Yes = ones(size(automclassData.title_matches, 1), 1);
    compAutomat = [compAutomat, always_No, always_Yes];
    algorithm_name = [algorithm_name, 'Always "No"', 'Always "Yes"'];

    
    algorithm_name = algorithm_name(2:end);
    
    % Save in structure
    computerClass.compAutomat = compAutomat;
    computerClass.algorithm_name = algorithm_name;
end
    

function ix_classif = count_matches_greaterZero(matches, ...
    ix_keyword)
    
    ix_classif = ( matches(:, ix_keyword) >= 1 );
    ix_classif = +ix_classif; % logical to double (vector)
end


function mat_classif = multiple_class(searchdict, matches, choose_dict)
    for i=1:length(choose_dict)
        pick_word = choose_dict{i};
        ix_pos = find_word_in_dict(searchdict, pick_word);    
        mat_classif(:, i) = count_matches_greaterZero(matches, ...
            ix_pos);
    end
end


function bh_software_patents = bessen_hunt(automclassData, indic_spec)
% Implement the classification algorithm of:
%   Bessen, James and Robert Hunt (2007). "An Empirical Look at 
%   Software Patents". Journal of Economics and Management Strategy, 
%   16(1): 1578–189.
    
    % Search for these words on what Bessen and Hunt call the patent
    % "specification". 
    searchdict_spec = {'software', 'computer', 'program', 'antigen', ...
        'antigenic', 'chromatography'};
    
    searchdict_title = {'chip', 'semiconductor', 'bus', 'circuit', ...
        'circuitry'};

    % Count matches in "specification"
    for i=1:length(searchdict_spec)
        pick_word = searchdict_spec{i};
        ix_pos = find_word_in_dict(automclassData.dictionary, pick_word);
        
        if indic_spec == 1
            spec_matches = automclassData.body_matches;
        elseif indic_spec == 2
            spec_matches = automclassData.abstract_matches + ...
                automclassData.body_matches;
        else
            warning('''indic_spec'' not well-specified.')
        end
        
        spec_results(:, i) = count_matches_greaterZero(spec_matches, ...
            ix_pos);
    end
    
    % Count matches in title
    for i=1:length(searchdict_title)
        pick_word = searchdict_title{i};
        ix_pos = find_word_in_dict(automclassData.dictionary, pick_word);       
        title_results(:, i) = count_matches_greaterZero( ...
            automclassData.title_matches, ix_pos);
    end
        
    exclusion_patents = [title_results, spec_results(:, end-2:end)];
    exclude_if_any = max(exclusion_patents, [], 2);
    
    % Include if "computer" and "program"
    computer_program = spec_results(:, 2) & spec_results(:, 3);
    
    % Either "software" or "computer_program"
    software_patents = spec_results(:, 1) | computer_program;
    
    % Exclude some
    bh_software_patents = software_patents & not( exclude_if_any );    
    bh_software_patents = + bh_software_patents; % logical to vector
end


function ix_pos = find_word_in_dict(dict, word)
   
    ix_pos = find( strcmp(dict, word) );
    
end
