close all
%clear all
clc


addpath('functions');

%% Define parameters
year_start = 1976;
year_end = 2001;


%% Load summary data
load('total_matches_week_1976-2001')



%% Make time series plot of matches per week
% my_xaxis_labels = {1976; 1977; 1978; 1979; 1980; 1981; 1982; 1983; 1984; 1985; 1986; 1987; 1988; 1989; 1990; 1991; 1992; 1993; 1994; 1995; 1996; 1997; 1998; 1999; 2000; 2001};
% my_xaxis_labels = {1976; ''; 1978; ''; 1980; ''; 1982; ''; 1984; ''; 1986; ''; 1988; ''; 1990; ''; 1992; ''; 1994; ''; 1996; ''; 1998; ''; 2000; ''};
my_xaxis_labels = {1976; ''; ''; ''; 1980; ''; ''; ''; ''; 1985; ''; ''; ''; ''; 1990; ''; ''; ''; ''; 1995; ''; ''; ''; ''; ''; 2001;};



color1_pick = [0.7900, 0.3800, 0.500];
my_gray = [0.806, 0.806, 0.806];

figureHandle = figure;
hold('on')
% fig.GraphicsSmoothing = 'off';
% hx = plot(allyear_total_matches_week, 'Color', 'white', 'LineWidth', 0.8, ...
%     'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick);

scatter(1:length(allyear_total_matches_week), allyear_total_matches_week, ...
    'Marker', 'o', 'MarkerEdgeColor', color1_pick)


set(gca,'FontSize',11) % change default font size of axis labels
title_phrase = sprintf(['A. Number of weekly occurences ', ...
    'in US patents']);

title(title_phrase, 'FontSize', 11, ...
    'Units', 'normalized', ...
    'Position', [0.365 1.1], ...
    'HorizontalAlignment', 'right')

set(gca,'TickDir','out')  
box off
set(gcf, 'Color', 'w');
xlim([1 length(allyear_total_matches_week)])
set(gca, 'XTick', ix_new_year) % Set the x-axis tick labels
set(gca, 'xticklabel',{}) % turn x-axis labels off
% gridxy(get(gca,'xtick'), get(gca,'ytick'), 'color', my_gray, 'linewidth', 1) % make grey grid lines
set(gca, 'xticklabel', my_xaxis_labels); 





% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 800 500]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('keyword_matches_weekly_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

