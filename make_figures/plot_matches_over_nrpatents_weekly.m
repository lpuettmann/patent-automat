close all
clear all
clc



%% Define parameters
year_start = 1976;
year_end = 2015;



%% Set font
set(0,'DefaultTextFontName','Palatino')
set(0,'DefaultAxesFontName','Palatino')


%% Load summary data
build_load_filename = horzcat('total_matches_week_', num2str(year_start), ...
    '-', num2str(year_end), '.mat');
load(build_load_filename)




%% Calculate matches over number patents for each week
vector_nrpat_per_week = cell2mat(allyear_nr_patents_per_week);

if length(allyear_total_matches_week) ~= length(vector_nrpat_per_week)
    warning('These should have the same length')
end

matches_per_patent_weekly = allyear_total_matches_week ./ ...
    vector_nrpat_per_week;

[plot_trend, ~] = hpfilter(matches_per_patent_weekly, 100000);


%% Make time series plot of matches per week
my_xaxis_labels = {1976; ''; ''; ''; 1980; ''; ''; ''; ''; 1985; ''; ...
    ''; ''; ''; 1990; ''; ''; ''; ''; 1995; ''; ''; ''; ''; 2000; ''; ...
    ''; ''; ''; 2005; ''; ''; ''; ''; 2010; ''; ''; ''; ''; 2015};

color2_pick = [0.000,0.639,0.561];
my_gray = [0.806, 0.806, 0.806];
my_dark_gray = [0.3, 0.3, 0.3];


rescale_markers = allyear_total_matches_week ./ 50;


figureHandle = figure;
hold on
h_scatter = scatter(1:length(matches_per_patent_weekly), ...
    matches_per_patent_weekly, rescale_markers, ...
    'Marker', 'o', 'MarkerEdgeColor', color2_pick);

h_trend = plot(1:length(matches_per_patent_weekly), plot_trend, ...
    'Color', color2_pick, 'Linewidth', 1.6);

uistack(h_scatter, 'top');
uistack(h_trend, 'bottom');

set(gca,'FontSize',11) % change default font size of axis labels
title_phrase = sprintf(['A. Number of weekly occurences ', ...
    'in US patents']);

title(title_phrase, 'FontSize', 11, ...
    'Units', 'normalized', ...
    'Position', [0.365 1.1], ...
    'HorizontalAlignment', 'right')

% set(gca, 'XColor', my_dark_gray, 'YColor', my_dark_gray)
set(gca,'TickDir','out')  
box off
set(gcf, 'Color', 'w');
ylim([0 3.5]) % watch out: this omits entry 190 which is very high with 2.297
xlim([1 length(allyear_total_matches_week)])
set(gca, 'XTick', ix_new_year) % Set the x-axis tick labels
set(gca, 'xticklabel',{}) % turn x-axis labels off
set(gca, 'xticklabel', my_xaxis_labels); 


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 800 600]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('match_over_nrpatents_weekly_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

hold off
