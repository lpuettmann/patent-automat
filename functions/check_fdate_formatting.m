function check_fdate_formatting(fdate_extract)

if ~(numel(fdate_extract)==6)
    disp('Should be 6 characters long.')
elseif ~(isempty(strfind(fdate_extract, ' ')))
    disp('Filing dates should not contain space.')
elseif isempty(intersect((1950:2015), str2double(fdate_extract(1:4)))) || ...
        isempty(intersect((1:12), str2double(fdate_extract(5:6))))
    fprintf('Filing date format (%s) does not look like a proper date (or filing date is implausibly early).\n', fdate_extract)
end

