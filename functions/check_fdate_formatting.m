function check_fdate_formatting(fdate_extract)

if ~(numel(fdate_extract)==6)
    disp('Should be 6 characters long.')
elseif ~(isempty(strfind(fdate_extract, ' ')))
    disp('Filing dates should not contain space.')
end
