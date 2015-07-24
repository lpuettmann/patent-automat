function indic_find = count_nr_occur_trunccorpus(corpus, searchdict)

for i=1:length(searchdict)
    searchphrase = searchdict{i};
    nr_trunc = numel(searchphrase);

    corpus_trunc = corpus;
    for j=1:length(corpus_trunc)
        if numel(corpus_trunc{j}) > nr_trunc
            row_shorten = corpus_trunc{j};
            corpus_trunc{j} = row_shorten(1:nr_trunc);
        end
    end

    indic_findMat(:, i) = strcmp(corpus_trunc, searchphrase);
end

indic_findMat = +indic_findMat; % logical to matrix
indic_find = max(indic_findMat, [], 2);
indic_find = logical(indic_find); % matrix back to logical
