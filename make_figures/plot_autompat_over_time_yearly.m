load('output/nb_stats.mat');

year_end = 2014;
plottime = year_start:year_end;

plot_series = nb_stats.yearstats.shareAutomat(1:end-1);
plot_series = nb_stats.yearstats.nrAutomat(1:end-1);

plot_settings_global

figureHandle = figure;

barlines = [0.1:0.1:0.7];
 barlines = [25000:25000:200000];
for i=1:length(barlines)
    h_gline = plot(plottime, repmat(barlines(i), ...
        length(plot_series), 1), 'Color', my_gray , ...
        'linewidth', 0.5);
    uistack(h_gline, 'bottom');
    hold on
end

plot(plottime, plot_series, 'Color', 'black', 'Linewidth', 2, ...
    'Marker', 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', ...
    'black', 'Markersize', 5)
% ylim([0, 0.77])
xlim([year_start, year_end])
set(gca,'FontSize', 20) % change default font size of axis labels
set(gca,'TickDir','out')  
box off
set(gcf, 'Color', 'w');
curtick = get(gca, 'YTick');
set(gca, 'YTickLabel', cellstr(num2str(curtick(:))));


% Reposition the figure
% -----------------------------------------------------------------------
%set(gcf, 'Position', [100 200 600 420]) % in vector: left bottom width height
set(gcf, 'Position', [100 200 600 350]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/nb_autompats_', ...
    num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

