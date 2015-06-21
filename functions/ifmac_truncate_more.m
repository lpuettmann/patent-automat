function filenames = ifmac_truncate_more(filenames)

% on Mac computer: truncate also '.DS_Store'
if ismac
    filenames = filenames(2:end);
end