function plot_accuracy_yrly(classifstat_yrly, year_start, year_end)

%%
%% Set font
plot_settings_global

lwidth = 1.5;


% Plot
year_start = 1976;
year_end = 2015;

% Define some plot settings
plottime = year_start:year_end;
my_gray = [0.806, 0.806, 0.806];
my_dark_gray = [0.3, 0.3, 0.3];

gray1 = [163, 164, 167] ./ 255;
gray2 = [123, 124, 127] ./ 255;
gray3 = [72, 73, 74] ./ 255;

grid_linewidth = 0.3;


figureHandle = figure;
set(gca,'FontSize',12) % change default font size of axis labels
set(gcf,'color','w');

plot(plottime, classifstat_yrly.accuracy, 'Color', gray2, ...
    'Linewidth', lwidth)

box off
ylim([0, 1])
set(gca, 'TickDir', 'out')
xlim([year_start, year_end])
yLimits = get(gca,'YLim');
ygrid_lines = [yLimits(1):0.2:yLimits(end)];
ygrid_lines(find(ygrid_lines==yLimits(1))) = []; % remove bottom grid line
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', grid_linewidth);


annotation(figureHandle,'textarrow',[0.533218291630721 0.572044866264021],...
    [0.930232558139535 0.831395348837209],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Accuracy',...
    'HeadStyle','none',...
    'FontSize', 14, ...
    'Color', gray2);


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 900 300]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])



% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = 'output/accuracy_yrly.pdf';
print(figureHandle, print_pdf_name, '-dpdf', '-r0')


