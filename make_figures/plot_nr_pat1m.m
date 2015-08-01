function plot_nr_pat1m(year_start, year_end)


%% Set font
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

%% Define parameters
year_start = 1976;
year_end = 2015;


%% Load summary data
build_load_filename = horzcat('allyr_patstats_', num2str(year_start), ...
    '-', num2str(year_end), '.mat');
load(build_load_filename)


%% Make time series plot of matches per week
my_xaxis_labels = {1976; ''; ''; ''; 1980; ''; ''; ''; ''; 1985; ''; ...
    ''; ''; ''; 1990; ''; ''; ''; ''; 1995; ''; ''; ''; ''; 2000; ''; ...
    ''; ''; ''; 2005; ''; ''; ''; ''; 2010; ''; ''; ''; ''; 2015};


color1_pick = [244,165,130]./ 255; 
my_gray = [0.806, 0.806, 0.806]; % light gray


figureHandle = figure;

plot_series = allyr_patstats.total_pat1m_week(:, 1);
[plot_trend, ~] = hpfilter(plot_series, 100000);

scatter(1:length(plot_series), plot_series, ...
    'Marker', 'o', 'MarkerEdgeColor', color1_pick)
hold on
h_trend = plot(1:length(plot_series), plot_trend, ...
    'Color', color1_pick, 'Linewidth', 1.6);


set(gca,'FontSize',11) % change default font size of axis labels
title('Number of patents with at least one match', 'FontSize', 18)

set(gca,'TickDir','out')  
box off
set(gcf, 'Color', 'w');
xlim([1 length(plot_series)])
set(gca, 'XTick', allyr_patstats.ix_new_year) % Set the x-axis tick labels
set(gca, 'xticklabel',{}) % turn x-axis labels off
set(gca, 'xticklabel', my_xaxis_labels); 


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 1400 800]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/number_pat1m', num2str(year_start), '-', ...
    num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
