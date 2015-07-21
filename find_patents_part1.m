close all
clear all
clc



%% Set some inputs
year_start = 1976;
year_end = 2001;



%%
for ix_year = year_start:year_end
    tic
    
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
        file_str = open_file_aux{1,1};


        % Define new search corpus as we might change some things about this
        search_corpus = file_str; 
        

        % Count number of patents in a given week
        % ----------------------------------------------------------------
        nr_trunc = 4;
        
        if ix_year == 2001 % special case: problem with 80 numel text file
            fprintf('*** Enter special case, year: %d, week: %d.\n', ...
            [indic_find, nr_patents, ix_find] = ...
                count_nr_patents_trunccorpus(search_corpus, 'PATN', ...
                nr_trunc);           
        
        % Something is wrong in year 1978
        elseif ix_year == 1978 && (ix_week == 25 | ix_week == 26)  
            fprintf('*** Enter special case, year: %d, week: %d.\n', ...
            [indic_find, nr_patents, ix_find] = ...
                count_nr_patents_trunccorpus(search_corpus, 'PATN', ...
                nr_trunc);             
            
          elseif ix_year == 1979 && (ix_week == 11 | ix_week == 12)
            fprintf('*** Enter special case, year: %d, week: %d.\n', ...
            [indic_find, nr_patents, ix_find] = ...
                count_nr_patents_trunccorpus(search_corpus, 'PATN', ...
                nr_trunc);             
            
          % I can probably delete the following special case: 
          % The problem was with the empty lines in week 50
          
         elseif ix_year == 1984 && (ix_week == 1 | ix_week == 49 ...
                 | ix_week == 50) 
             fprintf('*** Enter special case, year: %d, week: %d.\n', ...
                 ix_year, ix_week)
            [indic_find, nr_patents, ix_find] = ...
                count_nr_patents_trunccorpus(search_corpus, 'PATN', ...
                nr_trunc);           
            
        elseif ix_year == 1997 && (ix_week >= 38) 
            fprintf('*** Enter special case, year: %d, week: %d.\n', ...
                  ix_year, ix_week)
            [indic_find, nr_patents, ix_find] = ...
                count_nr_patents_trunccorpus(search_corpus, 'PATN', ...
                nr_trunc); 
            
        elseif ix_year == 1998
            fprintf('*** Enter special case, year: %d, week: %d.\n', ...
                  ix_year, ix_week)
            [indic_find, nr_patents, ix_find] = ...
                count_nr_patents_trunccorpus(search_corpus, 'PATN', ...
                nr_trunc);
            
        else
            [indic_find, nr_patents, ix_find] = count_nr_patents(...
                search_corpus, 'PATN'); 
        end

        % Test: did not find patents
        if nr_patents < 100
            warning('The number of patents (= %d) is implausibly small', ...
                nr_patents)
        end    

        % Pre-define empty cell array to store patent WKU numbers (based on finding) PATN
        patent_number = repmat({''}, nr_patents, 1);

        for i=1:nr_patents
             wku_line = search_corpus(ix_find(i)+1, :);
             wku_line = wku_line{1};
             
             if numel(wku_line) < 2
                 fprintf('~~~ Correct for empty string after patent number %d/%d\n', ...
                     i, nr_patents)
                 wku_line = search_corpus(ix_find(i)+2, :); % jump over empty line
                 wku_line = wku_line{1};
                 patent_number{i} = wku_line(6:14);
                 
                 if numel(wku_line) < 2 % check if problem still there
                     warning('Something is fishy.')
                 end
                 
             else % default standard case, no line between PATN and WKU
                 patent_number{i} = wku_line(6:14);
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
        
        % 'PATN' shows up in a table header, delete this entry
        if ix_year == 1999 && ix_week == 14
            fprintf('Delete patent number %d.\n', ...
                show_ix_contains_space)
            patent_number(show_ix_contains_space) = [];
            ix_find(show_ix_contains_space) = [];
            nr_patents = nr_patents - 1;
        elseif ix_year == 2001 && (ix_week == 10 | ix_week == 26 ...
                | ix_week == 40 | ix_week==52) 
            fprintf('Delete patent number %d.\n', ...
                show_ix_contains_space)
            patent_number(show_ix_contains_space) = [];
            ix_find(show_ix_contains_space) = [];
            nr_patents = nr_patents - 1;
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
        
        % Initialize
        class_number = repmat({''}, nr_patents, 1);
        trunc_tech_class = repmat({''}, nr_patents, 1);
        fdate = repmat({''}, nr_patents, 1); % save filing date
        
        for ix_patent=1:nr_patents

            % Get start and end of patent text
            % ------------------------------------------------------------
            start_text_corpus = ix_find(ix_patent);

            if ix_patent < nr_patents
                end_text_corpus = ix_find(ix_patent+1)-1;
            else
                end_text_corpus = length(search_corpus);
            end

            patent_text_corpus = search_corpus(...
                start_text_corpus:end_text_corpus, :);

            lines_extracted = patent_text_corpus(3:20,:);
            ix_fdate = strfind(lines_extracted, 'APD');
            ix_fdate = find(~cellfun(@isempty, ix_fdate));
            
            if isempty(ix_fdate)
                fprintf('APD (filing date) not found (%d, %d, %d).\n', ...
                    ix_year, ix_week, ix_patent)
            end
            
            line_fdate = lines_extracted{ix_fdate,:};
            fdate_extract = line_fdate(6:11); % don't save the filing day
            
            check_fdate_formatting(fdate_extract, patent_number, ix_patent)          

            % Stack information for all patents in a week under each other
            fdate{ix_patent} = fdate_extract;
            
            % Look up OCL (tech classification)
            % ------------------------------------------------------------
            ix_find_OCL = strfind(patent_text_corpus, 'OCL');
            all_OCL_matches = find(~cellfun(@isempty,ix_find_OCL));
            
            % only look at first OCL match
            row_OCL_class = patent_text_corpus{all_OCL_matches(1)}; 
            
            % extract tech class number from string
            patent_OCL_class = row_OCL_class(6:numel(row_OCL_class));
            
            % get rid of leading and trailing whitespace
            patent_OCL_class = strtrim(patent_OCL_class);
            
            % Stack weekly information underneath
            % only keep first 3 digits
            % ------------------------------------------------------------
            if numel(patent_OCL_class)>=3
                trunc_tech_class{ix_patent} = patent_OCL_class(1:3);
            else
                trunc_tech_class{ix_patent} = patent_OCL_class;
                fprintf('Patent %s has too short tech class: %s.\n', ...
                    patent_number{ix_patent}, patent_OCL_class)
            end
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
    
    % Save to .mat file
    % -------------------------------------------------------------------
    save_patix2mat(pat_ix, ix_year)
    
    print_finish_summary(toc, ix_year)
end
