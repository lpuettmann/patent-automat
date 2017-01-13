function plot_nb_share(year_start, year_end, plot_series, ix_new_year)

%%
plot_settings_global


% Make time series plot of matches per week
my_xaxis_labels = {1976; ''; ''; ''; 1980; ''; ''; ''; ''; 1985; ''; ...
    ''; ''; ''; 1990; ''; ''; ''; ''; 1995; ''; ''; ''; ''; 2000; ''; ...
    ''; ''; ''; 2005; ''; ''; ''; ''; 2010; ''; ''; ''; ''; 2015};

figureHandle = figure;

set(gca,'FontSize', 20) % change default font size of axis labels

barlines = [0.1:0.1:0.7];
for i=1:length(barlines)
    h_gline = plot(1:length(plot_series), repmat(barlines(i), ...
        length(plot_series), 1), 'Color', my_gray , ...
        'linewidth', 0.5);
    uistack(h_gline, 'bottom');
    hold on
end

h_scatter = scatter(1:length(plot_series), plot_series, ...
    'Marker', 'o', 'MarkerEdgeColor', color1_pick);

uistack(h_scatter, 'top');

xlim([1 length(plot_series)])
ylim([0 0.75])
set(gca, 'XTick', ix_new_year) % Set the x-axis tick labels
set(gca, 'xticklabel',{}) % turn x-axis labels off
set(gca, 'xticklabel', my_xaxis_labels); 

set(gca,'TickDir','out')  
box off
set(gcf, 'Color', 'white');

% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 1000 530]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/nb_autompats_share_weekly_', ...
    num2str(year_start), '-', num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
