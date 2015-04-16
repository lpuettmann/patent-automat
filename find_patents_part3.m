close all
clear all
clc



%% Add path to functions
addpath('functions');



%% Set some inputs
year_start = 2005;
year_end = 2015;



%% Go
% ========================================================================
for ix_year = year_start:year_end
    tic

    week_start = 1;

    % Determine if there are 52 or 53 weeks in year
    week_end = set_weekend(ix_year); 

    build_data_path = horzcat('T:\Puettmann\patent_data_save\', ...
        num2str(ix_year));
    addpath(build_data_path);


    % Get names of files
    % -------------------------------------------------------------------
    liststruct = dir(build_data_path);
    filenames = {liststruct.name};
    filenames = filenames(3:end)'; % truncate first elements . and ..

    filenames = ifmac_truncate_more(filenames);

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
        find_str = '<us-patent-grant lang=';
        indic_find = regexp(search_corpus, find_str);
        indic_find = ~cellfun(@isempty,indic_find); % make logical array

        ix_find = find(indic_find);

        if length(ix_find) ~= length(unique(ix_find))
            warning('Elements in ix_find should all be different.')
        end

        nr_patents = length(ix_find);

        if nr_patents < 100
            warning('The number of patents (= %d) is implausibly small', ...
                nr_patents)
        end 

        patent_number = repmat({''}, nr_patents, 1);

        for i=1:nr_patents
            patent_nr_line = search_corpus(ix_find(i), :);
            patent_nr_line = patent_nr_line{1};
            patent_nr_start = regexp(patent_nr_line, 'file="US');
            patent_nr_trunc = patent_nr_line(patent_nr_start+8:end); % WATCH OUT: 8 is hard-coded
            patent_nr_end = regexp(patent_nr_trunc, '-'); 
            patent_nr_end = patent_nr_end(1);
            patent_number{i} = patent_nr_trunc(1:patent_nr_end-1);

            if numel(patent_number) < 2
                warning('Something is fishy.')
            end
        end


        % Test if there are any spaces in WKU numbers
        test_contains_space = strfind(patent_number, ' ');
        show_ix_contains_space = find(~cellfun(@isempty, test_contains_space));
        if not(isempty(show_ix_contains_space))
            warning('There is a space in the patent WKU numbers')
            disp(patent_number(show_ix_contains_space))
        end


        % Test if all WKU numbers are 8 digits long
        test_is9long = cellfun(@length, patent_number);
        test_vector_nines = repmat(8, nr_patents, 1); % don't do this every time
        if min(test_is9long == test_vector_nines) < 1
            warning('Not all patent WKU numbers are 9 characters long')
        end


        % Test number of WKU numbers equal number of index positions
        if length(patent_number) ~= length(ix_find)
            warning('Should be the same.')
        end   

        
        
        % To find patent technology classification, iterate through
        % patents.
        % ------------------------------------------------------------
        
        % Initialize
        class_number = repmat({''}, nr_patents, 1); 
        trunc_tech_class = repmat({''}, nr_patents, 1);
        fdate = repmat({''}, nr_patents, 1); % filing date
        
        for ix_patent=1:nr_patents

            % Get start and end of patent text
            % ------------------------------------------------------------
            start_text_corpus = ix_find(ix_patent);

            if ix_patent < nr_patents
                end_text_corpus = ix_find(ix_patent+1) - 3; % ATTENTION: this number is hard-coded!
            else
                end_text_corpus = length(search_corpus);
            end

            patent_text_corpus = search_corpus(start_text_corpus:...
                end_text_corpus, :);

            % Search for technology classification number
            % ------------------------------------------------------------
            find_class_str = '<classification-national>';
            indic_class_find = regexp(patent_text_corpus, find_class_str);
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
            % ------------------------------------------------------------
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
            check_fdate_formatting(fdate_extract)   
            fdate{ix_patent,1} = fdate_extract;
        end
        
        if length(class_number) < 100
            warning('Number of classifications (= %d) is implausibly small', ...
                nr_class)
        end 
        
        cleaned_patent_tech_class = strtrim(class_number);

        % Keep only the first 3 digits
        for i=1:length(cleaned_patent_tech_class)
            pick = cleaned_patent_tech_class{i};

            if numel(pick)>=3
                trunc_tech_class{i} = pick(1:3);
            else
                trunc_tech_class{i} = pick;
                fprintf('Patent in year %d with index %d has too short tech class: %s.\n', ix_year, i, pick)
            end
        end
        
   
        
        % Define patent index. It consists of the patent's WKU number 
        % and its index position in the file. Save information for week in cell array
        % -------------------------------------------------------------------
        pat_ix{ix_week, 1} = patent_number;
        pat_ix{ix_week, 2} = ix_find;
        pat_ix{ix_week, 3} = trunc_tech_class;
        pat_ix{ix_week, 4} = fdate;

        
        % Close file again. It can cause errors if you open too many
        % (around 512) files at once.
        fclose(unique_file_identifier);

        check_open_files
        
        fprintf('Week finished: %d/%d.\n', ix_week, week_end)
    end

    
    % Save to .mat file
    % -------------------------------------------------------------------
    save_name = horzcat('patent_index_', num2str(ix_year), '.mat');
    matfile_path_save = fullfile('patent_index', save_name);
    save(matfile_path_save, 'pat_ix');    
    fprintf('Saved: %s.\n', save_name)
    
    year_loop_time = toc;
    disp('---------------------------------------------------------------')
    fprintf('Year %d finished, time: %d seconds (%d minutes).\n', ...
        ix_year, round(year_loop_time), round(year_loop_time/60))
    disp('---------------------------------------------------------------')
end

