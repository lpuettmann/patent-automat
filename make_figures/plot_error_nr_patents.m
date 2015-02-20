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


error_nr_patents = (patent_match_summary.nr_patents_yr' - ...
    official_nr_patents(:,2));



%% Plot




% Some settings for the plots
plot_time = year_start:year_end;
color1_pick = [0.7900, 0.3800, 0.500];
color2_pick = [0.000,0.639,0.561];
color3_pick = [0.890,0.412,0.525];

my_gray = [0.6706, 0.6706, 0.6706];

figureHandle = figure;


% Plot total number of identified patents per year
pick_plot_series = error_nr_patents;
plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color1_pick)
set(gca,'FontSize',12) % change default font size of axis labels
%title('Error in number of identified patents', 'FontSize', 14)
box off
xlim([year_start year_end]);
set(gca,'TickDir','out'); 
get(gca, 'YTickLabel');
new_yticks = {'0'; '100,000'; '150,000'; '200,000'};

% Make grey horizontal dashed line at zero y-axis
% ----------------------------------------------------------------
hline = refline([0 0]);
set(hline,'LineStyle', ':', 'Color', 'k');


% General settings
set(gcf, 'Color', 'w');



%% Change position and size
set(gcf, 'Position', [100 200 800 500]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


%% Export to pdf
print_pdf_name = horzcat('error_nr_patents_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')


