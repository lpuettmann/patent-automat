function patent_keyword_appear = analyze_patent_text(ix_year, ...
    find_dictionary)

% Save dictionary (to keep all information at one place)
patent_keyword_appear.dictionary = find_dictionary;

% Customize file type settings (ftset)
if (ix_year < 2002) && (ix_year > 1975)
    ftset.indic_filetype = 1;
    ftset.nr_lines4previouspatent = 1;
    ftset.nr_trunc = 4;
    
elseif (ix_year >=2002) && (ix_year < 2005)
    ftset.indic_filetype = 2;
    ftset.nr_lines4previouspatent = 2;
    
elseif (ix_year >=2005) && (ix_year < 2016)
    ftset.indic_filetype = 3;
    ftset.nr_lines4previouspatent = 1;
    
else
    warning('The codes are not designed for year: %d.', ix_year)
end
   
% Initalize
patent_metadata = []; 
nr_keyword_appear = [];  
save_line_keywordNAM = [];  

tic

week_start = 1;
week_start = 12
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
    
    % Column for technology classification numbers
    weekly_metadata(:, 2) = pat_ix{ix_week, 3};

    % Insert the current week for later reference
    weekly_metadata = [weekly_metadata, num2cell(repmat(ix_week, ...
        nr_patents, 1))];

    % Initialize matrix to count number of keyword appearances
    weekly_keyword_appear = zeros(nr_patents, length(find_dictionary));

    for ix_patent=1:nr_patents

        % Get start and end of patent text
        % ------------------------------------------------------------
        patent_text_corpus = get_patent_text_corpus(ix_patentfind, ...
            ix_patent, nr_patents, ftset, search_corpus);
        
        patxt_trunc = truncate_corpus(patent_text_corpus, ftset.nr_trunc);

        % Get title
        [~, nr_find, ix_find] = count_occurences(patxt_trunc, 'TTL ');
        if nr_find > 1
            % If shows up more than once, keep only first occurence as the
            % title occurs near the top of the patent.
            ix_find = ix_find(1);
        elseif nr_find == 0
            warning('No string found.')
        end

        title_line = patent_text_corpus{ix_find, :};
        title_str = title_line(6:end);

        % Get abstract
        [~, nr_find, ix_abstractstart] = count_occurences(patxt_trunc, ...
            'ABST');
        if nr_find > 1
            % If shows up more than once, keep only first occurence as the
            % abstract occurs near the top of the patent.
            ix_abstractstart = ix_abstractstart(1);
        end
        
            
        if nr_find == 0
            abstract_str = ' ';
        else
            dict_abstract_end = {'BSUM', 'PARN', 'PAC '};

            for d=1:length(dict_abstract_end)
                find_str = dict_abstract_end{d};
                [~, nr_absEnd(d), ix_absEnd{d}] = ...
                    count_occurences(patxt_trunc, find_str);
            end

            if max(nr_absEnd) == 0       
                % If we cannot determine where the abstract ends, then just
                % take the first 10 lines or until end of patent.
                
                shortEndAbs = min(size(patent_text_corpus( ... 
                    ix_abstractstart + 1:end, :), 1), 11);
                ix_abstractend = ix_abstractstart + shortEndAbs;

            else

                min_absEnd = [];
                for i=1:length(dict_abstract_end)
                    pick_absEnd = ix_absEnd{i};
                    min_absEnd = [min_absEnd;
                                    pick_absEnd(pick_absEnd > ...
                                    ix_abstractstart)];
                end

                if isempty( min_absEnd )
                    warning('Should not be empty.')
                end

                ix_abstractend = min(min_absEnd);
            end

            if isnan( ix_abstractend )
                warning('ix_abstractend is Nan.')
            elseif isempty( ix_abstractend )
                ('ix_abstractend is empty.')
            end

            abstract_str = patent_text_corpus(ix_abstractstart + 1 : ...
                ix_abstractend - 1, :);
        end

        [~, ~, ix_bodystart] = count_occurences(patxt_trunc, 'BSUM');
        
        if isempty( ix_bodystart )
            body_str = ' ';
        else
            body_str = patent_text_corpus(ix_bodystart + 1 : end);
        end

        patparts = {title_str, abstract_str, body_str};
        
        for i=1:length(patparts)
            patpart_corpus = patparts{i};
            
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
patent_keyword_appear.classnr = patent_metadata(:,2);
patent_keyword_appear.week = patent_metadata(:,3);
patent_keyword_appear.title_matches = nr_keyword_appear(:, :, 1);
patent_keyword_appear.abstract_matches = nr_keyword_appear(:, :, 2);
patent_keyword_appear.body_matches = nr_keyword_appear(:, :, 3);
