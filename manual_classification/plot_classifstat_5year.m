close all
clear all
clc

addpath('../functions')


%% Set font
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')



%% Load statistics on classification errors (manual vs. computerized)
load('classifstat.mat')


%% Change series to 5 year periods
Tfull = length(classifstat.number);

if mod(Tfull, 5) > 0
    warning('Number of years do not fit in 5 year periods.')
end

T5year = Tfull / 5;
classifstat_5year.number = zeros(1, T5year);

correctlyclassifpat = classifstat.agreerate .* classifstat.number;

for t=1:T5year
    ix_start = 5 * t - 4;
    ix_end = 5 * t;
    
    classifstat_5year.number(t) = sum(classifstat.number(ix_start:ix_end));

    classifstat_5year.summanclass(t) = sum(classifstat.summanclass(ix_start:ix_end));
    
    classifstat_5year.sumpat1match(t) = sum(classifstat.sumpat1match(ix_start:ix_end));
    
    classifstat_5year.agreerate(t) = ...
        sum(correctlyclassifpat(ix_start:ix_end)) ./ ...
        classifstat_5year.number(t);
end

classifstat_5year.manautom = classifstat_5year.summanclass ./ ...
    classifstat_5year.number;
classifstat_5year.compautom = classifstat_5year.sumpat1match ./ ...
    classifstat_5year.number;


%% Print correlation
fprintf('Correlation: %3.2f.\n', corr(classifstat_5year.manautom', ...
    classifstat_5year.compautom'));


%% Plot
year_start = 1976;
year_end = 2015;

% Define some plot settings
plottime = year_start:5:year_end;
my_gray = [0.806, 0.806, 0.806];
my_dark_gray = [0.3, 0.3, 0.3];
color1_pick = [244,165,130]./ 255;
color2_pick = [178,24,43]./ 255;
color3_pick = [5,48,97]./ 255;
color4_pick = [67,147,195]./ 255;
grid_linewidth = 0.3;


figureHandle = figure;
set(gca,'FontSize',12) % change default font size of axis labels
set(gcf,'color','w');

subplot(3,1,1)
plot(plottime, classifstat_5year.number, 'Color', color3_pick, ...
    'Marker', 'o', 'MarkerSize', 2, 'Color', color3_pick, ...
    'MarkerFaceColor', color3_pick)
box off
hold on
plot(plottime, classifstat_5year.summanclass, 'Color', color1_pick, ...
    'Marker', 'o', 'MarkerSize', 2, 'Color', color1_pick, ...
    'MarkerFaceColor', color1_pick)
hold on
plot(plottime, classifstat_5year.sumpat1match, 'Color', color2_pick, ...
    'Marker', 'o', 'MarkerSize', 2, 'Color', color2_pick, ...
    'MarkerFaceColor', color2_pick)
box off
legend('Total number', 'Manually classified as automation', ...
    'Computer classified as automation', 'Location', 'North')
legend('boxoff')
title('Number of classified patents', 'FontWeight', 'bold')
set(gca, 'TickDir', 'out')
yLimits = get(gca,'YLim');
ygrid_lines = [yLimits(1):20:yLimits(end)];
ygrid_lines(find(ygrid_lines==yLimits(1))) = []; % remove bottom grid line
ygrid_lines(find(ygrid_lines==yLimits(2))) = []; % remove grid line at the top
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', grid_linewidth);

subplot(3,1,2)
plot(plottime, classifstat_5year.manautom, 'Color', color1_pick, ...
    'Marker', 'o', 'MarkerSize', 2, 'Color', color1_pick, ...
    'MarkerFaceColor', color1_pick)
hold on
plot(plottime, classifstat_5year.compautom, 'Color', color2_pick, ...
    'Marker', 'o', 'MarkerSize', 2, 'Color', color2_pick, ...
    'MarkerFaceColor', color2_pick)
box off
legend('manually classified', ...
    'computer-classified', 'Location', 'North')
legend('boxoff')
ylim([0, 1])
title('Share classified as automation patents', 'FontWeight', 'bold')
set(gca, 'TickDir', 'out')

yLimits = get(gca,'YLim');
ygrid_lines = [yLimits(1):0.2:yLimits(end)];
ygrid_lines(find(ygrid_lines==yLimits(1))) = []; % remove bottom grid line
ygrid_lines(find(ygrid_lines==yLimits(2))) = []; % remove grid line at the top
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', grid_linewidth);

subplot(3,1,3)
plot(plottime, classifstat_5year.agreerate, ...
    'Marker', 'o', 'Color', color4_pick, 'MarkerFaceColor', color4_pick, ...
    'MarkerSize', 3)
title('Agreement rate', 'FontWeight', 'bold')
box off
ylim([0, 1])
set(gca, 'TickDir', 'out')
xlim([year_start, year_end])
yLimits = get(gca,'YLim');
ygrid_lines = [yLimits(1):0.2:yLimits(end)];
ygrid_lines(find(ygrid_lines==yLimits(1))) = []; % remove bottom grid line
ygrid_lines(find(ygrid_lines==yLimits(2))) = []; % remove grid line at the top
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', grid_linewidth);



% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 1000 800]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = 'classification_error_plots_5year.pdf';
print(figureHandle, print_pdf_name, '-dpdf', '-r0')



