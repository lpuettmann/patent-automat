close all
clear all
clc

% Define parameters
year_start = 1976;
year_end = 2015;


% Load summary data
load('named_patents_stats')



%% Set font
set(0,'DefaultTextFontName','Palatino')
set(0,'DefaultAxesFontName','Palatino')


%% Plot

% Some settings for the plots
plot_time = year_start:year_end;
color1_pick = [0.7900, 0.3800, 0.500];
color2_pick = [0.000,0.639,0.561];
color3_pick = [0.890,0.412,0.525];



figureHandle = figure;

plot_series = share_w_letter*100;


plot(plot_time, plot_series, 'Color', color3_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color3_pick)

set(gca,'TickDir','out'); 
box off
set(gca,'FontSize',12) % change default font size of axis labels
set(gcf, 'Color', 'w');
xlim([year_start year_end]);
% ylim([0 ceil(max(plot_series))])
ylim([0 100])
ylabel('percentage (%)')



%% Change position and size
set(gcf, 'Position', [100 200 600 400]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


%% Export to pdf
print_pdf_name = horzcat('named_patent_nr_stats_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')


