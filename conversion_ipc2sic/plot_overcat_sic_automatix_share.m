function plot_overcat_sic_automatix_share_subplot(aggr_automix_share, ...
    sic_overcategories, year_start, year_end)

plot_settings_global

figureHandle = figure;
 
set(gcf, 'Color', 'w');

for i=1:length(sic_overcategories.letter)

    plot(year_start:year_end-1, aggr_automix_share(1:end-1, i), ...
        'Color', color_list(i, :), 'LineWidth', 1.8)

    ylim([0, 1])
    xlim([year_start, year_end-1])
    box off
    set(gca,'TickDir','out')
    hold on
end


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 700 300]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/overcat_sic_automatix_share_', ...
    num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
