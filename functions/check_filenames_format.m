function check_filenames_format(filenames, ix_year, ...
    week_start, week_end)
% Check if the files to search through look plausible.


% Check that there is an equal number of files and weeks in the year.
if length(week_start:week_end) ~= length(filenames)
    warning('Should be same number of files as weeks.')
end


% Check that we deleted all '.' or '..' or '.DS_Store'
file_beginning = cellfun(@(x) x(1:3), filenames, 'UniformOutput', false);

if any(strcmp(file_beginning, '.'))
    warning('One of the files starts with ''.''.')
elseif any(strcmp(file_beginning, '..'))
    warning('One of the files starts with ''..''.')
elseif any(strcmp(file_beginning, '.DS'))
    warning('There is probably still a ''.DS_Store'' among the files.')
end


% Check if file endings are either .txt or .xml (case-insensitive)
file_end = cellfun(@(x) x(end-3:end), filenames, 'UniformOutput', false);

if any(not(or(strcmpi(file_end, '.txt'), strcmpi(file_end, '.xml'))))
    warning('There are files that are not ''.txt'' or ''.xml''.')
end


% Check that the last two letters of the year show up somewhere in the 
% file names.
year_str = num2str(ix_year);

indic_year_str_show_up = regexp(filenames, year_str(end-1:end));

if any( cellfun('isempty', indic_year_str_show_up) )
    warning('The last two number of the year (e.g. 89 or 1989) should show up in the filenames. They don''t in this case.')
end
