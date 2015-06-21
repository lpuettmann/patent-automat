function match_fullword = get_fullword_matches(nr_keyword_find, ...
    check_keyword_find, patent_text_corpus, line_hit_keyword_find) 

% Get the line index of where the match is
ix_keyword_find = find(not(cellfun(@isempty, check_keyword_find)));

% Pre-define a cell array that will hold all the words delineated by space
% on either side (or line start/end)
match_fullword = repmat({''}, 1, nr_keyword_find);

% Initialize index to save the words of the matches
save_ix = 1; 


if nr_keyword_find > 0
    for ix_lines=1:length(ix_keyword_find)

        % Get the text for the line where one or more matches
        % occured
        line_text = patent_text_corpus{ix_keyword_find(ix_lines), :};

        % Get information where on the line the match(es)
        % occured
        line_hit_position = line_hit_keyword_find{ix_lines};

        % Find spaces on the line
        line_space_ix = regexp(line_text, ' ');

        for ix_linematches = 1:length(line_hit_keyword_find{ix_lines})
            ix_line_position = line_hit_position(ix_linematches);

            match_fullword_start = max(line_space_ix(line_space_ix < ix_line_position)) + 1;
            if isempty(match_fullword_start) % if match is the first word
                match_fullword_start = 1;
            end

            match_fullword_end = min(line_space_ix(line_space_ix > ix_line_position)) - 1;
            if isempty(match_fullword_end) % if match is the last word
                match_fullword_end = length(line_text);
            end

            match_fullword{save_ix} = line_text(match_fullword_start:match_fullword_end);  

            save_ix = save_ix + 1;
        end
    end
end
