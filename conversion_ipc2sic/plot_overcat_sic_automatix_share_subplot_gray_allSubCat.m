function plot_overcat_sic_automatix_share_subplot_gray_allSubCat(...
    year_start, year_end, sic_overcategories, sic_automix_allyears, ...
    aggr_automix_share, plot_ix)

%%
close all

plot_settings_global

figureHandle = figure;

titlenames = [sic_overcategories.plot_fullnames; {''}];

set(gca,'FontSize', 12) % change default font size of axis labels
set(gcf, 'Color', 'w');

for j=1:size(sic_overcategories, 1)
    
    subplot(5, 2, j)
    
    pick_hl = plot_ix(j);
    
    pick_sic_overcat = sic_overcategories.letter{pick_hl};

    ix_extr = + strcmp(sic_automix_allyears.overcat, pick_sic_overcat);
    overcat_alldata = sic_automix_allyears(find(ix_extr), :);

    sic_list = unique(overcat_alldata.sic);
    sic_list(sic_list == 0) = [];

    for i=1:length(sic_list)

        pick_sic = sic_list(i);
        ix_sic = (overcat_alldata.sic == pick_sic);

        sic_rel_automix = overcat_alldata.automix_use(ix_sic) ./ ...
            overcat_alldata.patents_use(ix_sic);

        hp = plot(year_start:year_end-1, sic_rel_automix(1:end-1), ...
            'Color', my_gray, 'LineWidth', 0.6);
        ylim([0, 1])
        xlim([year_start, year_end-1])
        box off
        hold on
    end
    
    set(gca,'TickDir','out')
    hp = plot(year_start:year_end-1, aggr_automix_share(1:end-1, pick_hl), ...
        'Color', color1_pick, 'LineWidth', 2.5);

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
print_pdf_name = horzcat('output/overcat_sic_automatix_share_subplot_gray_allSubCat_', ...
    num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
