function plot_alg1_over_nrpatents_weekly(year_start, year_end)

%%
% Set font
plot_settings_global


% Load summary data
build_load_filename = horzcat('allyr_patstats_', num2str(year_start), ...
    '-', num2str(year_end), '.mat');
load(build_load_filename)


raw_series = allyr_patstats.total_alg1_week;

% Calculate ratio of number of classified patents to total number of
% patents
plot_series = raw_series ./ allyr_patstats.nr_patents_per_week;


% Make time series plot of matches per week
my_xaxis_labels = {1976; ''; ''; ''; 1980; ''; ''; ''; ''; 1985; ''; ...
    ''; ''; ''; 1990; ''; ''; ''; ''; 1995; ''; ''; ''; ''; 2000; ''; ...
    ''; ''; ''; 2005; ''; ''; ''; ''; 2010; ''; ''; ''; ''; 2015};
plot_settings_global

figureHandle = figure;

set(gca,'FontSize', 22) % change default font size of axis labels

h_gline = plot(1:length(plot_series), repmat(0.1, ...
    length(plot_series), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on
h_gline = plot(1:length(plot_series), repmat(0.2, ...
    length(plot_series), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on
h_gline = plot(1:length(plot_series), repmat(0.3, ...
    length(plot_series), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on
h_gline = plot(1:length(plot_series), repmat(0.4, ...
    length(plot_series), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on
h_gline = plot(1:length(plot_series), repmat(0.5, ...
    length(plot_series), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on

h_scatter = scatter(1:length(plot_series), plot_series, ...
    'Marker', 'o', 'MarkerEdgeColor', color1_pick);

uistack(h_scatter, 'top');

ylim([0 0.55])
xlim([1 length(plot_series)])
set(gca, 'XTick', allyr_patstats.ix_new_year) % Set the x-axis tick labels
set(gca, 'xticklabel',{}) % turn x-axis labels off
set(gca, 'xticklabel', my_xaxis_labels); 

set(gca,'TickDir','out')  
box off
set(gcf, 'Color', 'w');


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 800 400]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/alg1_over_nrpatents_weekly_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
