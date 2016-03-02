function plot_nb_autompat_yearly(year_start, year_end, plot_series)

plottime = year_start:year_end;

plot_settings_global

figureHandle = figure;

barlines = [0.1:0.1:0.7];
for i=1:length(barlines)
    h_gline = plot(plottime, repmat(barlines(i), ...
        length(plot_series), 1), 'Color', my_gray , ...
        'linewidth', 0.5);
    uistack(h_gline, 'bottom');
    hold on
end

plot(plottime, plot_series, 'Color', color1_pick, 'Linewidth', 0.6, ...
    'Marker', 'o', 'MarkerEdgeColor', color1_pick, 'MarkerFaceColor', ...
    color1_pick, 'Markersize', 3)
ylim([0, 0.77])
xlim([year_start, year_end])
title('Share of patents classified as automation patents')
set(gca,'FontSize', 11) % change default font size of axis labels
set(gca,'TickDir','out')  
box off
set(gcf, 'Color', 'w');


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 600 300]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/nb_autompats_', ...
    num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')