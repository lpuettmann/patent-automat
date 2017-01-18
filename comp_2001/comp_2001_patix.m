clear all
close all


% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()

%% Choose years 
ix_year = 2001;

year_start = ix_year;
year_end = ix_year;

parent_dname = 'T:/Puettmann/patent_project/2001_compare_data';

ftset.indic_filetype = 2;
ftset.patent_findstr = '<!DOCTYPE PATDOC PUBLIC "-//USPTO//DTD ST.32 US PATENT GRANT V2.4 2000-09-20//EN" [';
ftset.pnr_find_str = '<B110><DNUM><PDAT>';
ftset.nr_lines4previouspatent = 2;

ftset.uspc_nr_findstr = '<B521><PDAT>';
ftset.uspc_nr_linestart = 13;
ftset.uspc_nr_linestop = '</PDAT>';

ftset.indic_specialcase = 0;

% Use a regular expression to search for one or the other
ftset.ipc_nr_findstr = '(<B511><PDAT>)|(<B512><PDAT>)';
ftset.ipc_nr_linestart = 13;
ftset.ipc_nr_linestop = '</PDAT>';

ftset.fdate_findstr = '<B220><DATE><PDAT>';
ftset.fdate_linestart = 19;
ftset.fdate_linestop = 24;

week_start = 1;
week_end = set_weekend(ix_year); 

% Add path to data and get a list with filenames for the year
addpath(parent_dname);
file_paths = [parent_dname, '/*.sgm'];
liststruct = dir(file_paths);
filenames = {liststruct.name};

% Check that there is an equal number of files and weeks in the year.
if length(week_start:week_end) ~= length(filenames)
    warning('Should be same number of files as weeks.')
end

% Check that we deleted all '.' or '..' or '.DS_Store'
check_filestart_dot(filenames)

% Check if file endings are either .txt or .xml (case-insensitive)
file_end = cellfun(@(x) x(end-3:end), filenames, 'UniformOutput', false);

if any(not(strcmpi(file_end, '.sgm')))
    error('There are files that are not ''.sgm''.')
end

% Check that the last two letters of the year show up somewhere in the 
% file names.
year_str = num2str(ix_year);

indic_year_str_show_up = regexp(filenames, year_str(end-1:end));

if any( cellfun('isempty', indic_year_str_show_up) )
    warning('The last two number of the year (e.g. 89 or 1989) should show up in the filenames. They don''t in this case.')
end

%% Iterate through files of weekly patent grant text data
% -------------------------------------------------------------------
fprintf('Build patent index for year %d:\n', ix_year)


for ix_week = week_start:week_end
    choose_file_open = filenames{ix_week};

    % Load the patent text
    unique_file_identifier = fopen(choose_file_open, 'r');   

    if unique_file_identifier == -1
        warning('Matlab cannot open the file')
    end

    open_file_aux = textscan(unique_file_identifier, '%s', ...
        'delimiter', '\n');
    search_corpus = open_file_aux{1,1};

    % Look for patents
    % ----------------------------------------------------------------
    [ix_find, nr_patents] = look4patents(search_corpus, ftset, ix_year, ...
        ix_week);

    % Get the lines with the patent numbers
    ix_pnr = get_patent_number_line(ix_find, search_corpus, ftset, nr_patents);

    % Extract patent numbers
    patent_number = extract_patent_number(nr_patents, search_corpus, ...
        ix_pnr, ftset);

    % Test if there are any spaces in patent numbers
    test_contains_space = strfind(patent_number, ' ');
    show_ix_contains_space = find(~cellfun(@isempty, ...
        test_contains_space));
    if not(isempty(show_ix_contains_space))
        warning('There is a space in the patent patent numbers')
        disp(patent_number(show_ix_contains_space))
    end

    switch ftset.indic_filetype
        case 1
            % 'PATN' shows up in a table header, delete this entry
            if ix_year == 1999 && ix_week == 14
                fprintf('Delete patent number %d.\n', ...
                    show_ix_contains_space)
                patent_number(show_ix_contains_space) = [];
                ix_find(show_ix_contains_space) = [];
                nr_patents = nr_patents - 1;
            elseif ix_year == 2001 && (ix_week == 10 || ix_week == 26 ...
                    || ix_week == 40 || ix_week==52) 
                fprintf('Delete patent number %d.\n', ...
                    show_ix_contains_space)
                patent_number(show_ix_contains_space) = [];
                ix_find(show_ix_contains_space) = [];
                nr_patents = nr_patents - 1;
            end
    end

    % Test if patent numbers have the right format
    switch ftset.indic_filetype
        case 1
            pnr_len = cellfun(@length, patent_number);
            test_vector_numbers = repmat(9, nr_patents, 1);
            if min(pnr_len == test_vector_numbers) < 1
                warning('Not all patent numbers have right length.')
            end

        case {2, 3}
            pnr_len = cellfun(@length, patent_number);
            test_vector_numbers = repmat(8, nr_patents, 1);
            if min(pnr_len == test_vector_numbers) < 1
                warning('Not all patent numbers have right length.')
            end 
    end

    % Test number of patent numbers equal number of index positions
    if length(patent_number) ~= length(ix_find)
        warning('Should be the same.')
    end 

    % Look up patent technology classification numbers
    [uspc_nr, ipc_nr] = lookup_techclassification_nr(nr_patents, ...
        ix_find, ftset, search_corpus);

    % Look up filing dates
    fdate = lookup_fdate(search_corpus, ftset, ix_find, nr_patents);

    for ix_patent=1:nr_patents
        fdatepick = fdate{ix_patent};
        patnrpick = patent_number{ix_patent};        
        check_fdate_formatting(fdatepick, patnrpick) 
    end 

    % Define patent index.
    pat_ix{ix_week, 1} = patent_number;
    pat_ix{ix_week, 2} = ix_find;
    pat_ix{ix_week, 3} = uspc_nr;
    pat_ix{ix_week, 4} = fdate;
    pat_ix{ix_week, 5} = ipc_nr;

    % Close file again. It can cause errors if you open too many
    % (around 512) files at once.
    fclose(unique_file_identifier);
    check_open_files()

    fprintf('[%d] Week finished: %d/%d.\n', ix_year, ix_week, week_end)
end

save_name = './comp_2001/patent_index_2001_comp.mat';
save(save_name, 'pat_ix');    
fprintf('Saved: %s.\n', save_name)

  