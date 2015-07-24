function patent_text_corpus = get_patent_text_corpus(ix_find, ix_patent, ...
    nr_patents, ftset, search_corpus)

start_text_corpus = ix_find(ix_patent);

if ix_patent < nr_patents
    end_text_corpus = ix_find(ix_patent+1) - ...
        ftset.nr_lines4previouspatent;
else
    end_text_corpus = length(search_corpus);
end

patent_text_corpus = search_corpus(...
    start_text_corpus:end_text_corpus, :);
