close all
clear all
clc

% Define parameters
year_start = 1976;
year_end = 2001;


% Load summary data
load('patent_match_summary_1976-2001')


% Some settings for the plots
plot_time = year_start:year_end;
color1_pick = [0.7900, 0.3800, 0.500];
my_gray = [0.6706, 0.6706, 0.6706];

% Give both subplots on mean matches the same scale
mean_y_axis_limit = [0.5, 1.5];


figureHandle = figure;


% Plot total number of identified patents per year
subplot(3, 2, 1)
pick_plot_series = patent_match_summary.nr_patents_yr;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title('Number of identified US patents per year', 'FontSize', 14, 'FontWeight', 'bold')
box off
xlim([year_start year_end])
set(gca,'TickDir','out') 
% set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off

get(gca, 'YTickLabel')
new_yticks = {'0'; '100,000'; '200,000'; '300,000'};
set(gca, 'yticklabel', new_yticks); 

%gridxy(get(gca,'xtick'), get(gca,'ytick'), 'color', my_gray, 'linewidth', 1) % make grey grid lines



% Plot: distinct patent matches
subplot(3, 2, 2)
pick_plot_series = patent_match_summary.nr_distinct_patents_hits;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title('Number of distinct patents that contain keyword', 'FontSize', 14, 'FontWeight', 'bold')
box off
xlim([year_start year_end])
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off
get(gca, 'YTickLabel')
ylim([0 50000])
new_yticks = {'0'; '10,000'; '20,000'; '30,000'; '40,000'; '50,000'};
set(gca, 'yticklabel', new_yticks); 


% Plot: maximum number of matches per patent per year
subplot(3, 2, 3)
pick_plot_series = patent_match_summary.max_patents_yr;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title('Maximum number of keyword matches per patent per year', 'FontSize', 14, 'FontWeight', 'bold')
box off
xlim([year_start year_end])
%set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off



% Plot: mean number of matches per year
subplot(3, 2, 4)
pick_plot_series = patent_match_summary.mean_patents_yr;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title('Mean number of keyword matches per patent', 'FontSize', 14, 'FontWeight', 'bold')
box off
ylim(mean_y_axis_limit)
xlim([year_start year_end])
%set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off



% Plot: 99 percentile
subplot(3, 2, 5)
pick_plot_series = patent_match_summary.perc_99;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title('Cutoff for the 99th percentile', 'FontSize', 14, 'FontWeight', 'bold')
box off
ylim([0 max(pick_plot_series)+6])
xlim([year_start year_end])
%set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off



% Plot: mean of matches truncated above 99th percentile
subplot(3, 2, 6)
pick_plot_series = patent_match_summary.trunc_mean;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title('Mean matches per patent below 99th percentile', 'FontSize', 14, 'FontWeight', 'bold')
box off
ylim(mean_y_axis_limit)
xlim([year_start year_end])
%set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off


% General settings
set(gcf, 'Color', 'w');


% Export
set(gcf, 'Position', [100 200 1500 1500]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])
print_pdf_name = horzcat('summary_identified_patents_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

