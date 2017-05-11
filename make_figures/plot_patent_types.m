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

plot_settings_global()
figureHandle = figure;

H = bar(1976:2014, plotMat, 'stacked');

for k = 1:size(plotMat,2)
  set(H(k), 'FaceColor', colors(k,:))
  set(H(k), 'EdgeColor', colors(k,:))
end

legend('Rest: Other and missing data', 'Rest: Chemical and pharma',  ...
    'Rest: Electric and mechanic', 'Rest: Computers and Communications', ...
    'Automation patents: Other and missing data', 'Automation patents: Chemical and pharma',  ...
    'Automation patents: Electric and mechanic', 'Automation patents: Computers and Communications', ...
    'Location', 'NorthWest')

barlines = [50000:50000:300000];
hold on
for i=1:length(barlines)
    h_gline = plot(1975:2015, repmat(barlines(i), length(1975:2015), 1),...
        'Color', my_gray , 'Linewidth', 0.5);
    uistack(h_gline, 'bottom');
    hold on
end
legend boxoff  
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
