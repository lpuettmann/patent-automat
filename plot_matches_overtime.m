close all
clear all
clc


%% Define parameters
year_start = 1976;
year_end = 2001;


%% Load summary data
load('total_matches_week_1976-2001')



%% Make time series plot of matches per week
color1_pick = [0.7900, 0.3800, 0.500];
my_gray = [0.806, 0.806, 0.806];

% figureHandle = figure;
plot(allyear_total_matches_week, 'Color', color1_pick, 'LineWidth', 0.8, ...
    'Marker', 'o', 'MarkerSize', 2, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title_phrase = sprintf(['Number of weekly occurences of keyword "automat" ', ...
    'in US patents, %d-%d'], year_start, year_end);
title(title_phrase, 'FontSize', 14, 'FontWeight', 'bold')
set(gca,'TickDir','out')  
box off
set(gcf, 'Color', 'w');
xlim([1 length(allyear_total_matches_week)])
set(gca, 'XTick', ix_new_year) % Set the x-axis tick labels
set(gca, 'xticklabel',{}) % turn x-axis labels off
gridxy(get(gca,'xtick'), get(gca,'ytick'), 'color', my_gray, 'linewidth', 1) % make grey grid lines



% Version 2: HP filter
% figureHandle = figure;
% % plot(allyear_total_matches_week, 'Color', 'white', 'LineWidth', 0.8, ...
% %     'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
% set(gca,'FontSize',12) % change default font size of axis labels
% title_phrase = sprintf(['HP filtered trend of keyword "automat" ', ...
%     'in US patents, %d-%d'], year_start, year_end);
% title(title_phrase, 'FontSize', 14, 'FontWeight', 'bold')
% set(gca,'TickDir','out') 
% box off
% set(gcf, 'Color', 'w');
% hold on
% [total_matches_trend, ~] = hpfilter(allyear_total_matches_week, 5000);
% plot(total_matches_trend, 'Color', color1_pick, 'LineWidth', 1.5)
% % Set the x-axis tick labels
% xlim([1 length(allyear_total_matches_week)])
% set(gca, 'XTick', ix_new_year)
% set(gca, 'xticklabel',{})
% % Make grey grid lines
% gridxy(get(gca,'xtick'), get(gca,'ytick'), 'color', my_gray, 'linewidth', 1)
% 
% 
% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 1300 700]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('keyword_matches_weekly_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

