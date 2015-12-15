function tok_stats = collect_tok_stats(patextr)


%% Count unique tokens

for i=1:3

    if i == 1
        inNestedCellArray = patextr.title_tokens;
    elseif i == 2
        inNestedCellArray = patextr.abstract_tokens;
    elseif i == 3
        inNestedCellArray = patextr.body_tokens;
    else
        error('Don''t go here.')
    end

    % Concatenate
    all_tok = [];

    for k=1:length(inNestedCellArray)
        all_tok = [all_tok;
                   inNestedCellArray{k}];
    end

    unique_tok = unique( all_tok );

    tok_stats.nr_allTok(i,1) = length(all_tok);
    tok_stats.nr_uniqueTok(i,1) = length(unique_tok);
end


%% 
for j=1:length(patextr.title_tokens)
    tok_stats.nr_titleTok(j, 1) = length(patextr.title_tokens{j});
    tok_stats.nr_abstractTok(j, 1) = length(patextr.abstract_tokens{j});
    tok_stats.nr_bodyTok(j, 1) = length(patextr.body_tokens{j});
end
