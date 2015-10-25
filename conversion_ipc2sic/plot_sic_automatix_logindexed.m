function plot_sic_automatix_logindexed(sic_automix_allyears, year_start, ...
    year_end, index_calc_yr)

plot_settings_global

figureHandle = figure;

sic_list = unique( sic_automix_allyears.sic );

for ix_sic=1:length(sic_list)
    pick_sic = sic_list( ix_sic) ;

    find_ix = (sic_automix_allyears.sic == pick_sic);
    six_automix_series = sic_automix_allyears.automix_use(find_ix);

    % Index
    ix_val = find( unique( sic_automix_allyears.year ) == index_calc_yr );
    plotseries = six_automix_series ./ six_automix_series(ix_val) * 100;

    p  = patchline(year_start:year_end, log( plotseries ), ...
        'LineStyle', '-', 'EdgeColor', color3_pick, 'LineWidth', 1.3, ...
            'EdgeAlpha', 0.2);  
    hold on
end

xlim([year_start, year_end])
box off
set(gca,'TickDir','out') 
set(gcf, 'Color', 'w');


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 800 400]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/sic_automatix_logindexed_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
