function patparts = extract_specific_patpart(extr_patnr, extr_patyear, ...
    extr_patweek, extr_patline_start, extr_patline_end, opt2001)


week_start = 1;

% Determine if there are 52 or 53 weeks in year
week_end = set_weekend(extr_patyear); 

filenames = get_filenames(extr_patyear, week_start, week_end, opt2001);

% Load the patent text
choose_file_open = filenames{extr_patweek};
unique_file_identifier = fopen(choose_file_open, 'r'); 

if unique_file_identifier == -1
    warning('Matlab cannot open the file')
end

open_file_aux = textscan(unique_file_identifier, '%s', ...
    'delimiter', '\n');
search_corpus = open_file_aux{1,1};

% Customize file type settings (ftset)
ftset = customize_ftset(extr_patyear, opt2001);

% Get start and end of patent text
% ------------------------------------------------------------
if isnan( extr_patline_end )
    extr_patline_end = length(search_corpus);
end

patent_text_corpus = search_corpus(extr_patline_start:extr_patline_end, :);

patparts = extract_patent_parts(patent_text_corpus, ftset);

% Close file again. It can cause errors if you open too many
% (more than abound 512) files at once.
fclose(unique_file_identifier);

check_open_files
