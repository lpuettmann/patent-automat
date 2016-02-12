function patextr = extract_tokens_patparts(patextr, stop_words, ...
    indicStemmer)

for ix_patent = 1:length(patextr.patentnr)
     
    % Extract tokens for title
    inStr = patextr.title_str{ix_patent};
    tokens = tokenize_string(inStr, indicStemmer, stop_words);
    patextr.title_tokens{ix_patent, 1} = tokens;
    
    % Extract tokens for abstract
    inStr = patextr.abstract_str{ix_patent};    
    inStr = strjoin(inStr');    
    tokens = tokenize_string(inStr, indicStemmer, stop_words);
    patextr.abstract_tokens{ix_patent, 1} = tokens;  
    
    % Extract tokens for text body
    inStr = patextr.body_str{ix_patent};    
    inStr = strjoin(inStr');    
    tokens = tokenize_string(inStr, indicStemmer, stop_words);
    patextr.body_tokens{ix_patent, 1} = tokens; 
    
    fprintf('Finished tokenizing patent %d/%d.\n', ix_patent, ...
        length(patextr.patentnr))
end
