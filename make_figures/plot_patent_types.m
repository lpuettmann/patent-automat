function plot_patent_types(cats_yearstats)


% Combine chemical and pharma
cats_yearstats(:,1) = cats_yearstats(:,1) + cats_yearstats(:,3);
cats_yearstats(:,3) = nan(size(cats_yearstats,1),1);
cats_yearstats(:,8) = cats_yearstats(:,8) + cats_yearstats(:,10);
cats_yearstats(:,10) = nan(size(cats_yearstats,1),1);

% Combine electrical and mechanical
cats_yearstats(:,4) = cats_yearstats(:,4) + cats_yearstats(:,5);
cats_yearstats(:,5) = nan(size(cats_yearstats,1),1);
cats_yearstats(:,11) = cats_yearstats(:,11) + cats_yearstats(:,12);
cats_yearstats(:,12) = nan(size(cats_yearstats,1),1);

% Combine other and missing
cats_yearstats(:,6) = cats_yearstats(:,6) + cats_yearstats(:,7);
cats_yearstats(:,7) = nan(size(cats_yearstats,1),1);
cats_yearstats(:,13) = cats_yearstats(:,13) + cats_yearstats(:,14);
cats_yearstats(:,14) = nan(size(cats_yearstats,1),1);


tempMat = [cats_yearstats(1:end-1, 1:7) - cats_yearstats(1:end-1, 8:14), ...
    cats_yearstats(1:end-1, 8:14)];

tempMat(:,14) = [];
tempMat(:,12) = [];
tempMat(:,10) = [];
tempMat(:,7) = [];
tempMat(:,5) = [];
tempMat(:,3) = [];

plotMat = tempMat;
plotMat(:,4) = tempMat(:,2);
plotMat(:,1) = tempMat(:,4);
plotMat(:,2) = tempMat(:,1);

plotMat(:,8) = tempMat(:,6);
plotMat(:,5) = tempMat(:,8);
plotMat(:,6) = tempMat(:,5);

plotMat = plotMat ./ 1000;

colors = [165,0,38
        215,48,39
        244,109,67
        253,174,97
        254,224,144
        224,243,248
        171,217,233
        116,173,209
        69,117,180
%         49,54,149
        ] ./ 255;
colors = flipud(colors);

set(0, 'DefaultTextFontName', 'Chapter') % paper font
set(0, 'DefaultAxesFontName', 'Chapter')

% set(0, 'DefaultTextFontName', 'Helvetica') % better font for presentations
% set(0, 'DefaultAxesFontName', 'Helvetica')


my_gray = [0.806, 0.806, 0.806]; % light gray


figureHandle = figure;
barlines = [50:50:300];
t = 1975:2015;
for i=1:length(barlines)
    h_gline = plot(t, repmat(barlines(i), length(t)), ...
        'Color', my_gray , 'linewidth', 0.5);
    uistack(h_gline, 'bottom');
    hold on
end

H = bar(1976:2014, plotMat, 'stacked', 'BarWidth', 0.6);

for k = 1:size(plotMat,2)
  set(H(k), 'FaceColor', colors(k,:))
  set(H(k), 'EdgeColor', colors(k,:))
end

set(gca,'FontSize', 16) % change default font size of axis labels
lgd = legend(fliplr(H), ...
    'Automation patents: Computers and Communications', ...
    'Automation patents: Electric and mechanic', ...
    'Automation patents: Chemical and pharma', ...
    'Automation patents: Other and missing data', ...
    'Rest: Computers and Communications', ...
    'Rest: Electric and mechanic', ...
    'Rest: Chemical and pharma',  ...
    'Rest: Other and missing data', ...
    'Location', 'NorthWest');
set(lgd, 'FontSize', 14);
legend boxoff  
set(gca,'TickDir','out')  
box off

annotation(figureHandle,'textarrow',[0.2 0.15084388185654],...
    [0.383720930232558 0.295681063122924],...
    'String',{'Share of automation','patents: 25%'},...
    'HorizontalAlignment','center', 'Fontsize', 16);
annotation(figureHandle,'textarrow',[0.87 0.880801687763713],...
    [0.883527454242928 0.8369384359401],...
    'String',{'Share of automation','patents: 67%'},...
    'HorizontalAlignment','center', 'Fontsize', 16);

annotation(figureHandle,'textbox',...
    [0.0763 0.911 0.14 0.075],...
    'FontSize',14,...
    'String',{'(in 1000s)'},...
    'FitBoxToText','off',...
    'LineStyle','none');


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 1000 700]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

% Export to pdf
% -----------------------------------------------------------------------
print(figureHandle, 'output/patents_types.pdf', '-dpdf', '-r0')


%% In addition, make a more coarse figure to be used in shorter 
% presentations

set(0, 'DefaultTextFontName', 'Helvetica') % better font for presentations
set(0, 'DefaultAxesFontName', 'Helvetica')

plotMat_coarse = [sum(plotMat(:, 1:4), 2), sum(plotMat(:, 5:end), 2)];

figureHandle = figure;

for i=1:length(barlines)
    h_gline = plot(t, repmat(barlines(i), length(t)), ...
        'Color', my_gray , 'linewidth', 0.5);
    uistack(h_gline, 'bottom');
    hold on
end
H = bar(1976:2014, plotMat_coarse, 'stacked', 'BarWidth', 0.6);

color1 = [44,123,182]./ 255;
color2 = [215,25,28] ./ 255;
% color1 = [127,188,65] ./ 255;
% color2 = [222,119,174]./ 255;

set(H(1), 'FaceColor', color1)
set(H(1), 'EdgeColor', color1)
set(H(2), 'FaceColor', color2)
set(H(2), 'EdgeColor', color2)

set(gca,'FontSize', 16) % change default font size of axis labels
set(gca,'TickDir','out')  
box off

annotation(figureHandle,'textarrow',[0.2 0.15084388185654],...
    [0.383720930232558 0.295681063122924],...
    'String',{'Share of automation','patents: 25%'},...
    'HorizontalAlignment','center', 'Fontsize', 16);
annotation(figureHandle,'textarrow',[0.844936708860759 0.880801687763713],...
    [0.883527454242928 0.8369384359401],...
    'String',{'Share of automation','patents: 67%'},...
    'HorizontalAlignment','center', 'Fontsize', 16);

annotation(figureHandle,'textbox',...
    [0.62 0.6 0.14 0.075],...
    'String',{'Automation patents'},...
    'FontSize', 18,...
    'FitBoxToText','off',...
    'FontWeight','bold',...
    'LineStyle','none',...
    'Color', color2);

annotation(figureHandle,'textbox',...
    [0.91 0.18 0.094 0.1],...
    'String',{'Rest'},...
    'FontSize', 18,...
    'FontWeight','bold',...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'Color', color1);

annotation(figureHandle,'textbox',...
    [0.0763 0.911 0.14 0.075],...
    'FontSize',14,...
    'String',{'(in 1000s)'},...
    'FitBoxToText','off',...
    'LineStyle','none');


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 1000 700]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

% Export to pdf
% -----------------------------------------------------------------------
print(figureHandle, 'output/patents_types_coarse.pdf', '-dpdf', '-r0')
%print(figureHandle, 'output/patents_types_coarse.emf', '-dmeta', '-r0')
print(figureHandle, 'output/patents_types_coarse.jpg', '-djpeg', '-r0')


