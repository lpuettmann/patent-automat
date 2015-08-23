function check_filestart_dot(filenames)

file_beginning = cellfun(@(x) x(1:3), filenames, 'UniformOutput', false);

if any( strcmp(file_beginning, '.') )
    warning('One of the files starts with ''.''.')
elseif any( strcmp(file_beginning, '..') )
    warning('One of the files starts with ''..''.')
elseif any( strcmp(file_beginning, '.DS') )
    warning('There is probably still a ''.DS_Store'' among the files.')
end

file_start = cellfun(@(x) x(1), filenames, 'UniformOutput', false);

if any( strcmp(file_start, '.') )
    warning('One of the files starts with ''.''.')
end
