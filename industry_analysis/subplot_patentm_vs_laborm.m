%% Make subplots 
% Plot settings
dim_subplot = [7, 4];
color1_pick = [49, 130, 189] ./ 255;
my_light_gray = [0.5, 0.5, 0.5];
my_dark_gray = [0.3, 0.3, 0.3];

set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

plottime = year_start:year_end;
xax_limit = [year_start, year_end];
yax_limit = [0, 2];

figureHandle = figure;
set(gcf, 'Color', 'w');

for ix_industry=1:size(industry_sumstats, 1)
    
    laborm_pick = laborm_plotsave(:, ix_industry);
    patent_metric_pick = patent_metric_plotsave(:, ix_industry);
    
    
    % Save changes in series for scatterplot
    notnanval = find(not(isnan(laborm_pick)));


    % Test if all data for this industry is NaN
    if isempty(notnanval)
        labormarket_change(ix_industry) = nan;
        patent_metric_change(ix_industry) = nan;
    else
        first_val = notnanval(1);
        last_val = notnanval(end);
        labormarket_change(ix_industry) = laborm_pick(last_val) / laborm_pick(first_val);
        patent_metric_change(ix_industry) = patent_metric_pick(last_val) / patent_metric_pick(first_val);
    end


    % Normalize for plot
    pick_normalization_date = 2000;
    pick_normalization_index = pick_normalization_date-year_start+1;

    laborm_pick = laborm_pick / laborm_pick(pick_normalization_index);
    patent_metric_pick = patent_metric_pick / patent_metric_pick(pick_normalization_index);


    % Make a time series plot with both series
    subplot(7, 4, ix_industry)
    plot(plottime, laborm_pick, plottime, patent_metric_pick)
    hold on
    xlim(xax_limit)
    ylim(yax_limit)

    hx = graph2d.constantline(pick_normalization_date, 'LineStyle',':', ...
        'Color', my_dark_gray);
    changedependvar(hx,'x');


    % Calculate correlation where we have data (ignoring NaNs)
    correlation_plotseries = corrcoef(laborm_pick, ...
        patent_metric_pick, 'rows','complete');
    correlation_plotseries = correlation_plotseries(1,2);


    % Save the correlations between all variables for all industries
    corr_laborm_patentm(ix_patentmetric, ix_labormvar, ix_industry) = correlation_plotseries;

    titlestring = sprintf('%s (%3.2f)', industry_name, correlation_plotseries);
    title(titlestring)
    box off
    set(gca,'TickDir','out') 
    leave_xaxis_bottomonly(ix_industry, dim_subplot, ...
        size(industry_sumstats, 1), 'labels')


    legend('Labor market statistic', 'Automation statistic', 'Location', 'NorthEastOutside')


    % Change position and size
    set(gcf, 'Position', [100 100 1500 900]) % in vector: left bottom width height
    set(figureHandle, 'Units', 'Inches');
    pos = get(figureHandle, 'Position');
    set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
        'Inches', 'PaperSize', [pos(3), pos(4)])


    % Export to pdf
    print_pdf_name = horzcat('subplot_industry_vs_', labormvar, '.pdf');
    print(figureHandle, print_pdf_name, '-dpdf', '-r0')
end

