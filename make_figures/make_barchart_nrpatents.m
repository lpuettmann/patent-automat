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


my_gray = [0.6706, 0.6706, 0.6706];


figureHandle = figure;

% Plot total number of identified patents per year
bar(plot_time, patent_match_summary.nr_patents_yr, 'FaceColor', ...
    color4_pick, 'EdgeColor', 'k')
hold on
bar(plot_time, patent_match_summary.nr_distinct_patents_hits, ...
    'FaceColor', color1_pick, 'EdgeColor', 'k')
hold off

set(gca,'FontSize',12) % change default font size of axis labels
box off
set(gca,'TickDir','out'); 
ylim([0 400000])
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off

get(gca, 'YTickLabel');
new_yticks = {'0'; ''; '100,000'; ''; '200,000'; ''; '300,000'; ''; '400,000'};
set(gca, 'yticklabel', new_yticks); 


% Plot: mean of matches truncated above 99th percentile
% title('D. Mean matches per patent below 99th percentile', 'FontSize', 14)


% General settings
set(gcf, 'Color', 'w');




%% Change position and size
set(gcf, 'Position', [100 200 700 400]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


%% Add text
% text_annotation = 'Total';
% annotation('textbox', [0.9 0.7 0.1 0.1], 'String', text_annotation, ...
%         'FontSize', 12, 'HorizontalAlignment', 'left', ...
%         'EdgeColor', 'none', 'Color', color1_pick); % [x y w h]
% 
% text_annotation = 'Number distinct patents with matches';
% annotation('textbox', [0.9 0.45 0.1 0.1], 'String', text_annotation, ...
%         'FontSize', 12, 'HorizontalAlignment', 'left', ...
%         'EdgeColor', 'none', 'Color', color4_pick); % [x y w h]



%% Export to pdf
print_pdf_name = horzcat('barchart_identified_patents_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

