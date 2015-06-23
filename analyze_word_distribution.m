clc
clear all
close all



%%
year_start = 1976;
year_end = 2015;


%%
tic

for ix_year = year_start:year_end

    ix_iter = ix_year - year_start + 1;
    
    % Load matches
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)
    
    
    word_matches_list = patent_keyword_appear(:, 5);

    word_matches_list = word_matches_list(~cellfun('isempty', ...
        word_matches_list));
    
    word_matches_list = make_cellarray_flat(word_matches_list);
    

    find_str = {'automatic';
                'automatically';
                'automated';
                'automation';
                'automate';
                'automat';
                'automatable';
                'automaton';
                'automatice';
                'non-automatic';
                'nonautomatic';
                'unautomated';
                'non-automated';
                'automatization';
                'automating';
                'automaticity';
                'automata';
                'automatiche';
                'd''Automatisme';
                'automatical';
                'automaticen';
                'automative';
                'automati';
                'automatics';
                'automatica';
                'automatism';
                'automatisms';
                'automatizacie';
                'automatique';
                'automatisch';
                'hybrid-automatic';
                'automatik';
                'automatic-closing';
                'quasi-automated';
                'automatisk';
                'automatos';
                'automatistic';
                'programmatic/automatic';
                'automatic/programmatic';
                'automatially';
                'automatedly';
                'automatically-controlled';
                'automatic-release';
                'automatic-feeding';
                'automatic-stop/restart';
                'automatically-generated';
                'automaticaly';
                'automates';
                'normal-automatic';
                'under-automatic-stop';
                'automats';
                'anonymous-automatic';
                'automatized';
                'automatic-transmission';
                'automata-based';
                'automatove';
                'computer-automated';
                'hardware-automated';
                'automaticaaly';
                'automatech';
                'Automatisierter';
                'automations';
                'un-automated';
                'local-automatic-order-taking';
                '(ATF=automatic';
                'automation-related';
                'automated-sequencing,';
                'automatic/mechanical';
                'automatically-operating';
                'neutral/automatic';
                'automatched';
                'build-automation';
                'automatch';
                'automata''s';
                'wholly-automated';
                'appropriately-automated';
                'automatic/manual';
                'automatic-threading';
                'automatic-air-ventilation';
                'Automatisierungstechnik';
                'kopierautomat'};

    % Check that there are no equal terms in the list
     if length(find_str) ~= length(unique(find_str))
         warning('There are duplicates in cell array and this causes double counts.')
     end   
     
    % Extend strings by common attachments
    for ix_find_str=1:length(find_str)
        str = find_str{ix_find_str, :};
        
        line_find_str = {str, [str, ',']};
        line_find_str = {line_find_str{:}, [str, '.']};
        line_find_str = {line_find_str{:}, [str, ';']};
        line_find_str = {line_find_str{:}, ['semi-', str]};
        line_find_str = {line_find_str{:}, ['semi', str]};
        line_find_str = {line_find_str{:}, ['full-', str]};
        line_find_str = {line_find_str{:}, ['full', str]};
        line_find_str = {line_find_str{:}, ['(', str]};
        line_find_str = {line_find_str{:}, [str, ')']};
        line_find_str = {line_find_str{:}, [str, ').']};
        line_find_str = {line_find_str{:}, [str, ')"']};
        line_find_str = {line_find_str{:}, [str, '?"']};
        line_find_str = {line_find_str{:}, [str, '/']};
        line_find_str = {line_find_str{:}, ['"', str, '"']};
        line_find_str = {line_find_str{:}, ['(', str, ')']};
        line_find_str = {line_find_str{:}, ['"', str]};
        line_find_str = {line_find_str{:}, [str, '"']};
        line_find_str = {line_find_str{:}, [str, '-']};
        
        find_str_extend{ix_find_str, :} = line_find_str;
    end
           
     % Check that there are no equal terms in the list
     long_find_str = sort(make_cellarray_flat(find_str_extend));
     if length(long_find_str) ~= length(unique(long_find_str))
         warning('There are duplicates in cell array and this causes double counts.')
     end   

    covered_words = 0; % initialize
    
    for ix_find_str=1:size(find_str_extend, 1)
        line_find_str = find_str_extend{ix_find_str, :};
        
        for w=1:length(line_find_str)
            pick_find_str = line_find_str(w);
            ix_count_phrase(:,w) = strcmpi(word_matches_list, pick_find_str);
        end
        
        ix_count_phrase = cumsum(double(ix_count_phrase), 2);
        ix_count_phrase = ix_count_phrase(:, end);

        word_match_distr{ix_find_str, 1, ix_iter} = line_find_str;
        word_match_distr{ix_find_str, 2, ix_iter} = sum(ix_count_phrase);
        
        covered_words = [covered_words;
                        find(ix_count_phrase)];
    end
    
    covered_words(1) = [];
    if length(covered_words) ~= length(unique(covered_words))
        warning('There should be no duplicates here.')
    end   
    
    % Find those words we have not yet assigned to a match
    matches_notassigned{ix_iter} = word_matches_list(setdiff(...
        1:length(word_matches_list), covered_words));

    
    sum_keyword_find = sum(cell2mat(patent_keyword_appear(:, 2)));
    
    if not(length(word_matches_list)==sum_keyword_find)
        warning('Should be equal.')
    end

    
    rest_matches(ix_iter) = sum_keyword_find - ...
        sum(cell2mat(word_match_distr(:, 2, ix_iter)));
    
    if rest_matches(ix_iter) < 0
        warning('Assigned more words that there are matches.')
    end
    
    fprintf('Year %d: Matches not assigned to full words: %d (%3.2f percent).\n', ...
        ix_year, rest_matches(ix_iter), rest_matches(ix_iter) / sum_keyword_find*100)

    % delete ix_count_phrase
    clear ix_count_phrase 
end

toc

% Save to .mat file
% -------------------------------------------------------------------
save_name = horzcat('word_match_distr_', num2str(year_start), '-', ...
    num2str(year_end), '.mat');
save(save_name, 'word_match_distr', 'rest_matches', 'matches_notassigned');    
fprintf('Saved: %s.\n', save_name)




