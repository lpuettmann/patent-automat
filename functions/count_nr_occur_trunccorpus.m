function indic_find = count_nr_occur_trunccorpus(corpus, searchdict)

for i=1:length(searchdict)
    
    searchphrase = searchdict{i};
   
    nr_trunc = numel(searchphrase);
    
    corpus_trunc = truncate_corpus(corpus, nr_trunc);

    indic_findMat(:, i) = strcmp(corpus_trunc, searchphrase);
end

indic_findMat = +indic_findMat; % logical to matrix
indic_find = max(indic_findMat, [], 2);
indic_find = logical(indic_find); % matrix back to logical
