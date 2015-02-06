close all
clear all
clc

% Define parameters
year_start = 1976;
year_end = 2001;


% Load summary data
load('patent_match_summary_1976-2001')


%% Calculate error in number of patents
% From: http://www.uspto.gov/web/offices/ac/ido/oeip/taf/us_stat.htm
official_nr_patents = [...  
        1976       75388;
        1977       69781;
        1978       70514;
        1979       52413;
        1980       66170;
        1981       71064;
        1982       63276;
        1983       61982;
        1984       72650;
        1985       77245;
        1986       76862;
        1987       89385;
        1988       84272;
        1989      102533;
        1990       99077;
        1991      106696;
        1992      107394;
        1993      109746;
        1994      113587;
        1995      113834;
        1996      121696;
        1997      124069;
        1998      163142;
        1999      169085;
        2000      175979;
        2001      183970];


error_nr_patents = (official_nr_patents(:,2) - ...
    patent_match_summary.nr_patents_yr');



%% Plot




% Some settings for the plots
plot_time = year_start:year_end;
color1_pick = [0.7900, 0.3800, 0.500];
color2_pick = [0.000,0.639,0.561];
color3_pick = [0.890,0.412,0.525];

my_gray = [0.6706, 0.6706, 0.6706];

% Give both subplots on mean matches the same scale
% mean_y_axis_limit = [0.5, 1.5];


figureHandle = figure;


% Plot total number of identified patents per year
pick_plot_series = error_nr_patents;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
title('A. Number of identified US patents per year', 'FontSize', 14)
box off
xlim([year_start year_end]);
set(gca,'TickDir','out'); 
% set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off

get(gca, 'YTickLabel')
new_yticks = {'0'; '100,000'; '150,000'; '200,000'};
% set(gca, 'yticklabel', new_yticks); 

%gridxy(get(gca,'xtick'), get(gca,'ytick'), 'color', my_gray, 'linewidth', 1) % make grey grid lines




% General settings
set(gcf, 'Color', 'w');


