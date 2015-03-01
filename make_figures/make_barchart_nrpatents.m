close all
clear all
clc

% Define parameters
year_start = 1976;
year_end = 2014;





%% Load summary data
build_load_filename = horzcat('patent_match_summary_', num2str(year_start), ...
    '-', num2str(year_end), '.mat');
load(build_load_filename)


%% Print some summaries
fprintf('Total number of identified patents all years: %d.\n', ...
    sum(patent_match_summary.nr_patents_yr))



%% Some settings for the plots
plot_time = year_start:year_end;
color1_pick = [0.7900, 0.3800, 0.500];
color2_pick = [0.000,0.639,0.561];
color3_pick = [0.890,0.412,0.525];
color4_pick = [0.890,0.412,0.525];


my_light_gray = [0.95, 0.95, 0.95];
my_dark_gray = [0.8, 0.8, 0.8];


figureHandle = figure;

% Plot total number of identified patents per year
bar(plot_time, patent_match_summary.nr_patents_yr, 'FaceColor', ...
    my_light_gray, 'EdgeColor', 'k')
hold on
bar(plot_time, patent_match_summary.nr_distinct_patents_hits, ...
    'FaceColor', my_dark_gray, 'EdgeColor', 'k')
hold off

set(gca,'FontSize',12) % change default font size of axis labels
box off
set(gca,'TickDir','out'); 
ylim([0 400000])
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off

get(gca, 'YTickLabel');
new_yticks = {'0'; ''; '100000'; ''; '200000'; ''; '300000'; ''; '400000'};
set(gca, 'yticklabel', new_yticks); 



% General settings
set(gcf, 'Color', 'w');

set(0,'DefaultTextFontName','Palatino') % set font
set(0,'DefaultAxesFontName','Palatino') % set font




%% Change position and size
set(gcf, 'Position', [100 200 700 400]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


%% Add text
annotation('textbox', [0.135 0.23 0.1 0.1], 'String', '70900', ...
        'FontSize', 12, 'HorizontalAlignment', 'left', ...
        'EdgeColor', 'none'); % [x y w h]

annotation('textbox', [0.85 0.75 0.1 0.1], 'String', '327000', ...
        'FontSize', 12, 'HorizontalAlignment', 'left', ...
        'EdgeColor', 'none'); % [x y w h]



%% Export to pdf
print_pdf_name = horzcat('barchart_identified_patents_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
