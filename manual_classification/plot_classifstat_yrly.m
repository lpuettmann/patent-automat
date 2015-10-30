function plot_classifstat_yrly(classifstat_yrly, year_start, year_end)


%% Set font
plot_settings_global

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
titleHandle = title('(a) Number of manually classified patents', 'FontWeight', 'bold');

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
titleHandle = title('(b) Share classified as automation patents', 'FontWeight', 'bold');

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
titleHandle = title('(c) Accuracy', 'FontWeight', 'bold');

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
annotation(figureHandle,'textarrow',[0.564408946023113 0.57377049180328],...
    [0.933769577598514 0.917151162790698],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Total',...
    'HeadStyle','none',...
    'FontSize', 10, ...
    'Color',color3_pick);


annotation(figureHandle,'textarrow',[0.308677713438203 0.301984469370147],...
    [0.802409824394924 0.780523255813953],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Manual "Yes"',...
    'HeadStyle','none',...
    'Color',color1_pick);


annotation(figureHandle,'textarrow',[0.556495450218254 0.540120793787749],...
    [0.8192228286664 0.809593023255814],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Computerized "Yes"',...
    'HeadStyle','none',...
    'Color',color2_pick);


annotation(figureHandle,'textarrow',[0.317515099223469 0.303710094909405],...
    [0.545058139534884 0.489825581395349],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Manual',...
    'HeadStyle','none',...
    'FontSize', 10, ...
    'Color', color1_pick);

annotation(figureHandle, 'textarrow', [0.544822598567307 0.536669542709233],...
    [0.544519458946374 0.523255813953488],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'String','Computerized',...
    'HeadStyle','none',...
    'Color', color2_pick, ...
    'FontSize', 10);



% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = 'output/classifstat_yrly.pdf';
print(figureHandle, print_pdf_name, '-dpdf', '-r0')


