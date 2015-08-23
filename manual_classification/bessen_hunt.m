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
    ix_pos = find( strcmp(automclassData.dictionary, pick_word) );

    if indic_spec == 1
        spec_matches = automclassData.body_matches;
    elseif indic_spec == 2
        spec_matches = automclassData.abstract_matches + ...
            automclassData.body_matches;
    elseif indic_spec == 3
        spec_matches = automclassData.title_matches + ...
            automclassData.abstract_matches + ...
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
    ix_pos = find( strcmp(automclassData.dictionary, pick_word) );       
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
