function patent_number_cleaned = strip_patentnr(patentnr, ix_year)
% Delete first (and last [for some]) letter of patent numbers

patent_number_cleaned =  repmat({''}, size(patentnr, ...
    1), 1);
for ix_patent = 1:size(patentnr, 1)

    extract_row = patentnr{ix_patent};

    if ix_year >= 2002 % after (not incl.) 2001: delete first letter only
        trunc_row = extract_row(2:end);
    else % before 2001: delete first and last letter
        trunc_row = extract_row(2:end-1);
    end

    patent_number_cleaned{ix_patent} = trunc_row;
end
