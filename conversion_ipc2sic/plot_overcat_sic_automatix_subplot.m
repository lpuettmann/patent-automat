function plot_overcat_sic_automatix_subplot(aggr_automix, ...
    sic_overcategories, year_start, year_end)

plot_settings_global

figureHandle = figure;
 
set(gcf, 'Color', 'w');

for i=1:length(sic_overcategories.letter)

    subplot(4, 3, i) 
    plot(year_start:year_end-1, aggr_automix(1:end-1, i), ...
        'Color', color3_pick, 'LineWidth', 1.3)
    
    title(sic_overcategories.fullname{i})
    xlim([year_start, year_end-1])
    box off
    set(gca,'TickDir','out')
end


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 1400 900]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/overcat_sic_automatix_subplot_', ...
    num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
