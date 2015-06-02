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
color1_pick = [244,165,130]./ 255;
color2_pick = [178,24,43]./ 255;
color3_pick = [5,48,97]./ 255;
color4_pick = [67,147,195]./ 255;
grid_linewidth = 0.3;


figureHandle = figure;
set(gca,'FontSize',12) % change default font size of axis labels
set(gcf,'color','w');

subplot(3,1,1)
plot(plottime, classifstat.number, 'Color', color3_pick, ...
    'Marker', 'o', 'MarkerSize', 2, 'Color', color3_pick, ...
    'MarkerFaceColor', color3_pick)
box off
hold on
plot(plottime, classifstat.summanclass, 'Color', color1_pick, ...
    'Marker', 'o', 'MarkerSize', 2, 'Color', color1_pick, ...
    'MarkerFaceColor', color1_pick)
hold on
plot(plottime, classifstat.sumpat1match, 'Color', color2_pick, ...
    'Marker', 'o', 'MarkerSize', 2, 'Color', color2_pick, ...
    'MarkerFaceColor', color2_pick)
box off
% legend('Total', 'Manual "Yes"', ...
%     'Computerized "Yes"', 'Location', 'North')
% legend('boxoff')
titleHandle = title('Number of manually classified patents', 'FontWeight', 'bold');

set(titleHandle, 'horizontalAlignment', 'left')
set(titleHandle, 'units', 'normalized')
h1 = get(titleHandle, 'position');
set(titleHandle, 'position', [0 h1(2) h1(3)])

set(gca, 'TickDir', 'out')
yLimits = get(gca,'YLim');
xlim([year_start, year_end])
ygrid_lines = [yLimits(1):5:yLimits(end)];
ygrid_lines(find(ygrid_lines==yLimits(1))) = []; % remove bottom grid line
ygrid_lines(find(ygrid_lines==yLimits(2))) = []; % remove grid line at the top
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', grid_linewidth);

subplot(3,1,2)
plot(plottime, classifstat.manautom, 'Color', color1_pick, ...
    'Marker', 'o', 'MarkerSize', 2, 'Color', color1_pick, ...
    'MarkerFaceColor', color1_pick)
hold on
plot(plottime, classifstat.compautom, 'Color', color2_pick, ...
    'Marker', 'o', 'MarkerSize', 2, 'Color', color2_pick, ...
    'MarkerFaceColor', color2_pick)
box off
% legend('manual', ...
%     'computerized', 'Location', 'North')
% legend('boxoff')
ylim([0, 1])
titleHandle = title('Share classified as automation patents', 'FontWeight', 'bold');

xlim([year_start, year_end])
set(titleHandle, 'horizontalAlignment', 'left')
set(titleHandle, 'units', 'normalized')
h1 = get(titleHandle, 'position');
set(titleHandle, 'position', [0 h1(2) h1(3)])

set(gca, 'TickDir', 'out')

yLimits = get(gca,'YLim');
ygrid_lines = [yLimits(1):0.2:yLimits(end)];
ygrid_lines(find(ygrid_lines==yLimits(1))) = []; % remove bottom grid line
ygrid_lines(find(ygrid_lines==yLimits(2))) = []; % remove grid line at the top
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', grid_linewidth);

subplot(3,1,3)
plot(plottime, repmat(classifstat.total_agree_rate, size(plottime)), ...
    '-', 'Color', color4_pick, 'LineWidth', 1)
hold on
plot(plottime, classifstat.agreerate, ...
    'Marker', 'o', 'Color', color4_pick, 'MarkerFaceColor', color4_pick, ...
    'MarkerSize', 3)
titleHandle = title('Agreement rate', 'FontWeight', 'bold');

set(titleHandle, 'horizontalAlignment', 'left')
set(titleHandle, 'units', 'normalized')
h1 = get(titleHandle, 'position');
set(titleHandle, 'position', [0 h1(2) h1(3)])

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
set(gcf, 'Position', [100 200 1000 600]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Add annotations
% -----------------------------------------------------------------------
annotation(figureHandle,'textarrow',[0.850862785539927 0.841983852364475],...
    [0.856734693877584 0.842857142857144],'TextEdgeColor','none','HorizontalAlignment','left',...
    'FontSize',12, ...
    'String','Total',...
    'Color', color3_pick, ...
    'HeadStyle','none', ...
    'FontSize', 10);

annotation(figureHandle,'textarrow',[0.261223011108608 0.267589388696655],...
    [0.768979591836785 0.753061224489796],'TextEdgeColor','none','HorizontalAlignment','left',...
    'FontSize',12, ...
    'String', 'Manual "Yes"',...
    'Color', color1_pick, ...
    'HeadStyle','none', ...
    'FontSize', 10);

annotation(figureHandle,'textarrow',[0.504726684040504 0.490196078431373],...
    [0.852653061224539 0.763265306122451],'TextEdgeColor','none','HorizontalAlignment','left',...
    'FontSize',12, ...
    'String','Computerized "Yes"',...
    'Color', color2_pick, ...
    'HeadStyle','none', ...
    'FontSize', 10);


annotation(figureHandle,'textarrow',[0.25916728380982 0.268742791234141],...
    [0.548571428571435 0.53265306122449],'TextEdgeColor','none','HorizontalAlignment','left',...
    'FontSize',12, ...
    'String','Manual',...
    'Color', color1_pick, ...
    'HeadStyle','none', ...
    'FontSize', 10);

annotation(figureHandle,'textarrow',[0.439559440672565 0.456747404844291],...
    [0.554693877551025 0.510204081632654],'TextEdgeColor','none','HorizontalAlignment','left',...
    'FontSize',12, ...
    'String','Computerized',...
    'Color', color2_pick, ...
    'HeadStyle','none', ...
    'FontSize', 10);


annotation(figureHandle,'textarrow',[0.685234181156995 0.683967704728951],...
    [0.297551020408171 0.277551020408164],'TextEdgeColor','none','HorizontalAlignment','left',...
    'FontSize', 12, ...
    'String', 'Overall agreement rate',...
    'Color', color4_pick, ...
    'HeadStyle','none', ...
    'FontSize', 10);


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = 'classification_error_plots.pdf';
print(figureHandle, print_pdf_name, '-dpdf', '-r0')


