function check_fdate_formatting(fdate_extract, patent_number, ix_patent)   

if ~(numel(fdate_extract)==6)
    fprintf('Filing date format (%s) [patent: %s] should be 6 characters long.\n', ...
        fdate_extract, patent_number{ix_patent})
elseif ~(isempty(strfind(fdate_extract, ' ')))
    fprintf('Filing dates (%s) [patent: %s] should not contain space.\n', ...
        fdate_extract, patent_number{ix_patent})
elseif isempty(intersect((1790:2015), str2double(fdate_extract(1:4)))) || ...
        isempty(intersect((1:12), str2double(fdate_extract(5:6))))
    fprintf('Filing date format (%s) [patent: %s] does not look like a proper date (or filing date is implausibly early).\n', ...
        fdate_extract, patent_number{ix_patent})
end

