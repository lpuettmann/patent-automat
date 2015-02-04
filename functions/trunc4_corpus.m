search_corpus_trunc4 = search_corpus;

for i=1:length(search_corpus_trunc4)
    if numel(search_corpus_trunc4{i}) > 4
        row_shorten = search_corpus_trunc4{i};
        search_corpus_trunc4{i} = row_shorten(1:4);
    end
end
[indic_find, nr_patents, ix_find] = count_nr_patents(...
    search_corpus_trunc4, 'PATN');