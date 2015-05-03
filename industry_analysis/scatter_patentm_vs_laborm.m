
% Scatterplot

figureHandle = figure;
scatter(patent_metric_change, labormarket_change, ...
    'Marker', 'o', 'MarkerEdgeColor', my_dark_gray, 'MarkerFaceColor', ...
    my_dark_gray)
box off
set(gca,'TickDir','out') 
set(gcf, 'Color', 'w');
ylabel('Change in labor market')
xlabel('Change in patent match metric')
hl = lsline;
xlim([0, 3])
ylim([0, 3])
set(hl, 'Color', my_light_gray);
uistack(hl, 'bottom')
titlephrase = sprintf('Correlation: %3.2f', corr(labormarket_change', patent_metric_change'));
title(titlephrase)

% Add a 45 degree line
h_45line = refline([1 0]);
set(h_45line, 'Color', 'black', 'Linestyle', '--');
uistack(h_45line, 'bottom')


% Change position and size
set(gcf, 'Position', [100 100 900 500]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
print_pdf_name = horzcat('scatter_patentmatches_vs_', labormvar, '.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

