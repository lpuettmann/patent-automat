close all
clear all
clc


addpath('matches');
addpath('functions');


%% Define parameters
% ========================================================================
find_str = 'automat'; 


for year=1976:2001

    
    %% Load matches
    % ========================================================================
    load_file_name = horzcat('patent_keyword_appear_', num2str(year));
    load(load_file_name)


    %% Display findings
    % ========================================================================
    nr_keyword_per_patent = cell2mat(patent_keyword_appear(:, 2));

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


    mean_keyword_per_patent = mean(nr_keyword_per_patent);
    median_keyword_per_patent = median(nr_keyword_per_patent);

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
    title_phrase = sprintf(['Number of appearances of keyword "automat" ', ...
        'in US patents, %d'], year);
    title(title_phrase, 'FontSize', 14)
    xlabel('Number of patents')
    ylabel_phrase = sprintf(['Number of keyword appearances \n'...
        '(zero matches ommited)']);
    ylabel(ylabel_phrase)
    set(get(gca,'child'), 'FaceColor', 'none', 'EdgeColor', color1_pick);
    set(gcf, 'Color', 'w');
    box off


    % Add text arrows to the plot
    arrowannotation = sprintf(['Total patents: %d\n' ...
        'Total number of keyword matches: %d\n' ...
        'Distinct patents with at least one match: %d\n', ...
        'Mean matches per patent: %s\n' ...
        'Median matches per patent: %d'], ...
        size(patent_keyword_appear,1), total_keywords_found, ...
        nr_distinct_patents_hits, num2str(round2(mean_keyword_per_patent,0.01)), ...
        median_keyword_per_patent);
    annotation('textbox', [0.5 0.6 0.44 0.21], 'String', arrowannotation, ...
        'FontSize', 12, 'HorizontalAlignment', 'left', ...
        'EdgeColor', 'black'); % [x y w h]


    % Reposition the figure
    % -----------------------------------------------------------------------
    set(gcf, 'Position', [200 350 800 500]) % in vector: left bottom width height

    set(figureHandle, 'Units', 'Inches');
    pos = get(figureHandle, 'Position');

    set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
        'Inches', 'PaperSize', [pos(3), pos(4)])


    % Export to pdf
    % -----------------------------------------------------------------------
    print_pdf_name = horzcat('nr_keyword_patent_', num2str(year), '.pdf');
    print(figureHandle, print_pdf_name, '-dpdf', '-r0')
end
