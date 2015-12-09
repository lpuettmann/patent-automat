function plot_overcat_sic_lautomatix(aggr_automix_share, ...
    sic_overcategories, year_start, year_end, pick_hl)

plot_settings_global

% Make time series plot of matches per week
my_xaxis_labels = {1976; ''; ''; ''; 1980; ''; ''; ''; ''; 1985; ''; ...
    ''; ''; ''; 1990; ''; ''; ''; ''; 1995; ''; ''; ''; ''; 2000; ''; ...
    ''; ''; ''; 2005; ''; ''; ''; ''; 2010; ''; ''; ''; 2014};

figureHandle = figure;
set(gca,'FontSize', 18) % change default font size of axis labels
set(gcf, 'Color', 'w');

for i=1:length(sic_overcategories.letter)

    if i==pick_hl
        color_pick = mystrongred;
        choose_linewidth = 2.2;
    else
        color_pick = my_gray;
        choose_linewidth = 1.3;
    end
    
    hp = plot(year_start:year_end-1, log( aggr_automix_share(1:end-1, i) ), ...
        'Color', color_pick, 'LineWidth',choose_linewidth);
    
    if i==pick_hl
        uistack(hp, 'top')
    else
        uistack(hp, 'bottom')
    end

    box off
    set(gca,'TickDir','out')
    hold on
    
    ylabel('log(Automation index)')
    
%     ylim([0, 10000])
    xlim([year_start, year_end-1])
    set(gca, 'XTick', year_start:year_end-1) % Set the x-axis tick labels
    set(gca, 'xticklabel',{}) % turn x-axis labels off
    set(gca, 'xticklabel', my_xaxis_labels); 
end

titlenames = [sic_overcategories.fullname; {''}];

annotation(figureHandle, 'textbox', ...
    [0.185332182916307 0.776162790697675 0.504918032786885 0.203488372093023], ...
    'String', titlenames(pick_hl), ...
    'FontSize', 20, ...
    'Color', mystrongred, ...    
    'FitBoxToText', 'off', ...
    'LineStyle', 'none');


% Reposition the figure
% -----------------------------------------------------------------------
% set(gcf, 'Position', [100 200 700 300]) % in vector: left bottom width height
set(gcf, 'Position', [100 200 800 500]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/overcat_sic_lautomatix_', ...
    num2str(year_start), '-',  num2str(year_end), '_', num2str(pick_hl), '.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
