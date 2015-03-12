close all
clear all
clc

% Define parameters
year_start = 1976;
year_end = 2014;





%% Load summary data
build_load_filename = horzcat('patent_match_summary_', num2str(year_start), ...
    '-', num2str(year_end), '.mat');
load(build_load_filename)


%% Calculate ratio
ratio_dist_o_nrpatents = patent_match_summary.nr_distinct_patents_hits ./ ...
    patent_match_summary.nr_patents_yr;

[minratio, ix_min] = min(ratio_dist_o_nrpatents);
[maxratio, ix_max] = max(ratio_dist_o_nrpatents);
fprintf('Minimum ratio: %d in year %d.\n', minratio, year_start - 1 + ix_min)
fprintf('Maximum ratio: %d in year %d.\n', max(ratio_dist_o_nrpatents), year_start - 1 + ix_max)


%% Some settings for the plots
set_ylimit = [0.1 0.4];

plot_time = year_start:year_end;
color1_pick = [0.7900, 0.3800, 0.500];
color2_pick = [0.000,0.639,0.561];
color3_pick = [0.890,0.412,0.525];
color4_pick = [0.890,0.412,0.525];


my_light_gray = [0.95, 0.95, 0.95];
my_dark_gray = [0.8, 0.8, 0.8];


figureHandle = figure;

% Plot total number of identified patents per year
plot(plot_time, ratio_dist_o_nrpatents, 'Marker', 'o', ...
    'MarkerEdgeColor', color1_pick, 'MarkerFaceColor', color1_pick, ...
    'Color', color1_pick)


set(gca,'FontSize',12) % change default font size of axis labels
box off
set(gca,'TickDir','out'); 
ylim(set_ylimit)
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off

%get(gca, 'YTickLabel');
%new_yticks = {'0'; ''; '100000'; ''; '200000'; ''; '300000'; ''; '400000'};
%set(gca, 'yticklabel', new_yticks); 



% General settings
set(gcf, 'Color', 'w');

set(0,'DefaultTextFontName','Palatino') % set font
set(0,'DefaultAxesFontName','Palatino') % set font




%% Change position and size
set(gcf, 'Position', [100 200 700 400]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])




%% Export to pdf
print_pdf_name = horzcat('ratio_dist_o_nrpatents_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

