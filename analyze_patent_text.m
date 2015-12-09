function patent_keyword_appear = analyze_patent_text(ix_year, ...
    find_dictionary)

% Save dictionary (to keep all information at one place)
patent_keyword_appear.dictionary = find_dictionary;

% Customize file type settings (ftset)
ftset = customize_ftset(ix_year);
   
% Initalize
patent_metadata = []; 
nr_keyword_appear = [];  
save_line_keywordNAM = [];  

tic

week_start = 1;

% Determine if there are 52 or 53 weeks in year
week_end = set_weekend(ix_year); 

% Add path to data and get a list with filenames for the year
filenames = get_filenames(ix_year, week_start, week_end);


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
    ix_patentfind = pat_ix{ix_week, 2};
    show_row_NAM = pat_ix{ix_week, 3};
    nr_patents = length(patent_number);   

    % Load the patent text
    choose_file_open = filenames{ix_week};
    unique_file_identifier = fopen(choose_file_open, 'r');   

    if unique_file_identifier == -1
        warning('Matlab cannot open the file')
    end

    open_file_aux = textscan(unique_file_identifier, '%s', ...
        'delimiter', '\n');
    search_corpus = open_file_aux{1,1};


    % Extract patent text
    % ----------------------------------------------------------------
    weekly_metadata = patent_number;
    
    % Column for USPC technology classification numbers
    weekly_metadata(:, 2) = pat_ix{ix_week, 3};

    % Insert the current week for later reference
    weekly_metadata = [weekly_metadata, num2cell(repmat(ix_week, ...
        nr_patents, 1))];
    
    % IPC technology classification numbers
    weekly_metadata = [weekly_metadata, pat_ix{ix_week, 5}];

    % Initialize matrix to count number of keyword appearances
    weekly_keyword_appear = zeros(nr_patents, length(find_dictionary));

    for ix_patent=1:nr_patents

        % Get start and end of patent text
        % ------------------------------------------------------------
        patent_text_corpus = get_patent_text_corpus(ix_patentfind, ...
            ix_patent, nr_patents, ftset, search_corpus);
        
        % Extract title, abstract and text of the patent body
        % ------------------------------------------------------------
        patparts = extract_patent_parts(patent_text_corpus, ftset);
        patparts_names = fieldnames( patparts );
        
        for i=1:length( patparts_names )
            patpart_corpus = patparts.(patparts_names{i});
            
            for f=1:length(find_dictionary)
                find_str = find_dictionary{f};

                % Search for keyword
                % ---------------------------------------------------------
                check_keyword_find = regexpi(patpart_corpus, find_str);

                if iscell(check_keyword_find)
                    % Get the start of the keyword match on every line
                    line_hit_keyword_find = delete_empty_cells( ...
                        check_keyword_find);
                    
                    % Count the number of appearances of the keyword
                    nr_keyword_find = count_elements_cell( ...
                        line_hit_keyword_find);
                else
                    nr_keyword_find = length(check_keyword_find);
                end


                % Stack weekly information underneath
                % ---------------------------------------------------------
                weekly_keyword_appear(ix_patent, f, i) = nr_keyword_find;
            end
        end
    end

    % Save information for all weeks
    % ----------------------------------------------------------------  
    patent_metadata = [patent_metadata;
                      weekly_metadata];   

    nr_keyword_appear = [nr_keyword_appear;
                        weekly_keyword_appear];

    % Close file again. It can cause errors if you open too many
    % (more than abound 512) files at once.
    fclose(unique_file_identifier);

    check_open_files

    fprintf('[%d] Week finished: %d/%d.\n', ix_year, ix_week, week_end)
end

patent_keyword_appear.patentnr = patent_metadata(:,1);
patent_keyword_appear.classnr_uspc = patent_metadata(:,2); % USPC tech classification number
patent_keyword_appear.week = patent_metadata(:,3);
patent_keyword_appear.classnr_ipc = patent_metadata(:,4); % IPC tech classification number
patent_keyword_appear.title_matches = nr_keyword_appear(:, :, 1);
patent_keyword_appear.abstract_matches = nr_keyword_appear(:, :, 2);
patent_keyword_appear.body_matches = nr_keyword_appear(:, :, 3);
