function plot_automix_vs_rti(year_start, year_end, sic_summary)

pick_series1 = sic_summary.automix_use_log_sum;
pick_series2 = sic_summary.rti60;
pick_series3 = sic_summary.rel_automix_mean;

ix_color = find( sic_summary.ix_manufact );


plot_settings_global()

figureHandle = figure;

set(gca,'FontSize', 16) % change default font size of axis labels
set(gcf, 'Color', 'w');
box off

subplot(2, 2, 1)
scatter(pick_series1, pick_series2, ...
    'Marker', '.', 'MarkerEdgeColor', [0.6, 0.6, 0.6])

hold on
ylabel('Share of routine labor 1960')
xlabel('log( total automation index )')
set(gca,'TickDir','out')
ylim([0, 1])

subplot(2, 2, 2)
scatter(pick_series3( not( ix_color ) ), ...
    pick_series2( not( ix_color ) ), ...
    'Marker', '.', 'MarkerEdgeColor', color_list(8,:))
hold on
scatter(pick_series3(ix_color), pick_series2(ix_color), ...
    'Marker', '.', 'MarkerEdgeColor', color_list(5,:))
hold on
xpush = linspace(0, 1, 100);
mdl = fitlm(pick_series3(ix_color), ...
    pick_series2(ix_color));
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1.5, 'Color', color_list(4,:));

ylabel('Share of routine labor 1960')
xlabel('Relative automation index')
set(gca,'TickDir','out')
xlim([0, 1])
ylim([0, 1])

subplot(2, 2, 3)
scatter(pick_series3( not( ix_color ) ), ...
    pick_series2( not( ix_color ) ), ...
    'Marker', '.', 'MarkerEdgeColor', color_list(8,:))
title('Not manufacturing')

ylabel('Share of routine labor 1960')
xlabel('Relative automation index')
set(gca,'TickDir','out')
ylim([0, 1])

subplot(2, 2, 4)
scatter(pick_series3(ix_color), ...
    pick_series2(ix_color), ...
    'Marker', '.', 'MarkerEdgeColor', color_list(5,:))
title('Manufacturing')

ylabel('Share of routine labor 1960')
xlabel('Relative automation index')
set(gca,'TickDir','out')
ylim([0, 1])


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 800 500]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/rel_automix_vs_rti60_', ...
    num2str(year_start), '-',  num2str(year_end), '.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
