close all
clear all
clc



%% Add path to functions
addpath('functions');



%% Set some inputs
year_start = 2005;
year_end = 2005;




%% Go
% ========================================================================
for ix_year = year_start:year_end
    tic

    week_start = 1;

    % Determine if there are 52 or 53 weeks in year
    week_end = set_weekend(ix_year); 
    
    week_end = 3;
    
    build_data_path = horzcat('./data/', num2str(ix_year));
    addpath(build_data_path);


    % Get names of files
    % -------------------------------------------------------------------
    liststruct = dir(build_data_path);
    filenames = {liststruct.name};
    filenames = filenames(3:end)'; % truncate first elements . and ..

    % on Apple: truncate also '.DS_Store'
    if ismac
        disp('Great, you are working on a mac.')
        filenames = filenames(2:end);
    end

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
            warning(['The number of patents (= %d) is implausibly small'], ...
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

        
        
        % Look up OCL (tech classification)
        % ------------------------------------------------------------
        find_class_str = '<B521><PDAT>';
        indic_class_find = regexp(search_corpus, find_class_str);
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
            warning(['Number of classifications (= %d) is implausibly small'], ...
                nr_class)
        end 
        
        class_number = repmat({''}, nr_class, 1);        

        for i=1:nr_class
            class_nr_line = search_corpus(ix_class_find(i), :);
            class_nr_line = class_nr_line{1};
            % Classificiations differ in length, so have to find end
            % where the classification stops.
            class_find_end = regexp(class_nr_line, '</PDAT>'); 
            class_number{i} = class_nr_line(13:class_find_end-1);

            if numel(class_number) < 2
                warning('Something is fishy.')
            end
        end
        
        
        
        % Define patent index. It consists of the patent's WKU number 
        % and its index position in the file. Save information for week in cell array
        % -------------------------------------------------------------------
        pat_ix{ix_week, 1} = patent_number;
        pat_ix{ix_week, 2} = ix_find; % position of patent start
        pat_ix{ix_week, 3} = class_number; % position of patent start

        fprintf('Week finished: %d/%d.\n', ix_week, week_end)
    end

    % Save to .mat file
    % -------------------------------------------------------------------
    save_name = horzcat('patent_index_', num2str(ix_year), '.mat');
    save(save_name, 'pat_ix')
    
    
    disp('---------------------------------------------------------------')
    fprintf('Year %d finished, time: %d seconds \n', ix_year, round(toc))
    disp('---------------------------------------------------------------')
end





%% End
% ======================================================================
toc
disp('*** end ***')
