close all
clear all
clc

addpath('../functions')


%% Set font
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')


%% Load statistics on classification errors (manual vs. computerized)
load('classifstat.mat')



%% Plot
year_start = 1976;
year_end = 2015;

% Define some plot settings
plottime = year_start:year_end;
my_gray = [0.806, 0.806, 0.806];
my_dark_gray = [0.3, 0.3, 0.3];


figureHandle = figure;
set(gca,'FontSize',12) % change default font size of axis labels
set(gcf,'color','w');

subplot(3,1,1)
plot(plottime, classifstat.number)
box off
hold on
plot(plottime, classifstat.summanclass, 'Color', 'red')
hold on
plot(plottime, classifstat.sumpat1match, 'Color', 'green')
box off
legend('Total number', 'Manually classified as automation', ...
    'Computer classified as automation')
set(gca, 'TickDir', 'out')

subplot(3,1,2)
plot(plottime, classifstat.manautom, 'Color', 'red')
hold on
plot(plottime, classifstat.compautom, 'Color', 'green')
box off
legend('Share manually classified as automation', ...
    'Share computer classified as automation')
ylim([0, 1])
put_in_title = horzcat('Correlation: ', num2str(round(corr(...
    classifstat.manautom', classifstat.compautom')*100)/100));
title(put_in_title)
set(gca, 'TickDir', 'out')

yLimits = get(gca,'YLim');
ygrid_lines = [yLimits(1):0.2:yLimits(end)];
ygrid_lines(find(ygrid_lines==yLimits(1))) = []; % remove bottom grid line
ygrid_lines(find(ygrid_lines==yLimits(2))) = []; % remove grid line at the top
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', 0.9);

subplot(3,1,3)
h_gline = plot(plottime, repmat(0.8, ...
    length(plottime), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on

h_gline = plot(plottime, repmat(0.6, ...
    length(plottime), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on

h_gline = plot(plottime, repmat(0.4, ...
    length(plottime), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on

h_gline = plot(plottime, repmat(0.2, ...
    length(plottime), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on

scatter(plottime, classifstat.agreerate, 3, ...
    'Marker', 'o', 'MarkerEdgeColor', my_dark_gray, ...
    'MarkerFaceColor', my_dark_gray)
hold on
plot(plottime, hpfilter(classifstat.agreerate, 5), 'Color', my_dark_gray)
title('Agreement rate')
box off
ylim([0, 1])
set(gca, 'TickDir', 'out')
xlim([year_start, year_end])


yLimits = get(gca,'YLim');
ygrid_lines = [yLimits(1):1:yLimits(end)];
ygrid_lines(find(ygrid_lines==yLimits(1))) = []; % remove bottom grid line
ygrid_lines(find(ygrid_lines==yLimits(2))) = []; % remove grid line at the top
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', 0.9);



% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 1000 600]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = 'classification_error_plots.pdf';
print(figureHandle, print_pdf_name, '-dpdf', '-r0')



