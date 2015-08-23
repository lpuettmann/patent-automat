function plot_alg1_overtime(year_start, year_end)

%%
% Set font
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')


% Load summary data
build_load_filename = horzcat('allyr_patstats_', num2str(year_start), ...
    '-', num2str(year_end), '.mat');
load(build_load_filename)


plot_series = allyr_patstats.total_alg1_week;


% Make time series plot of matches per week
my_xaxis_labels = {1976; ''; ''; ''; 1980; ''; ''; ''; ''; 1985; ''; ...
    ''; ''; ''; 1990; ''; ''; ''; ''; 1995; ''; ''; ''; ''; 2000; ''; ...
    ''; ''; ''; 2005; ''; ''; ''; ''; 2010; ''; ''; ''; ''; 2015};


color1_pick = [0.3, 0.3, 0.3]; % dark gray
my_gray = [0.806, 0.806, 0.806]; % light gray


figureHandle = figure;

set(gca,'FontSize', 22) % change default font size of axis labels

h_gline = plot(1:length(plot_series), repmat(1000, ...
    length(plot_series), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on
h_gline = plot(1:length(plot_series), repmat(2000, ...
    length(plot_series), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on
h_gline = plot(1:length(plot_series), repmat(3000, ...
    length(plot_series), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on

h_scatter = scatter(1:length(plot_series), plot_series, ...
    'Marker', 'o', 'MarkerEdgeColor', color1_pick);

uistack(h_scatter, 'top');

xlim([1 length(plot_series)])
ylim([0 3500])
set(gca, 'XTick', allyr_patstats.ix_new_year) % Set the x-axis tick labels
set(gca, 'xticklabel',{}) % turn x-axis labels off
set(gca, 'xticklabel', my_xaxis_labels); 

set(gca,'TickDir','out')  
box off
set(gcf, 'Color', 'white');


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 800 400]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/alg1_weekly_', num2str(year_start), ...
    '-', num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
