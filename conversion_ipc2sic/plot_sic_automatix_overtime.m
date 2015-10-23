function plot_sic_automatix_overtime(sic_automix_allyears, year_start, ...
    year_end)

plot_settings_global

figureHandle = figure;

sic_list = unique( sic_automix_allyears.sic );

for ix_sic=1:length(sic_list)
    pick_sic = sic_list( ix_sic) ;

    find_ix = (sic_automix_allyears.sic == pick_sic);
    six_automix_series = sic_automix_allyears.automix_use(find_ix);

    p  = patchline(year_start:year_end, six_automix_series, ...
        'LineStyle', '-', 'EdgeColor', color3_pick, 'LineWidth', 1.3, ...
            'EdgeAlpha', 0.2);  
    hold on
end

xlim([year_start, year_end])
box off
set(gca,'TickDir','out') 
set(gcf, 'Color', 'w');
