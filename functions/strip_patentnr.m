function patent_number_cleaned = strip_patentnr(patentnr, ix_year, opt2001)
% Delete first (and last [for some]) letter of patent numbers

patent_number_cleaned =  repmat({''}, size(patentnr, ...
    1), 1);

for ix_patent = 1:size(patentnr, 1)

    extract_row = patentnr{ix_patent};

    if (ix_year >= 2002) || ((ix_year == 2001) && strcmp(opt2001, 'xml'))
        trunc_row = extract_row(2:end); % delete first letter only
    elseif ix_year <= 2000 || ((ix_year == 2001) && strcmp(opt2001, 'txt'))
        trunc_row = extract_row(2:end-1); %  delete first and last letter
    else
        error('Should not reach this.')
    end

    patent_number_cleaned{ix_patent} = trunc_row;
end
