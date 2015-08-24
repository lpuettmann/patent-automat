function subplot_industries_alg1(fyr_start, fyr_end, industry_sumstats, ...
    ind_corresp)


%% Load summary data

set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')


color1_pick = [49, 130, 189] ./ 255;



%% Plot
plottime = fyr_start:fyr_end;
xax_limit = [fyr_start, fyr_end];
yax_limit = [0, 250000];
dim_subplot = [7, 4];


figureHandle = figure;
set(gcf, 'Color', 'w');

for ix_industry=1:size(industry_sumstats, 1)

    industry_name = ind_corresp{ix_industry, 2};

    for ix_period=1:size(industry_sumstats, 3)
        plotseries(ix_period) = industry_sumstats(ix_industry, 2, ix_period);
    end

    subplot(dim_subplot(1), dim_subplot(2), ix_industry)
    plot(plottime, plotseries, 'Color', color1_pick, 'Marker', 'o', ...
        'MarkerEdgeColor', color1_pick, 'MarkerFaceColor', color1_pick, ...
        'MarkerSize', 1.8)
    title(industry_name)
    box off
    set(gca,'TickDir','out') 
    xlim(xax_limit)
end



%% Change position and size
set(gcf, 'Position', [100 100 1800 1100]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


%% Export to pdf
print_pdf_name = horzcat('output/subplot_industries_alg1.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

