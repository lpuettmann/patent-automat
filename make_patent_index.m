function pat_ix = make_patent_index(ix_year)

% Customize some settings for different file types
if (ix_year < 2002) && (ix_year > 1975)
    ftset.indic_filetype = 1;
    ftset.nr_trunc = 4;
    ftset.patent_findstr = 'PATN'; % patent grant text start
    ftset.nr_lines4previouspatent = 1;
    
    ftset.uspc_nr_findstr = 'OCL'; % United States Patent Classification (USPC)
    ftset.ipc_nr_findstr = 'ICL '; % International Patent Classification (IPC)
    
    ftset.fdate_findstr = 'APD'; % file date
    ftset.fdate_linestart = 6;
    ftset.fdate_linestop = 11;
    
elseif (ix_year >=2002) && (ix_year < 2005)
    ftset.indic_filetype = 2;
    ftset.patent_findstr = '<?xml version="1.0" encoding="UTF-8"?>';
    ftset.pnr_find_str = '<B110><DNUM><PDAT>';
    ftset.nr_lines4previouspatent = 2;
    
    ftset.uspc_nr_findstr = '<B521><PDAT>';
    ftset.uspc_nr_linestart = 13;
    ftset.uspc_nr_linestop = '</PDAT>';
    
    ftset.ipc_nr_findstr = '<B511><PDAT>';
    ftset.ipc_nr_linestart = nan;
    ftset.ipc_nr_linestop = nan;
    
    ftset.fdate_findstr = '<B220><DATE><PDAT>';
    ftset.fdate_linestart = 19;
    ftset.fdate_linestop = 24;
    
elseif (ix_year >=2005) && (ix_year < 2016)
    ftset.indic_filetype = 3;
    ftset.patent_findstr = '<!DOCTYPE us-patent-grant';
    ftset.pnr_find_str = '<us-patent-grant lang=';
    ftset.nr_lines4previouspatent = 1;
    
    ftset.uspc_nr_findstr = '<classification-national>';
    ftset.uspc_nr_linestart = 22;
    ftset.uspc_nr_linestop = '</main-classification>';
    
    ftset.fdate_linestart = 7;
    ftset.fdate_linestop = 12;
    
else
    warning('The codes are not designed for year: %d.', ix_year)
end

week_start = 1;

% Determine if there are 52 or 53 weeks in year
week_end = set_weekend(ix_year); 

% Add path to data and get a list with filenames for the year
filenames = get_filenames(ix_year, week_start, week_end);


% Iterate through files of weekly patent grant text data
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

    % Test if there are any spaces in WKU numbers
    test_contains_space = strfind(patent_number, ' ');
    show_ix_contains_space = find(~cellfun(@isempty, ...
        test_contains_space));
    if not(isempty(show_ix_contains_space))
        warning('There is a space in the patent WKU numbers')
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

    % Test number of WKU numbers equal number of index positions
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
