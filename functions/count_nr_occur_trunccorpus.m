function indic_find = count_nr_occur_trunccorpus(corpus, searchphrase, ...
    nr_trunc)

corpus_trunc = corpus;

for i=1:length(corpus_trunc)
    if numel(corpus_trunc{i}) > nr_trunc
        row_shorten = corpus_trunc{i};
        corpus_trunc{i} = row_shorten(1:nr_trunc);
    end
end

if numel(searchphrase) < 1
    warning('Implausibly short.')
end

indic_find = strcmp(corpus_trunc, searchphrase);
