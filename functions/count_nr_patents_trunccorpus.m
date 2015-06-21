function [indic_find, nr_patents, ix_find] = ...
    count_nr_patents_trunccorpus(search_corpus, 'PATN', nr_trunc)

search_corpus_trunc = search_corpus;

for i=1:length(search_corpus_trunc)
    if numel(search_corpus_trunc{i}) > nr_trunc
        row_shorten = search_corpus_trunc{i};
        search_corpus_trunc{i} = row_shorten(1:nr_trunc);
    end
end
[indic_find, nr_patents, ix_find] = count_nr_patents(...
    search_corpus_trunc, 'PATN');