function pat_ix = make_patent_index(ix_year)

% Customize some settings for different file types
if (ix_year < 2002) && (ix_year > 1975)
    ftset.indic_filetype = 1;
    ftset.nr_trunc = 4;
    ftset.patent_findstr = 'PATN';
    ftset.nr_lines4previouspatent = 1;
    ftset.class_nr_findstr = 'OCL';
    
elseif (ix_year >=2002) && (ix_year < 2005)
    ftset.indic_filetype = 2;
    ftset.patent_findstr = '<?xml version="1.0" encoding="UTF-8"?>';
    ftset.pnr_find_str = '<B110><DNUM><PDAT>';
    ftset.class_nr_findstr = '<B521><PDAT>';
    
elseif (ix_year >=2005) && (ix_year < 2016)
    ftset.indic_filetype = 3;
    ftset.patent_findstr = '<!DOCTYPE us-patent-grant';
    ftset.pnr_find_str = '<us-patent-grant lang=';
    ftset.nr_lines4previouspatent = 1;
    ftset.class_nr_findstr = '<classification-national>';
    
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
        
    % Test if all WKU numbers are 9 digits long
    pnr_len = cellfun(@length, patent_number);
    test_vector_nines = repmat(9, nr_patents, 1); % don't do this every time
    if min(pnr_len == test_vector_nines) < 1
        warning('Not all patent WKU numbers are 9 characters long')
    end

    % Test number of WKU numbers equal number of index positions
    if length(patent_number) ~= length(ix_find)
        warning('Should be the same.')
    end 
    
    switch ftset.indic_filetype
        case 2
            % Look up tech classification number
            indic_class_find = regexp(search_corpus, ftset.class_nr_findstr);
            indic_class_find = ~cellfun(@isempty, indic_class_find); % make logical array
            ix_class_find = find(indic_class_find);

            if length(ix_class_find) ~= length(unique(ix_class_find))
                warning('Elements in ix_class_find should all be different.')
            end

            nr_class = length(ix_class_find);

            if nr_class ~= nr_patents
                warning('Number of patents should equal number of classifications')
            end

            if nr_class < 100
                warning('Number of classifications (= %d) is implausibly small', ...
                    nr_class)
            end 
    end
        
    % Initialize
    class_number = repmat({''}, nr_patents, 1);
    trunc_tech_class = repmat({''}, nr_patents, 1);

    switch ftset.indic_filetype
        case {1, 3}
           fdate = repmat({''}, nr_patents, 1); % save filing date

                for ix_patent=1:nr_patents

                    % Get start and end of patent text
                    % ------------------------------------------------------------
                    start_text_corpus = ix_find(ix_patent);

                    if ix_patent < nr_patents
                        end_text_corpus = ix_find(ix_patent+1) - ...
                            ftset.nr_lines4previouspatent;
                    else
                        end_text_corpus = length(search_corpus);
                    end

                    patent_text_corpus = search_corpus(...
                        start_text_corpus:end_text_corpus, :);

                    switch ftset.indic_filetype
                        case 1
                            lines_extracted = patent_text_corpus(3:20,:);
                            ix_fdate = strfind(lines_extracted, 'APD');
                            ix_fdate = find(~cellfun(@isempty, ix_fdate));

                            if isempty(ix_fdate)
                                fprintf('APD (filing date) not found (%d, %d, %d).\n', ...
                                    ix_year, ix_week, ix_patent)
                            end

                            line_fdate = lines_extracted{ix_fdate,:};
                            fdate_extract = line_fdate(6:11); % don't save the filing day
                            
                            % Look up OCL (tech classification)
                            ix_find_OCL = strfind(patent_text_corpus, ftset.class_nr_findstr);
                            all_OCL_matches = find(~cellfun(@isempty,ix_find_OCL));

                            % only look at first OCL match
                            row_OCL_class = patent_text_corpus{all_OCL_matches(1)}; 

                            % extract tech class number from string
                            class_number = row_OCL_class(6:numel(row_OCL_class));

                            % get rid of leading and trailing whitespace
                            class_number = strtrim(class_number);
                            
                        case 2
                            error('Should never be reached.')
                            
                        case 3
                            % Search for technology classification number
                            ftset.class_nr_findstr = '<classification-national>';
                            indic_class_find = regexp(patent_text_corpus, ftset.class_nr_findstr);
                            indic_class_find = ~cellfun(@isempty, indic_class_find); % make logical array
                            ix_class_find = find(indic_class_find);

                            % Two lines below the first appearance of the search string 
                            % is where we find our tech classificiation
                            class_nr_ix = ix_class_find(1) + 2;
                            class_nr_line = patent_text_corpus(class_nr_ix, :);
                            class_nr_line = class_nr_line{1};
                            % Classificiations differ in length, so have to find end
                            % where the classification stops.
                            class_find_end = regexp(class_nr_line, '</main-classification>'); 
                            class_number{ix_patent} = class_nr_line(22:class_find_end-1);
                            
                            % Look up filing date
                            find_fdate_str1 = '</doc-number>';
                            find_fdate_str2 = '<date>';

                            indic_fdate_find1 = strfind(patent_text_corpus, find_fdate_str1);
                            indic_fdate_find1 = ~cellfun(@isempty, indic_fdate_find1);
                            ix_fdate_find1 = find(indic_fdate_find1);
                            nextline = patent_text_corpus(ix_fdate_find1+1);

                            indic_fdate_find = strfind(nextline, find_fdate_str2);
                            indic_fdate_find = ~cellfun(@isempty, indic_fdate_find);
                            ix_fdate_find = find(indic_fdate_find);
                            extract_lines = nextline(ix_fdate_find);
                            fdate_line = extract_lines{1}; % take the first occurence
                            fdate_extract = fdate_line(7:12);
                    end
                    
                    check_fdate_formatting(fdate_extract, patent_number, ix_patent)          

                    % Stack information for all patents in a week under each other
                    fdate{ix_patent} = fdate_extract; % not fdate{ix_patent,1} ???
                end
                
                % Stack weekly information underneath
                % only keep first 3 digits
                % ------------------------------------------------------------
                if numel(class_number(:))>=3
                    trunc_tech_class{ix_patent} = class_number(1:3);
                else
                    trunc_tech_class{ix_patent} = class_number;
                    fprintf('Patent %s has too short tech class: %s.\n', ...
                        patent_number{ix_patent}, class_number)
                end              
                
        
        case 2
            for i=1:nr_class
                class_nr_line = search_corpus(ix_class_find(i), :);
                class_nr_line = class_nr_line{1};
                % Classifications differ in length, so have to find end
                % where the classification stops.
                class_find_end = regexp(class_nr_line, '</PDAT>'); 
                class_number{i} = class_nr_line(13:class_find_end-1);
            end

            cleaned_patent_tech_class = strtrim(class_number);

            % Keep only the first 3 digits
            for i=1:length(cleaned_patent_tech_class)
                pick = cleaned_patent_tech_class{i};

                if numel(pick)>=3
                    trunc_tech_class{i} = pick(1:3);
                else
                    trunc_tech_class{i} = pick;
                    fprintf('Patent in year %d with index %d has too short tech class: %s.\n', ...
                        ix_year, i, pick)
                end
            end
            
            % Look up filing date
            fdate = lookup_fdate(search_corpus);
    end
    
    % Define patent index.
    pat_ix{ix_week, 1} = patent_number;
    pat_ix{ix_week, 2} = ix_find;
    pat_ix{ix_week, 3} = trunc_tech_class;
    pat_ix{ix_week, 4} = fdate;

    % Close file again. It can cause errors if you open too many
    % (around 512) files at once.
    fclose(unique_file_identifier);
    check_open_files()

    fprintf('Week finished: %d/%d.\n', ix_week, week_end)
end
