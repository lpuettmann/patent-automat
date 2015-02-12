clc
clear all
close all


%% Add path to functions
addpath('functions');
addpath('patent_index');


%% Load summary data
load('patent_index_1976-1977')


%% Set some inputs

% Define keyword to look for
find_str = 'automat'; 

year_start = 1976;
year_end = 1977;



%% Go
% ========================================================================
for ix_year = year_start:year_end
    tic

    week_start = 1;

    % Determine if there are 52 or 53 weeks in year 
    week_end = set_weekend(ix_year); 
    
    % Build path to data
    build_data_path = horzcat('.\data\', num2str(ix_year));
    addpath(build_data_path);

    
    % Get names of files
    % -------------------------------------------------------------------
    liststruct = dir(build_data_path);
    filenames = {liststruct.name};
    filenames = filenames(3:end)'; % truncate first elements . and ..


    % Extract year data from patent index
    % -------------------------------------------------------------------
    pat_ix_yearly = pat_ix{ix_year - year_start + 1};
    
    
    % Iterate through files of weekly patent grant text data
    % -------------------------------------------------------------------
    fprintf('* Enter loop for year %d\n', ix_year)

    for ix_week = week_start:week_end
        choose_file_open = filenames{ix_week};

        % Load the patent text
        % ----------------------------------------------------------------
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

        
        % Get the index position of patent and the WKU number
        % ----------------------------------------------------------------
        patent_number = pat_ix_yearly{ix_week, 1};
        ix_find = pat_ix_yearly{ix_week, 2};
        
        nr_patents = length(patent_number);
        
        
        % Extract patent text
        % ----------------------------------------------------------------
        nr_keyword_appear = patent_number;

        % Get empty cells next to the WKU patent numbers. 
        nr_keyword_appear{1,2} = []; % column for keyword matches
        nr_keyword_appear{1,3} = []; % column for OCL classifications


        % Insert the current week for later reference
        nr_keyword_appear = [nr_keyword_appear, ...
            num2cell(repmat(ix_week, nr_patents, 1))];


        for ix_patent=1:nr_patents

            % Get start and end of patent text
            % ------------------------------------------------------------
            start_text_corpus = ix_find(ix_patent);

            if ix_patent < nr_patents
                end_text_corpus = ix_find(ix_patent+1)-1;
            else
                end_text_corpus = length(search_corpus);
            end

            patent_text_corpus = search_corpus(start_text_corpus:...
                end_text_corpus, :);

            % Search for keyword
            % ------------------------------------------------------------
            ix_keyword_find = regexpi(patent_text_corpus, find_str);
            ix_keyword_find = ix_keyword_find(~cellfun('isempty', ...
                ix_keyword_find));
            nr_keyword_find = length(ix_keyword_find);
            
            % Look up OCL (tech classification)
            % ------------------------------------------------------------
            ix_find_OCL = strfind(patent_text_corpus, 'OCL');
            all_OCL_matches = find(~cellfun(@isempty,ix_find_OCL));
            row_OCL_class = patent_text_corpus{all_OCL_matches(1)};
            patent_OCL_class = row_OCL_class(5:numel(row_OCL_class));
            
            % Stack weekly information underneath
            % ------------------------------------------------------------
            nr_keyword_appear{ix_patent, 2} = nr_keyword_find;
            nr_keyword_appear{ix_patent, 3} = patent_OCL_class;
        end

        % Save information for all weeks
        % ----------------------------------------------------------------
        % On first iteration: have to newly define this variable
        if ix_week == week_start 
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

    
    % Save
    % ----------------------------------------------------------------
    save_name = horzcat('patent_keyword_appear_', num2str(ix_year), '.mat');
    save(save_name, 'patent_keyword_appear')


    disp('---------------------------------------------------------------')
    fprintf('Year %d finished, time: %d seconds \n', ix_year, round(toc))
    disp('---------------------------------------------------------------')
end



%% End
% ======================================================================
disp('*** end ***')
