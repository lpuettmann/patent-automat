function plot_overcat_sic_automatix_share_subplot(aggr_automix_share, ...
    sic_overcategories, year_start, year_end, plot_ix)

plot_settings_global

color_pick = color1_pick;
choose_linewidth = 1.5;

figureHandle = figure;
titlenames = [sic_overcategories.plot_fullnames; {''}];

set(gca,'FontSize', 12) % change default font size of axis labels
set(gcf, 'Color', 'w');

for j=1:size(sic_overcategories, 1)
    
    subplot(5, 2, j)

    pick_hl = plot_ix(j);

    hp = plot(year_start:year_end-1, aggr_automix_share(1:end-1, pick_hl), ...
        'Color', color_pick, 'LineWidth',choose_linewidth);

    box off
    set(gca,'TickDir','out')
    hold on

    ylim([0, 0.65])
    xlim([year_start, year_end-1])
    
    title( titlenames(pick_hl) )
end



% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 800 1000]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/overcat_sic_automatix_share_subplot_', ...
    num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
