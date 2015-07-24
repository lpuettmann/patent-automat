function pat_ix = make_patent_index(ix_year)

% Customize some settings for different file types
if (ix_year < 2002) && (ix_year > 1975)
    ftset.indic_filetype = 1;
    ftset.nr_trunc = 4;
    ftset.patent_findstr = 'PATN';
    ftset.nr_lines4previouspatent = 1;
    ftset.class_nr_findstr = 'OCL';
    ftset.fdate_findstr = 'APD';
    
elseif (ix_year >=2002) && (ix_year < 2005)
    ftset.indic_filetype = 2;
    ftset.patent_findstr = '<?xml version="1.0" encoding="UTF-8"?>';
    ftset.pnr_find_str = '<B110><DNUM><PDAT>';
    ftset.class_nr_findstr = '<B521><PDAT>';
    ftset.classnr_linestart = 13;
    ftset.classnr_linestop = '</PDAT>';
    ftset.fdate_findstr = '<B220><DATE><PDAT>';
    
elseif (ix_year >=2005) && (ix_year < 2016)
    ftset.indic_filetype = 3;
    ftset.patent_findstr = '<!DOCTYPE us-patent-grant';
    ftset.pnr_find_str = '<us-patent-grant lang=';
    ftset.class_nr_findstr = '<classification-national>';
    ftset.nr_lines4previouspatent = 1;
    ftset.classnr_linestart = 22;
    ftset.classnr_linestop = '</main-classification>';
    
else
    warning('The codes are not designed for year: %d.', ix_year)
end

week_start = 1;

% Determine if there are 52 or 53 weeks in year
week_end = set_weekend(ix_year); 

build_data_path = set_data_path(ix_year);
addpath(build_data_path);


% Get names of files
% -------------------------------------------------------------------
liststruct = dir(build_data_path);
filenames = {liststruct.name};
filenames = filenames(3:end)'; % truncate first elements . and ..

filenames = ifmac_truncate_more(filenames);
check_filenames_format(filenames, ix_year, week_start, week_end)


% Iterate through files of weekly patent grant text data
% -------------------------------------------------------------------
fprintf('Build patent index for year %d:\n', ix_year)

ix_week = 1;

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
    case {1, 2}
        pnr_len = cellfun(@length, patent_number);
        test_vector_numbers = repmat(9, nr_patents, 1);
        if min(pnr_len == test_vector_numbers) < 1
            warning('Not all patent numbers have right length.')
        end
        
    case 3
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
trunc_tech_class = lookup_techclassification_nr(nr_patents, ix_find, ...
    ftset, search_corpus);

% Look up filing dates
fdate = lookup_fdate();

