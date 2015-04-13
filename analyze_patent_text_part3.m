close all
clear all





%% Add path to functions
addpath('functions');
addpath('patent_index');



%% Set some inputs

% Define keyword to look for
find_str = 'automat'; 

year_start = 2010;
year_end = 2011;





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

    
    % Load patent_index for year
    % -------------------------------------------------------------------
    build_load_filename = horzcat('patent_index_', num2str(ix_year), ...
        '.mat');
    load(build_load_filename)

    
    % Iterate through files of weekly patent grant text data
    % -------------------------------------------------------------------
    fprintf('Start searching through patent grant texts for year %d:\n', ix_year)
    
    for ix_week = week_start:week_end
        % Get the index position of patent and the WKU number
        % ----------------------------------------------------------------
        patent_number = pat_ix{ix_week, 1};
        ix_find = pat_ix{ix_week, 2};
        nr_patents = length(patent_number);   
        
        
        choose_file_open = filenames{ix_week};


        % Load the patent text
        unique_file_identifier = fopen(choose_file_open, 'r');   

        if unique_file_identifier == -1
            warning('Matlab cannot open the file')
        end

        open_file_aux = textscan(unique_file_identifier, '%s', ...
            'delimiter', '\n');
        search_corpus = open_file_aux{1,1};


        % Extract patent text
        % ----------------------------------------------------------------
        nr_keyword_appear = patent_number;

        % Get empty cells next to the WKU patent numbers. 
        nr_keyword_appear{1,2} = []; % column for keyword matches
        
        classification_nr = pat_ix{ix_week, 3};
        
        classification_nr = classification_nr'; % DELETE ME

        % Column for OCL classifications
        nr_keyword_appear(:,3) = classification_nr; 


        % Insert the current week for later reference
        nr_keyword_appear = [nr_keyword_appear, ...
            num2cell(repmat(ix_week, nr_patents, 1))];
        
        
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

            % Search for keyword
            % ------------------------------------------------------------
            check_keyword_find = regexpi(patent_text_corpus, find_str);
            
            % Get the start of the keyword match on every line
            line_hit_keyword_find = check_keyword_find(~cellfun('isempty', ...
                check_keyword_find));
            
              % Count the number of appearances of the keyword
            nr_keyword_find = count_elements_cell(line_hit_keyword_find);
            
            % Stack weekly information underneath
            % ------------------------------------------------------------
            nr_keyword_appear{ix_patent, 2} = nr_keyword_find;
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

    
    % Save to .mat file
    % -------------------------------------------------------------------
    save_name = horzcat('patent_keyword_appear_', num2str(ix_year), '.mat');
    matfile_path_save = fullfile('matches', save_name);
    save(matfile_path_save, 'patent_keyword_appear');    
    fprintf('Saved: %s.\n', save_name)
    
    year_loop_time = toc;
    disp('---------------------------------------------------------------')
    fprintf('Year %d finished, time: %d seconds (%d minutes)\n', ...
        ix_year, round(year_loop_time), round(year_loop_time/60))
    disp('---------------------------------------------------------------')
end



%% End
% ======================================================================
disp('*** end ***')
