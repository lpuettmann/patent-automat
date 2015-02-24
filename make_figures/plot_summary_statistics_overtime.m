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
subplot(2, 1, 1)
bar(plot_time, patent_match_summary.nr_patents_yr, 'FaceColor', ...
    color4_pick, 'EdgeColor', 'k')
hold on
bar(plot_time, patent_match_summary.nr_distinct_patents_hits, ...
    'FaceColor', color1_pick, 'EdgeColor', 'k')
hold off

set(gca,'FontSize',12) % change default font size of axis labels
title('Number of identified US patents per year', 'FontSize', 14)
box off
set(gca,'TickDir','out'); 
ylim([0 400000])
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off

get(gca, 'YTickLabel');
new_yticks = {'0'; ''; '100,000'; ''; '200,000'; ''; '300,000'; ''; '400,000'};
set(gca, 'yticklabel', new_yticks); 



% Plot: mean number of matches per year
subplot(2, 1, 2)
pick_plot_series = patent_match_summary.mean_patents_yr;
plot(plot_time, pick_plot_series, 'Color', color2_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 4.5, 'MarkerFaceColor', color2_pick)
hold on
pick_plot_series = patent_match_summary.trunc_mean;
plot(plot_time, pick_plot_series, 'Color', color2_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 4.5, 'MarkerFaceColor', color2_pick)
hold off
set(gca,'TickDir','out'); 
set(gca,'FontSize',12) % change default font size of axis labels
title('Mean number of keyword matches per patent', 'FontSize', 14)
box off


% Plot: mean of matches truncated above 99th percentile
% title('D. Mean matches per patent below 99th percentile', 'FontSize', 14)


% General settings
set(gcf, 'Color', 'w');




%% Change position and size
set(gcf, 'Position', [100 200 900 600]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


%% Add text
% annotation('textbox', [0.21 0.14 0.1 0.1], 'String', '0.93', ...
%         'FontSize', 12, 'HorizontalAlignment', 'left', ...
%         'EdgeColor', 'none', 'Color', color2_pick); % [x y w h]
% 
% annotation('textbox', [0.41 0.335 0.1 0.1], 'String', '1.3', ...
%         'FontSize', 12, 'HorizontalAlignment', 'left', ...
%         'EdgeColor', 'none', 'Color', color2_pick); % [x y w h]
% 
% annotation('textbox', [0.67 0.05 0.1 0.1], 'String', '0.61', ...
%         'FontSize', 12, 'HorizontalAlignment', 'left', ...
%         'EdgeColor', 'none', 'Color', color2_pick); % [x y w h]
% 
% annotation('textbox', [0.85 0.175 0.1 0.1], 'String', '0.86', ...
%         'FontSize', 12, 'HorizontalAlignment', 'left', ...
%         'EdgeColor', 'none', 'Color', color2_pick); % [x y w h]


%% Export to pdf
print_pdf_name = horzcat('summary_identified_patents_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

