function filenames = get_filenames(ix_year, week_start, week_end)

% Build path to data
build_data_path = set_data_path(ix_year);
addpath(build_data_path);


% Get names of files
% -------------------------------------------------------------------
if ix_year < 2002
    file_paths = [build_data_path, '/*.txt'];
else
    % not case insensitive (both xml and XML are found)
    file_paths = [build_data_path, '/*.xml']; 
end
liststruct = dir(file_paths);
filenames = {liststruct.name};

check_filenames_format(filenames, ix_year, week_start, week_end)
end

function check_filenames_format(filenames, ix_year, ...
    week_start, week_end)
% Check if the files to search through look plausible.


% Check that there is an equal number of files and weeks in the year.
if length(week_start:week_end) ~= length(filenames)
    warning('Should be same number of files as weeks.')
end


% Check that we deleted all '.' or '..' or '.DS_Store'
check_filestart_dot(filenames)


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
end
