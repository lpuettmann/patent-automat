clc
clear all
close all


addpath('functions');
addpath('data');
addpath('data\1982');

tic


%% Choose year
% ========================================================================
year = 1982;
week_start = 1; % default: 42
week_end = 52; % this can be the same as week_start

%% Define keyword to look for
% ========================================================================
% use a dot as a place holder (probably not necessary at the moment)
find_str = 'automat'; 



%% Get names of files
% ========================================================================
liststruct = dir('D:\US_PatentsData\analyzing_PatentText\data\1982');
filenames = {liststruct.name};
filenames = filenames(3:end)'; % truncate first elements . and ..




%% ITERATE THROUGH WEEKS
% ========================================================================
for ix_week = week_start:week_end
    pick_week = ix_week; 
    choose_file_open = filenames{pick_week};


    % Load the patent text
    % ========================================================================
    open_file_aux = textscan(fopen(choose_file_open, 'r'), '%s', ...
        'delimiter', '\n');
    file_str = open_file_aux{1,1};


    % Define new search corpus as we might change some things about this
    search_corpus = file_str; 



    % Eliminate the name section from the search corpus
    % % ========================================================================
    ix_find_NAM = strfind(file_str,'NAM');
    show_row_NAM = find(~cellfun(@isempty,ix_find_NAM));

    search_corpus(show_row_NAM) = []; % delete rows with NAN

    % Test if we get the right number of rows
    if length(file_str)-length(search_corpus) ~= length(show_row_NAM)
        warning(['Are you sure you deleted the right columns with ', ...
            'NAM in them?'])
    end



    % Count number of patents in a given week
    % ========================================================================

    % Count number of appearances of 'PATN'
    % ------------------------------------------------------------------------
    [indic_find, nr_patents, ix_find] = count_nr_patents(search_corpus, 'PATN');


    % Pre-define empty cell array to store patent WKU numbers (based on finding) PATN
    patent_number = repmat({''}, nr_patents, 1);

    for i=1:nr_patents
         wku_line = search_corpus(ix_find(i)+1, :);
         wku_line = wku_line{1};
         patent_number{i} = wku_line(6:14);
    end



    % Run plausibility check
    % ========================================================================

    % Test if there are any spaces in WKU numbers
    test_contains_space = strfind(patent_number, ' ');
    show_ix_contains_space = find(~cellfun(@isempty,test_contains_space));
    if not(isempty(show_ix_contains_space))
        warning('There is a space in the patent WKU numbers')
    end


    % Test if all WKU numbers are 9 digits long
    test_is9long = cellfun(@length, patent_number);
    test_vector_nines = repmat(9, nr_patents, 1);
    if min(test_is9long == test_vector_nines) < 1
        warning('Not all patent WKU numbers are 9 characters long')
    end


    % Extract patent text
    % ========================================================================

    nr_keyword_appear = patent_number;
    % Get empty cells next to the WKU patent numbers.
    nr_keyword_appear{1,2} = []; 

    for ix_patent=1:nr_patents

        % Get start and end of patent text
        % -------------------------------------------------------------------
        start_text_corpus = ix_find(ix_patent);

        if ix_patent < nr_patents
            end_text_corpus = ix_find(ix_patent+1)-1;
        else
            end_text_corpus = length(search_corpus);
        end

        patent_text_corpus = search_corpus(start_text_corpus:...
            end_text_corpus, :);

        % Search
        % -------------------------------------------------------------------
        ix_keyword_find = regexpi(patent_text_corpus, find_str);
        ix_keyword_find = ix_keyword_find(~cellfun('isempty',ix_keyword_find));
        nr_keyword_find = length(ix_keyword_find);

        % Save
        % -------------------------------------------------------------------
        nr_keyword_appear{ix_patent, 2} = nr_keyword_find;
    end


    nr_keyword_per_patent = cell2mat(nr_keyword_appear(:, 2));


    % Display findings
    % ========================================================================

    % Calculate summary statistics
    total_keywords_found = sum(nr_keyword_per_patent);

    if length(find_str) < 20 % only display if not too long
        fprintf('Number appearances of keystring >>%s<<: %d.\n', find_str, ...
            total_keywords_found)
        disp('---------------------------------------------------------------')
    else
        fprintf('Number appearances of keystring: %d.\n', total_keywords_found)
        disp('---------------------------------------------------------------')
    end



    sorted_summ_list = sort(nr_keyword_per_patent);
    nr_patents_1match = sum(nr_keyword_per_patent == 1);
    nr_patents_2match = sum(nr_keyword_per_patent == 2);
    nr_patents_3match = sum(nr_keyword_per_patent == 3);
    nr_patents_4match = sum(nr_keyword_per_patent == 4);
    nr_patents_5match = sum(nr_keyword_per_patent == 5);
    nr_patents_37match = sum(nr_keyword_per_patent == 37);
    nr_patents_82match = sum(nr_keyword_per_patent == 82);
    nr_patents_180match = sum(nr_keyword_per_patent == 180);

    nonzero_count = nr_keyword_per_patent;
    nonzero_count(nr_keyword_per_patent==0) = [];

    nr_distinct_patents_hits = length(nonzero_count);



    % Make histogram
    % -------------------------------------------------------------------
    color1_pick = [0.7900, 0.3800, 0.500];


    figureHandle = figure;
    hist(nonzero_count, max(nr_keyword_per_patent))
    set(gca,'FontSize',12) % change default font size of axis labels
    title_phrase = sprintf(['Number of appearances of keyword "automat*" ', ...
        'in US patents, 1982 week %s'], choose_file_open(end-5:end-4));
    title(title_phrase, 'FontSize', 14)
    xlabel('Number of patents')
    ylabel_phrase = sprintf(['Number of keyword appearances \n'...
        '(zero matches ommited)']);
    ylabel(ylabel_phrase)
    set(get(gca,'child'), 'FaceColor', color1_pick, 'EdgeColor', color1_pick);
    set(gcf, 'Color', 'w');
    box off


    % Add text arrows to the plot
    arrowannotation = sprintf(['Total patents: %d\n' ...
        'Total number of keyword matches: %d\n' ...
        'Distinct patents with at least one match: %d'], ...
        nr_patents, total_keywords_found, nr_distinct_patents_hits);
    annotation('textbox', [0.5 0.6 0.41 0.14], 'String', arrowannotation, ...
        'FontSize', 12, 'HorizontalAlignment', 'left', ...
        'EdgeColor', 'black'); % [x y w h]


    % Reposition the figure
    % ======================================================================
    set(gcf, 'Position', [200 350 800 500]) % in vector: left bottom width height

    set(figureHandle, 'Units', 'Inches');
    pos = get(figureHandle, 'Position');

    set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
        'Inches', 'PaperSize', [pos(3), pos(4)])


    % Export to pdf
    % ======================================================================
    print_pdf_name = horzcat('nr_keyword_patent_', '1982-', 'week', ...
        num2str(pick_week,'%02d'), '.pdf');

    print(figureHandle, print_pdf_name, '-dpdf', '-r0')
end


%% End
% ======================================================================
toc
disp('*** end ***')
