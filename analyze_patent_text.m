clc
clear all
close all



%% Define keyword to look for
% ========================================================================
find_str = 'automat'; 


%% Choose time period to analyze
% ========================================================================

for ix_year = 1976:1979
    tic
    
    year = ix_year;
    week_start = 1;

    % 53 weeks: 1980, 1985, 1991, 1996
    if year == 1980 | year == 1985 | year == 1991 | year == 1996
        week_end = 53;
    else
        week_end = 52; 
    end


    build_data_path = horzcat('.\data\', num2str(year));

    addpath('functions');
    addpath('data');
    addpath(build_data_path);


    %% Get names of files
    % ========================================================================
    liststruct = dir(build_data_path);
    filenames = {liststruct.name};
    filenames = filenames(3:end)'; % truncate first elements . and ..


    %% ITERATE THROUGH FILES WITH WEEK PATENT DATA
    % ========================================================================
    fprintf('* Enter loop for year %d\n', year)

    for ix_week = week_start:week_end
        choose_file_open = filenames{ix_week};

        % Load the patent text
        % -------------------------------------------------------------------
        unique_file_identifier = fopen(choose_file_open, 'r');   

        if unique_file_identifier == -1
            warning('Matlab cannot open the file')
        end

        open_file_aux = textscan(unique_file_identifier, '%s', ...
            'delimiter', '\n');
        file_str = open_file_aux{1,1};


        % Define new search corpus as we might change some things about this
        search_corpus = file_str; 


        % Eliminate the name section from the search corpus
        % --------------------------------------------------------------------
        ix_find_NAM = strfind(file_str,'NAM');
        show_row_NAM = find(~cellfun(@isempty,ix_find_NAM));

        search_corpus(show_row_NAM) = []; % delete rows with NAN

        % Test if we get the right number of rows
        if length(file_str)-length(search_corpus) ~= length(show_row_NAM)
            warning(['Are you sure you deleted the right columns with ', ...
                'NAM in them?'])
        end


        %% Count number of patents in a given week
        % --------------------------------------------------------------------

        if year == 2001 % special case: problem with 80 numel text file
            fprintf('*** Enter special case, year: %d, week: %d.\n', ...
                  year, ix_week)
            trunc4_corpus
        
        % Something is wrong in year 1978
        elseif year == 1978 && (ix_week == 25 | ix_week == 26)  
            fprintf('*** Enter special case, year: %d, week: %d.\n', ...
                  year, ix_week)
            trunc4_corpus
            
          elseif year == 1979 && (ix_week == 11 | ix_week == 12)
            fprintf('*** Enter special case, year: %d, week: %d.\n', ...
                  year, ix_week)
            trunc4_corpus
            
          % I can probably delete the following special case: 
          % The problem was with the empty lines in week 50
          
         elseif year == 1984 && (ix_week == 1 | ix_week == 49 | ix_week == 50) 
             fprintf('*** Enter special case, year: %d, week: %d.\n', ...
                 year, ix_week)
            trunc4_corpus
            
        elseif year == 1997 && (ix_week >= 38) 
            fprintf('*** Enter special case, year: %d, week: %d.\n', ...
                  year, ix_week)
            trunc4_corpus
            
        elseif year == 1998
            fprintf('*** Enter special case, year: %d, week: %d.\n', ...
                  year, ix_week)
            trunc4_corpus
            
        else
            [indic_find, nr_patents, ix_find] = count_nr_patents(...
                search_corpus, 'PATN'); 
        end

        % Test: did not find patents
        if nr_patents < 100
            warning(['The number of patents (= %d) is implausibly small'], ...
                nr_patents)
        end    

        % Pre-define empty cell array to store patent WKU numbers (based on finding) PATN
        patent_number = repmat({''}, nr_patents, 1);

        for i=1:nr_patents
             wku_line = search_corpus(ix_find(i)+1, :);
             wku_line = wku_line{1};
             
             if numel(wku_line) < 2
                 fprintf('~~~ Empty string after patent number %d/%d\n', ...
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
        show_ix_contains_space = find(~cellfun(@isempty, test_contains_space));
        if not(isempty(show_ix_contains_space))
            warning('There is a space in the patent WKU numbers')
            disp(patent_number(show_ix_contains_space))
        end
        
        % 'PATN' shows up in a table header, delete this entry
        if year == 1999 && ix_week == 14
            fprintf('Delete patent number %d.\n', ...
                show_ix_contains_space)
            patent_number(show_ix_contains_space) = [];
            ix_find(show_ix_contains_space) = [];
            nr_patents = nr_patents - 1;
        elseif year == 2001 && (ix_week == 10 | ix_week == 26 | ix_week == 40 | ix_week==52) 
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


        % Extract patent text
        % --------------------------------------------------------------------
        nr_keyword_appear = patent_number;

        % Get empty cells next to the WKU patent numbers. 
        nr_keyword_appear{1,2} = []; % column for keyword matches
        nr_keyword_appear{1,3} = []; % column for OCL classifications

        % Insert the current year for later reference
        nr_keyword_appear = [nr_keyword_appear, ...
            num2cell(repmat(year, nr_patents, 1))];

        % Insert the current week for later reference
        nr_keyword_appear = [nr_keyword_appear, ...
            num2cell(repmat(ix_week, nr_patents, 1))];


        for ix_patent=1:nr_patents

            % Get start and end of patent text
            % ----------------------------------------------------------------
            start_text_corpus = ix_find(ix_patent);

            if ix_patent < nr_patents
                end_text_corpus = ix_find(ix_patent+1)-1;
            else
                end_text_corpus = length(search_corpus);
            end

            patent_text_corpus = search_corpus(start_text_corpus:...
                end_text_corpus, :);

            % Search for keyword
            % ----------------------------------------------------------------
            ix_keyword_find = regexpi(patent_text_corpus, find_str);
            ix_keyword_find = ix_keyword_find(~cellfun('isempty', ...
                ix_keyword_find));
            nr_keyword_find = length(ix_keyword_find);
            
            % Look up OCL (tech classification)
            % ----------------------------------------------------------------
            ix_find_OCL = strfind(patent_text_corpus, 'OCL');
            all_OCL_matches = find(~cellfun(@isempty,ix_find_OCL));
            row_OCL_class = patent_text_corpus{all_OCL_matches(1)};
            patent_OCL_class = row_OCL_class(5:numel(row_OCL_class));
            
            % Stack weekly information underneath
            % ----------------------------------------------------------------
            nr_keyword_appear{ix_patent, 2} = nr_keyword_find;
            nr_keyword_appear{ix_patent, 3} = patent_OCL_class;
        end

        % Save information for all weeks
        % -------------------------------------------------------------------
        if ix_week == week_start % first iteration: have to newly define this variable
            patent_keyword_appear = repmat({''}, 1, ...
                size(nr_keyword_appear, 2));
        end        

        patent_keyword_appear = [patent_keyword_appear;
                                 nr_keyword_appear];

        if ix_week == week_end % last iteration: delete first row
            patent_keyword_appear(1,:) = [];
        end 

        fprintf('Week finished: %d/%d.\n', ix_week, week_end)
    end

    
    %% Save
    % ========================================================================
    save_name = horzcat('patent_keyword_appear_', num2str(year), '.mat');
    save(save_name, 'patent_keyword_appear')


    disp('---------------------------------------------------------------')
    fprintf('Year %d finished, time: %d seconds \n', year, round(toc))
    disp('---------------------------------------------------------------')


end



%% End
% ======================================================================
disp('*** end ***')
