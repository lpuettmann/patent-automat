close all
clear all
clc



%% Add path to functions
addpath('functions');



%% Set some inputs
year_start = 2003;
year_end = 2003;



%% Go
% ========================================================================
ix_year = year_start
tic

week_start = 1;

% Determine if there are 52 or 53 weeks in year
week_end = set_weekend(ix_year); 

build_data_path = horzcat('.\data2\', num2str(ix_year));
addpath(build_data_path);


% Get names of files
% -------------------------------------------------------------------
liststruct = dir(build_data_path);
filenames = {liststruct.name};
filenames = filenames(3:end)'; % truncate first elements . and ..


% Iterate through files of weekly patent grant text data
% -------------------------------------------------------------------
fprintf('Enter loop for year %d:\n', ix_year)

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


    % Eliminate the name section from the search corpus
    % ----------------------------------------------------------------
    ix_find_NAM = strfind(file_str,'NAM');
    show_row_NAM = find(~cellfun(@isempty,ix_find_NAM));
    search_corpus(show_row_NAM) = []; % delete rows with NAN


    % Count number of patents in a given week
    % --------------------------------------------------------------------

    if ix_year == 2001 % special case: problem with 80 numel text file
        fprintf('*** Enter special case, year: %d, week: %d.\n', ...
              ix_year, ix_week)
        trunc4_corpus

    % Something is wrong in year 1978
    elseif ix_year == 1978 && (ix_week == 25 | ix_week == 26)  
        fprintf('*** Enter special case, year: %d, week: %d.\n', ...
              ix_year, ix_week)
        trunc4_corpus

      elseif ix_year == 1979 && (ix_week == 11 | ix_week == 12)
        fprintf('*** Enter special case, year: %d, week: %d.\n', ...
              ix_year, ix_week)
        trunc4_corpus

      % I can probably delete the following special case: 
      % The problem was with the empty lines in week 50

     elseif ix_year == 1984 && (ix_week == 1 | ix_week == 49 | ix_week == 50) 
         fprintf('*** Enter special case, year: %d, week: %d.\n', ...
             ix_year, ix_week)
        trunc4_corpus

    elseif ix_year == 1997 && (ix_week >= 38) 
        fprintf('*** Enter special case, year: %d, week: %d.\n', ...
              ix_year, ix_week)
        trunc4_corpus

    elseif ix_year == 1998
        fprintf('*** Enter special case, year: %d, week: %d.\n', ...
              ix_year, ix_week)
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
    if ix_year == 1999 && ix_week == 14
        fprintf('Delete patent number %d.\n', ...
            show_ix_contains_space)
        patent_number(show_ix_contains_space) = [];
        ix_find(show_ix_contains_space) = [];
        nr_patents = nr_patents - 1;
    elseif ix_year == 2001 && (ix_week == 10 | ix_week == 26 | ix_week == 40 | ix_week==52) 
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

    % Define patent index. It consists of the patent's WKU number 
    % and its index position in the file. Save information for week in cell array
    % -------------------------------------------------------------------
    pat_ix_weekly{ix_week, 1} = patent_number;
    pat_ix_weekly{ix_week, 2} = ix_find; % position of patent start
    pat_ix_weekly{ix_week, 3} = show_row_NAM; % save which rows deleted

    fprintf('Week finished: %d/%d.\n', ix_week, week_end)
end

pat_ix{ix_year - year_start + 1, 1} = pat_ix_weekly;


disp('---------------------------------------------------------------')
fprintf('Year %d finished, time: %d seconds \n', ix_year, round(toc))
disp('---------------------------------------------------------------')



%% End
% ======================================================================
disp('*** end ***')