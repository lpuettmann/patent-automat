close all
clear all
clc



%% Define parameters
year_start = 1976;
year_end = 2014;



%% Load summary data
load('../conversion_patent2industry/industry_sumstats.mat')


set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')


color1_pick = [49, 130, 189] ./ 255;
my_gray = [0.8, 0.8, 0.8];


%% Plot
plottime = year_start:year_end;
xax_limit = [year_start, year_end];
yax_limit = [0, 3.5];
dim_subplot = [7, 4];


figureHandle = figure;
set(gcf, 'Color', 'w');
suptitle('Average Keyword Matches per Patent in Manufacturing Industries')
for ix_industry=1:size(industry_sumstats, 1)

    industry_name = industry_sumstats{ix_industry, 1, 1};

    for ix_period=1:size(industry_sumstats, 3)
        sumstats(ix_period, :) = industry_sumstats{ix_industry, 2, ix_period};
    end


    industry_nr_pat = sumstats(:, 1);
    industry_nr_matches = sumstats(:, 2);
    
    industry_avg_matches = industry_nr_matches ./ industry_nr_pat;


    subplot(dim_subplot(1), dim_subplot(2), ix_industry)
    plot(plottime, repmat(1, size(plottime)), 'Color', my_gray)
    hold on
    plot(plottime, repmat(2, size(plottime)), 'Color', my_gray)
    hold on
    plot(plottime, repmat(3, size(plottime)), 'Color', my_gray)
    hold on
    
    plot(plottime, industry_avg_matches, 'Color', color1_pick, 'Marker', 'o', ...
        'MarkerEdgeColor', color1_pick, 'MarkerFaceColor', color1_pick, ...
        'MarkerSize', 1.8)
    title(industry_name)
    box off
    set(gca,'TickDir','out') 
    xlim(xax_limit)
    ylim(yax_limit)
    
    leave_xaxis_bottomonly(ix_industry, dim_subplot, ...
        size(industry_sumstats, 1), 'labels') 
end



%% Change position and size
set(gcf, 'Position', [100 100 1800 1100]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


%% Export to pdf
print_pdf_name = horzcat('subplot_industries_averagematches.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

