function pat_ix = make_patent_index(ix_year)

% Customize some settings for different file types
if (ix_year < 2002) && (ix_year > 1975)
    indic_filetype = 1;
    nr_trunc = 4;
    patent_findstr = 'PATN';
    nr_lines4previouspatent = 1;
    class_nr_findstr = 'OCL';
    
elseif (ix_year >=2002) && (ix_year < 2005)
    indic_filetype = 2;
    patent_findstr = '<?xml version="1.0" encoding="UTF-8"?>';
    pnr_find_str = '<B110><DNUM><PDAT>';
    class_nr_findstr = '<B521><PDAT>';
    
elseif (ix_year >=2005) && (ix_year < 2016)
    indic_filetype = 3;
    patent_findstr = '<!DOCTYPE us-patent-grant';
    pnr_find_str = '<us-patent-grant lang=';
    nr_lines4previouspatent = 1;
    class_nr_findstr = '<classification-national>';
    
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
    switch indic_filetype
        case 1
            [indic_find, nr_patents, ix_find] = special_cases_part1(...
                search_corpus, patent_findstr, nr_trunc, ix_year, ix_week);
        
        case 2
            indic_find = strcmp(search_corpus, patent_findstr);
            ix_find = find(indic_find);
            nr_patents = length(ix_find);
            
        case 3
            indic_find = regexp(search_corpus, patent_findstr);             
            emptyIndex = cellfun(@isempty, indic_find);
            indic_find(emptyIndex) = {0};
            indic_find = cell2mat(indic_find);
            % Subtract 1, as the patent text starts one line before the
            % phrase we're looking for here.
            ix_find = find(indic_find) - 1;
            nr_patents = length(ix_find);  
    end
        

    if nr_patents ~= length( unique(ix_find) )
        warning('Elements in ix_find should all be different.')
    end

    if nr_patents < 100
        warning('The number of patents (= %d) is implausibly small', ...
            nr_patents)
    end    

    % Get the lines with the patent numbers
    switch indic_filetype
        case 1
            % For the first filetype 1976-2015, the patent number always
            % appears one below where the new patent grant texts starts.
            ix_pnr = ix_find + 1; 
            
        case {2, 3}
            indic_class_pnr = regexp(search_corpus, pnr_find_str);
            indic_class_pnr = ~cellfun(@isempty, indic_class_pnr); % make logical array
            ix_pnr = find( indic_class_pnr );
    end
    
    if not( nr_patents == length(ix_pnr) )
        warning('Number of patents should be equal when searching for both terms.')
    end
    
    if not( length(indic_class_pnr) == size(search_corpus, 1))
        warning('Should be equal.')
    end
    
    % Pre-define empty cell array to hold patent numbers
    patent_number = repmat({''}, nr_patents, 1);
    
    % Extract patent numbers
    for i=1:nr_patents
        patent_nr_line = search_corpus(ix_pnr(i), :);
        patent_nr_line = patent_nr_line{1};

        switch indic_filetype
            case 1
                if numel(patent_nr_line) < 2
                     fprintf('~~~ Correct for empty string after patent number %d/%d\n', ...
                         i, nr_patents)
                     patent_nr_line = search_corpus(ix_pnr + 1, :); % jump over empty line
                     patent_nr_line = patent_nr_line{1};
                     patent_number{i} = patent_nr_line(6:14);
                else % default standard case, no line between PATN and WKU
                    patent_number{i} = patent_nr_line(6:14);
                end
                
            case 2
                patent_nr_end = regexp(patent_nr_line, '</PDAT>'); 
                patent_number{i} = patent_nr_line(19:patent_nr_end-1);
                
            case 3
                patent_nr_start = regexp(patent_nr_line, 'file="US');
                patent_nr_trunc = patent_nr_line(patent_nr_start+8:end); % WATCH OUT: 8 is hard-coded
                patent_nr_end = regexp(patent_nr_trunc, '-'); 
                patent_nr_end = patent_nr_end(1);
                patent_number{i} = patent_nr_trunc(1:patent_nr_end-1);
        end
        
        if numel(patent_number) < 2
            warning('There seems something wrong with the patent number.')
        end
    end
    
    % Test if there are any spaces in WKU numbers
    test_contains_space = strfind(patent_number, ' ');
    show_ix_contains_space = find(~cellfun(@isempty, ...
        test_contains_space));
    if not(isempty(show_ix_contains_space))
        warning('There is a space in the patent WKU numbers')
        disp(patent_number(show_ix_contains_space))
    end
    
    switch indic_filetype
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
    test_is9long = cellfun(@length, patent_number);
    test_vector_nines = repmat(9, nr_patents, 1); % don't do this every time
    if min(test_is9long == test_vector_nines) < 1
        warning('Not all patent WKU numbers are 9 characters long')
    end

    % Test number of WKU numbers equal number of index positions
    if length(patent_number) ~= length(ix_find)
        warning('Should be the same.')
    end 
    
    switch indic_filetype
        case 2
            % Look up tech classification number
            indic_class_find = regexp(search_corpus, class_nr_findstr);
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

    switch indic_filetype
        case {1, 3}
           fdate = repmat({''}, nr_patents, 1); % save filing date

                for ix_patent=1:nr_patents

                    % Get start and end of patent text
                    % ------------------------------------------------------------
                    start_text_corpus = ix_find(ix_patent);

                    if ix_patent < nr_patents
                        end_text_corpus = ix_find(ix_patent+1) - ...
                            nr_lines4previouspatent;
                    else
                        end_text_corpus = length(search_corpus);
                    end

                    patent_text_corpus = search_corpus(...
                        start_text_corpus:end_text_corpus, :);

                    switch indic_filetype
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
                            ix_find_OCL = strfind(patent_text_corpus, class_nr_findstr);
                            all_OCL_matches = find(~cellfun(@isempty,ix_find_OCL));

                            % only look at first OCL match
                            row_OCL_class = patent_text_corpus{all_OCL_matches(1)}; 

                            % extract tech class number from string
                            class_number = row_OCL_class(6:numel(row_OCL_class));

                            % get rid of leading and trailing whitespace
                            class_number = strtrim(class_number);
                            
                        case 2
                            warning('Should never be reached.')
                            
                        case 3
                            % Search for technology classification number
                            class_nr_findstr = '<classification-national>';
                            indic_class_find = regexp(patent_text_corpus, class_nr_findstr);
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
                if numel(class_number)>=3
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
                % Classificiations differ in length, so have to find end
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
