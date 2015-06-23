close all
clear all
clc


%% Set font
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')


%% Define parameters
year_start = 1976;
year_end = 1990;


%% Load summary data
build_load_filename = horzcat('allyr_patstats_', num2str(year_start), ...
    '-', num2str(year_end), '.mat');
load(build_load_filename)


%% Make time series plot of matches per week
my_xaxis_labels = {1976; ''; ''; ''; 1980; ''; ''; ''; ''; 1985; ''; ...
    ''; ''; ''; 1990; ''; ''; ''; ''; 1995; ''; ''; ''; ''; 2000; ''; ...
    ''; ''; ''; 2005; ''; ''; ''; ''; 2010; ''; ''; ''; ''; 2015};



find_dictionary = {'automat', 'robot', ...
    'movable arm', 'labour efficien', 'algorithm', 'software', ...
    'autonomous', 'adaptive', 'independent', 'continuous', 'responsive'};

nr_worddict = size(allyr_patstats.total_matches_week, 2);

color1_pick = [0.7900, 0.3800, 0.500]; % red
% color1_pick = [0.3, 0.3, 0.3]; % dark gray
my_gray = [0.806, 0.806, 0.806]; % light gray


figureHandle = figure;

set(gca,'FontSize',11) % change default font size of axis labels


for k = 1:size(allyr_patstats.total_matches_week, 2)

    subplot(4, 3, k)
    plot_series = allyr_patstats.total_matches_week(:, k);

    scatter(1:length(plot_series), plot_series, ...
        'Marker', 'o', 'MarkerEdgeColor', color1_pick)
    
    title(find_dictionary(k))
    
    xlim([1 length(plot_series)])
    set(gca, 'XTick', allyr_patstats.ix_new_year) % Set the x-axis tick labels
    set(gca, 'xticklabel',{}) % turn x-axis labels off
    % gridxy(get(gca,'xtick'), get(gca,'ytick'), 'color', my_gray, 'linewidth', 1) % make grey grid lines
    set(gca, 'xticklabel', my_xaxis_labels); 
end


set(gca,'TickDir','out')  
box off
set(gcf, 'Color', 'w');



% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 1500 900]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('keyword_matches_weekly_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
