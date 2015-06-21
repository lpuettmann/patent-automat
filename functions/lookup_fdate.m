function fdate = lookup_fdate(search_corpus)

find_fdate_str = '<B220><DATE><PDAT>';
indic_fdate_find = regexp(search_corpus, find_fdate_str);
indic_fdate_find = ~cellfun(@isempty, indic_fdate_find);
ix_fdate_find = find(indic_fdate_find);

fdate = repmat({''}, length(ix_fdate_find), 1);

for i=1:length(ix_fdate_find)
    fdate_line = search_corpus(ix_fdate_find(i), :);
    fdate_line = fdate_line{1};
    fdate_extract = fdate_line(19:24);
    check_fdate_formatting(fdate_extract)   
    fdate{i} = fdate_extract;
end


