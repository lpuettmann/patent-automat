close all
clear all
clc


addpath('functions');

%% Define parameters
year_start = 1976;
year_end = 2001;


%% Load summary data
load('total_matches_week_1976-2001')



%% Calculate matches over number patents for each week
vector_nrpat_per_week = cell2mat(allyear_nr_patents_per_week);

if length(allyear_total_matches_week) ~= length(vector_nrpat_per_week)
    warning('These should have the same length')
end

matches_per_patent_weekly = allyear_total_matches_week ./ ...
    vector_nrpat_per_week;




%% Make time series plot of matches per week
my_xaxis_labels = {1976; ''; ''; ''; 1980; ''; ''; ''; ''; 1985; ''; ''; ''; ''; 1990; ''; ''; ''; ''; 1995; ''; ''; ''; ''; ''; 2001;};

color2_pick = [0.000,0.639,0.561];
my_gray = [0.806, 0.806, 0.806];



figureHandle = figure;

scatter(1:length(matches_per_patent_weekly), matches_per_patent_weekly, ...
    'Marker', 'o', 'MarkerEdgeColor', color2_pick)


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
% xlim([1 length(allyear_total_matches_week)])
% set(gca, 'XTick', ix_new_year) % Set the x-axis tick labels
% set(gca, 'xticklabel',{}) % turn x-axis labels off
% set(gca, 'xticklabel', my_xaxis_labels); 




% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 800 500]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('match_over_nrpatents_weekly_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

