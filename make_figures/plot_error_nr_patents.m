close all
clear all
clc

% Define parameters
year_start = 1976;
year_end = 2013;


% Load summary data
load('patent_match_summary_1976-2014')


nr_pat_until2013 = patent_match_summary.nr_patents_yr(1:end-1)';


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
        2001      183970;
        2002      184375;
        2003      187012;
        2004      181299;
        2005      157718;
        2006      196405;
        2007      182899;
        2008      185224;
        2009      191927;
        2010      244341;
        2011      247713;
        2012      276788;
        2013      302948];


error_nr_patents = (nr_pat_until2013 - ...
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

bar(plot_time, pick_plot_series, 0.7, 'FaceColor', color1_pick, ...
    'EdgeColor', color1_pick)

%plot(plot_time, pick_plot_series, 'Color', color1_pick, 'LineWidth', 0.5, ...
%    'Marker', 'o', 'MarkerSize', 7, 'MarkerFaceColor', color1_pick)
%set(gca,'FontSize',12) % change default font size of axis labels
title('Error in number of identified patents', 'FontSize', 14, ...
    'FontWeight', 'bold')
box off
set(gca,'FontSize',12) % change default font size of axis labels


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


