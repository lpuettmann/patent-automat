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
        name_pick = automclassData.dictionary{ix_keyword};
        algorithm_name = [algorithm_name, name_pick];
    end

    
    % Use Algorithm1
   class_pat = classif_alg1(automclassData.dictionary, automclassData.title_matches, ...
       automclassData.abstract_matches, automclassData.body_matches, ...
       automclassData.indic_exclclassnr);
    compAutomat = [compAutomat, class_pat];
    algorithm_name = [algorithm_name, 'Algorithm1'];
    
    % Bessen-Hunt classification of software patents
    %   Choose a specification (indic_spec):
    %       1: body only
    %       2: abstract + body
    %       3: title + abstract + body
    indic_spec = 3;
    bh_software_patents = bessen_hunt(automclassData, indic_spec);
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
