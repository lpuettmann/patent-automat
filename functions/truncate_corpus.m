function corpus_trunc = truncate_corpus(corpus, nr_trunc)

corpus_trunc = corpus;

for i=1:length(corpus_trunc)
    if numel(corpus_trunc{i}) > nr_trunc
        row_shorten = corpus_trunc{i};
        corpus_trunc{i} = row_shorten(1:nr_trunc);
    end
end
