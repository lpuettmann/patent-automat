function filenames = ifmac_truncate_more(filenames)

% on Apple computer: truncate also '.DS_Store'
if ismac
    disp('Great, you are working on a mac.')
    filenames = filenames(2:end);
end