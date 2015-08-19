function plot_classifstat_yrly(classifstat_yrly, year_start, year_end)


%% Set font
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

lwidth = 1.5;


%% Plot
year_start = 1976;
year_end = 2015;

% Define some plot settings
plottime = year_start:year_end;
my_gray = [0.806, 0.806, 0.806];
my_dark_gray = [0.3, 0.3, 0.3];

gray1 = [163, 164, 167] ./ 255;
gray2 = [123, 124, 127] ./ 255;
gray3 = [72, 73, 74] ./ 255;

% color1_pick = [244,165,130]./ 255;
% color2_pick = [178,24,43]./ 255;
% color3_pick = [5,48,97]./ 255;
% color4_pick = [67,147,195]./ 255;

color1_pick = gray3;
color2_pick = gray1;
color3_pick = gray2;
color4_pick = color1_pick;

grid_linewidth = 0.3;


figureHandle = figure;
set(gca,'FontSize',12) % change default font size of axis labels
set(gcf,'color','w');

subplot(3,1,1)
plot(plottime, classifstat_yrly.nr_class, 'Color', color3_pick, ...
    'Linewidth', lwidth)
box off
hold on
plot(plottime, classifstat_yrly.nr_manclass_Yes_yr, 'Color', color1_pick, ...
    'Linewidth', lwidth)
hold on
plot(plottime, classifstat_yrly.nr_compClass_Yes_yr, 'Color', color2_pick, ...
    'Linewidth', lwidth)
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
% ygrid_lines(find(ygrid_lines==yLimits(2))) = []; % remove grid line at the top
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', grid_linewidth);

subplot(3,1,2)
plot(plottime, classifstat_yrly.nr_manclass_Yes_yr ./ ...
    classifstat_yrly.nr_class, 'Color', color1_pick, 'Linewidth', lwidth)
hold on
plot(plottime, classifstat_yrly.nr_compClass_Yes_yr ./ ...
    classifstat_yrly.nr_class, 'Color', color2_pick, 'Linewidth', lwidth)
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
% ygrid_lines(find(ygrid_lines==yLimits(2))) = []; % remove grid line at the top
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', grid_linewidth);

subplot(3,1,3)
% plot(plottime, repmat(classifstat.accuracy, size(plottime)), ...
%     '-', 'Color', color4_pick, 'LineWidth', 1)
% hold on
plot(plottime, classifstat_yrly.accuracy, 'Color', color4_pick, ...
    'Linewidth', lwidth)
titleHandle = title('Accuracy', 'FontWeight', 'bold');

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
% ygrid_lines(find(ygrid_lines==yLimits(2))) = []; % remove grid line at the top
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
annotation(figureHandle,'textarrow',[0.730068997791874 0.737704918032789],...
    [0.909060275272933 0.890988372093023],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Total',...
    'HeadStyle','none',...
    'FontSize', 10, ...
    'Color',color3_pick);

annotation(figureHandle,'textarrow',[0.303500836820429 0.296807592752373],...
    [0.79078191741818 0.768895348837209],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Manual "Yes"',...
    'HeadStyle','none',...
    'Color',color1_pick);


annotation(figureHandle,'textarrow',[0.574614518380461 0.550474547023296],...
    [0.782885619364074 0.75],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Computerized "Yes"',...
    'HeadStyle','none',...
    'Color',color2_pick);


annotation(figureHandle,'textarrow',[0.309210424448302 0.297670405522002],...
    [0.542757475083063 0.497093023255814],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Manual',...
    'HeadStyle','none',...
    'FontSize', 10, ...
    'Color', color1_pick);

annotation(figureHandle, 'textarrow', [0.499956334546595 0.511647972389991],...
    [0.59539155196963 0.575581395348837],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Computerized',...
    'HeadStyle','none',...
    'Color', color2_pick, ...
    'FontSize', 10);

annotation(figureHandle,'textarrow',[0.560126329560794 0.567730802415877],...
    [0.296097532036078 0.281976744186047],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Overall accuracy',...
    'HeadStyle','none',...
    'FontSize', 10, ...
    'Color', color4_pick);



% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = 'output/classifstat_yrly.pdf';
print(figureHandle, print_pdf_name, '-dpdf', '-r0')


