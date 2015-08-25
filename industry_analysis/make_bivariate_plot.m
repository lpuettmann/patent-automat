function make_bivariate_plot(fyr_start, fyr_end, industry_sumstats, ...
    laborm_series)

%%
close all

% Set font
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')


figureHandle = figure;

for ix_industry = 1:26
    single_laborm_series = laborm_series(:, ix_industry);

    ix_fulldata = find( not( isnan(single_laborm_series) ) );

    data_yr_start = fyr_start + ix_fulldata(1) - 1;
    data_yr_end = fyr_start + ix_fulldata(end) - 1;


    automat_ishare = nan(length(fyr_start:fyr_end), 1);
    for i=1:length(fyr_start:fyr_end)
        automat_ishare(i) = industry_sumstats(ix_industry, 2, i) ./ ...
            industry_sumstats(ix_industry, 1, i);
    end



    scatter(automat_ishare, single_laborm_series, 'Marker', 'square')
    hold on
    ylabel('Employment in 1000s')
    xlabel('Share of automation patents')
    % xlim([0, 1])
end
hold off

box off
set(gcf, 'Color', 'w');
set(gca,'FontSize',12)




% Change position and size
set(gcf, 'Position', [100 200 900 600]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

% Export to pdf
print(figureHandle, 'output/scatter_autompat_vs_laborm.pdf', '-dpdf', '-r0')

