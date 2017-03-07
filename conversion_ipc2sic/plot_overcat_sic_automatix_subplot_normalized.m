function plot_overcat_sic_automatix_subplot(norm_aggr_automix, ...
    sic_overcategories, year_start, year_end, plot_ix)

plot_settings_global

figureHandle = figure;
 
set(gcf, 'Color', 'w');

set(gca,'FontSize', 12) % change default font size of axis labels

% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 800 1000]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

for j=1:length(sic_overcategories.letter)

    subplot(5, 2, j) 
    
    i = plot_ix(j);

    plot(year_start:year_end-1, norm_aggr_automix(1:end-1, i), ...
        'Color', color1_pick, 'LineWidth', 1.3)
    
    title(sic_overcategories.plot_fullnames{i})
    ylim([0, ceil(max(norm_aggr_automix(1:end-1, i)) * 1.2)])
    xlim([year_start, year_end-1])
    box off
    set(gca,'TickDir','out')
end


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/overcat_sic_automatix_subplot_normalized_', ...
    num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
