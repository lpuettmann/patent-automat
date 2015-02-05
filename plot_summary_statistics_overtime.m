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



%% Plot total number of identified patents per year
pick_plot_series = patent_match_summary.nr_patents_yr;

figureHandle = figure;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title_phrase = sprintf(['Number of identified US patents per year', ...
    ', %d-%d'], year_start, year_end);
title(title_phrase, 'FontSize', 14, 'FontWeight', 'bold')
box off
set(gcf, 'Color', 'w');
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off


%% Plot: mean number of matches per year
pick_plot_series = patent_match_summary.mean_patents_yr;

figureHandle = figure;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title_phrase = sprintf(['Mean number of keyword matches per patent', ...
    ', %d-%d'], year_start, year_end);
title(title_phrase, 'FontSize', 14, 'FontWeight', 'bold')
box off
set(gcf, 'Color', 'w');
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off


%% Plot: maximum number of matches per year
pick_plot_series = patent_match_summary.max_patents_yr;

figureHandle = figure;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title_phrase = sprintf(['Maximum number of keyword matches per patent', ...
    ', %d-%d'], year_start, year_end);
title(title_phrase, 'FontSize', 14, 'FontWeight', 'bold')
box off
set(gcf, 'Color', 'w');
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off


%% Plot: distinct patent matches
pick_plot_series = patent_match_summary.nr_distinct_patents_hits;

figureHandle = figure;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title_phrase = sprintf(['Number of distinct patents that contain keyword', ...
    ', %d-%d'], year_start, year_end);
title(title_phrase, 'FontSize', 14, 'FontWeight', 'bold')
box off
set(gcf, 'Color', 'w');
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off


%% Plot: 99 percentile
pick_plot_series = patent_match_summary.perc_99;

figureHandle = figure;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title_phrase = sprintf(['Cutoff for the 99th percentile', ...
    ', %d-%d'], year_start, year_end);
title(title_phrase, 'FontSize', 14, 'FontWeight', 'bold')
box off
set(gcf, 'Color', 'w');
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off






