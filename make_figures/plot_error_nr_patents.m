function plot_error_nr_patents


% Define parameters
compare_year_start = 1976;
compare_year_end = 2014;


% Load summary data
build_load_filename = 'allyr_patstats_1976-2015.mat';

if exist(build_load_filename, 'file') == 2 % check if file exists
    load(build_load_filename)
else
    warning('%s does not exist. This function only works with data from 1976-2015.', ...
        build_load_filename)
    return
end

ix_start = 1;
ix_iter = 1;
for ix_year=1976:2015
    week_end = set_weekend(ix_year);
    ix_end = ix_start - 1 + week_end; 
    nr_pat(ix_iter, 1) = sum( allyr_patstats.nr_patents_per_week( ...
        ix_start : ix_end) );
    ix_start = ix_end + 1;
    ix_iter = ix_iter + 1;
end

nr_pat_until2014 = nr_pat(1:end - 1);


%% Set font
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')


%% Calculate error in number of patents
% From: http://www.uspto.gov/web/offices/ac/ido/oeip/taf/us_stat.htm
official_nr_patents = [...  
        1976       70226;
        1977       65269;
        1978       66102;
        1979       48854;
        1980       61819;
        1981       65771;
        1982       57888;
        1983       56860;
        1984       67200;
        1985       71661;
        1986       70860;
        1987       82952;
        1988       77924;
        1989      95537;
        1990       90365;
        1991      96511;
        1992      97444;
        1993      98342;
        1994      101676;
        1995      101419;
        1996      109645;
        1997      111984;
        1998      147517;
        1999      153485;
        2000      157494;
        2001      166035;
        2002      167331;
        2003      169923;
        2004      164290;
        2005      143806;
        2006      173772;
        2007      157282;
        2008      157772;
        2009      167349;
        2010      219614;
        2011      224505;
        2012      253155;
        2013      277835;
        2014      300678];


error_nr_patents = (nr_pat_until2014 - official_nr_patents(:, 2));



%% Plot


% Some settings for the plots
plot_time = compare_year_start:compare_year_end;
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
title('Error in number of identified patents (negative: identified too few patents)', 'FontSize', 14, ...
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
print_pdf_name = horzcat('output/error_nr_patents_', num2str(compare_year_start), '-',  num2str(compare_year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

