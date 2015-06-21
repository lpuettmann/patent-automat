close all
clear all

fclose('all')
clc

%% Add path to functions
addpath('functions');
addpath('patent_index');


%% Set some inputs

% Define keyword to look for
find_str = 'automat'; 

year_start = 1976;
year_end = 1976;



%% Go
% ========================================================================
save_line_keywordNAM = []; % initalize

for ix_year = year_start:year_end
    tic

    week_start = 1;

    % Determine if there are 52 or 53 weeks in year 
    week_end = set_weekend(ix_year); 
    
    % Build path to data
    build_data_path = set_data_path(ix_year);
    addpath(build_data_path);

    
    % Get names of files
    % -------------------------------------------------------------------
    liststruct = dir(build_data_path);
    filenames = {liststruct.name};
    filenames = filenames(3:end)'; % truncate first elements . and ..

    filenames = ifmac_truncate_more(filenames);
    
    check_filenames_format(filenames, ix_year, week_start, week_end)
    
    % Load patent_index for year
    % -------------------------------------------------------------------
    build_load_filename = horzcat('patent_index_', num2str(ix_year), ...
        '.mat');
    load(build_load_filename)

    
    % Iterate through files of weekly patent grant text data
    % -------------------------------------------------------------------
    fprintf('Search through patent grant texts for year %d:\n', ix_year)

    for ix_week = week_start:week_end
        
        % Get the index position of patent and the WKU number
        % ----------------------------------------------------------------
        patent_number = pat_ix{ix_week, 1};
        ix_find = pat_ix{ix_week, 2};
        show_row_NAM = pat_ix{ix_week, 3};
        nr_patents = length(patent_number);        

        % Load the patent text
        % ----------------------------------------------------------------
        choose_file_open = filenames{ix_week};
        
        unique_file_identifier = fopen(choose_file_open, 'r');   

        if unique_file_identifier == -1
            warning('Matlab cannot open the file')
        end

        open_file_aux = textscan(unique_file_identifier, '%s', ...
            'delimiter', '\n');
        file_str = open_file_aux{1,1};


        % Define new search corpus as we might change some things about this
        search_corpus = file_str; 
             
        
        % Extract patent text
        % ----------------------------------------------------------------
        nr_keyword_appear = patent_number;

        % Get empty cells next to the WKU patent numbers. 
        nr_keyword_appear{1,2} = []; % column for keyword matches

        classification_nr = pat_ix{ix_week, 3};

        % Column for (OCL) technology classifications
        nr_keyword_appear(:,3) = classification_nr;

        % Insert the current week for later reference
        nr_keyword_appear = [nr_keyword_appear, ...
            num2cell(repmat(ix_week, nr_patents, 1))];
        
        % Make a cell which saves which words are found
        nr_keyword_appear = [nr_keyword_appear, ...
            num2cell(repmat(' ', nr_patents, 1))];


        for ix_patent=1:nr_patents

            % Get start and end of patent text
            % ------------------------------------------------------------
            start_text_corpus = ix_find(ix_patent);

            if ix_patent < nr_patents
                end_text_corpus = ix_find(ix_patent+1)-1; % this number is hard-coded
            else
                end_text_corpus = length(search_corpus);
            end

            patent_text_corpus = search_corpus(start_text_corpus:...
                end_text_corpus, :);
            
            
            % Delete name section (NAM) of inventor and of patent citations
            % ------------------------------------------------------------
            [indic_NAM, ~, ~] = ...
                count_nr_patents_trunccorpus(patent_text_corpus, 'NAM', ...
                3);
            
            nan_lines = patent_text_corpus(indic_NAM);
            check_NAMkeyword = regexpi(nan_lines, find_str);

            line_keywordNAM = nan_lines(not(cellfun('isempty', ...
                check_NAMkeyword)));
            if not(isempty(line_keywordNAM))
                save_line_keywordNAM = [save_line_keywordNAM;
                                        patent_number(ix_patent), ...
                                                line_keywordNAM];
            end
    
            
            % Search for keyword
            % ------------------------------------------------------------
            check_keyword_find = regexpi(patent_text_corpus, find_str);
            
            % Get the start of the keyword match on every line
            line_hit_keyword_find = delete_empty_cells(check_keyword_find);
   
            % Count the number of appearances of the keyword
            nr_keyword_find = count_elements_cell(line_hit_keyword_find);
                       
            % Find the words surrounding the keyword match
            match_fullword = get_fullword_matches(nr_keyword_find, ...
                check_keyword_find, patent_text_corpus, ...
                line_hit_keyword_find);
                        
            % Stack weekly information underneath
            % ------------------------------------------------------------
            nr_keyword_appear{ix_patent, 2} = nr_keyword_find;
            nr_keyword_appear{ix_patent, 5} = match_fullword;
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
        
        
        % Close file again. It can cause errors if you open too many
        % (around 512) files at once.
        fclose(unique_file_identifier);

        check_open_files

        fprintf('Week finished: %d/%d.\n', ix_week, week_end)
        disp('-----------------------------------------------------------')
    end
    
    
    % Save to .mat file
    % -------------------------------------------------------------------
    save_name = horzcat('patent_keyword_appear_', num2str(ix_year), '.mat');
    matfile_path_save = fullfile('matches', save_name);
    save(matfile_path_save, 'patent_keyword_appear');    
    fprintf('Saved: %s.\n', save_name)
        
    
    year_loop_time = toc;
    disp('---------------------------------------------------------------')
    fprintf('Year %d finished, time: %d seconds (%d minutes).\n', ...
        ix_year, round(year_loop_time), round(year_loop_time/60))
    disp('---------------------------------------------------------------')
end



%% End
% ======================================================================
disp('*** end ***')
