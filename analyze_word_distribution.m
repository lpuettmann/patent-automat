
clc
clear all
close all

tic

addpath('matches');
addpath('functions');

%%
year_start = 1989;
year_end = 1989;


%%

for ix_year = year_start:year_end

    % Load matches
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)
    
    
    word_matches_list = patent_keyword_appear(:, 5);

    word_matches_list = word_matches_list(~cellfun('isempty', ...
        word_matches_list));
    
    word_matches_list = make_cellarray_flat(word_matches_list);
    
    
%     ix_punct_marks = regexp(word_matches_list, ',')
%     AA = delete_empty_cells(ix_punct_marks)


    find_str = {{'automatically', 'automatically,', 'automatically.'};
                {'automatic', 'automatic,', 'automatic.'};
                {'automated', 'automated,', 'automated.'};
                {'automation', 'automation,', 'automation.'};
                {'automate'};
                {'Automation),'};
                {'automat', 'automat,', 'automat.'};
                {'automatable', 'automatable,', 'automatable.'};
                {'automaton'};
                {'(ATF=automatic'};
                {'automated-sequencing,'};
                {'automatically-operating'};
                {'"automatic."', '"automatic"', '"automatic', 'automatic"'};
                {'automatice'};
                {'fully-automatable', 'full-automat', 'fully-automatic', 'fully-automatic,', 'fully-automatic.'};
                {'Neutral/Automatic'};
                {'automatic-'};
                {'Automatically?"):'};
                {'non-automatic'};
                {'(automatic'};
                {'automatically).'};
                {'automatic/manual'};
                {'automatic-threading', 'automatic-air-ventilation'};
                {'semiautomatic', 'semi-automatable', 'semi-automat', 'semi-automatic', 'semi-automatically'}
                {'Kopierautomat'};};
            
    % Check that there are no equal terms in the list
     long_find_str = sort(make_cellarray_flat(find_str));
     if length(long_find_str) ~= length(unique(long_find_str))
         warning('There are duplicates in cell array and this causes double counts.')
     end   

    
    for ix_find_str=1:size(find_str, 1)
        line_find_str = find_str{ix_find_str, :};
        
        for w=1:length(line_find_str)
            pick_find_str = line_find_str(w);
            ix_count_phrase(:,w) = strcmpi(word_matches_list, pick_find_str);
        end
        
        ix_count_phrase = cumsum(double(ix_count_phrase), 2);
        ix_count_phrase = ix_count_phrase(:, end);

        word_match_distr{ix_find_str, 1} = line_find_str;
        word_match_distr{ix_find_str, 2} = sum(ix_count_phrase);
    end
    
    sum_keyword_find = sum(cell2mat(patent_keyword_appear(:, 2)));
    
    if not(length(word_matches_list)==sum_keyword_find)
        warning('Should be equal.')
    end

    
    rest_matches = sum_keyword_find - ...
        sum(cell2mat(word_match_distr(:, 2)));
    
    fprintf('Matches not assigned to full words: %d (%3.2f percent).\n', ...
        rest_matches, rest_matches / sum_keyword_find*100)

    % delete ix_count_phrase
    clear ix_count_phrase 
end





fprintf('Finished, time = %ds.\n', round(toc))
