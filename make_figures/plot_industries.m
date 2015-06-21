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



%% Plot
plottime = year_start:year_end;
ix_industry = 24;

industry_name = industry_sumstats{ix_industry, 1, 1};

for ix_period=1:size(industry_sumstats, 3)
    sumstats(ix_period, :) = industry_sumstats{ix_industry, 2, ix_period};
end


industry_nr_pat = sumstats(:, 1);
industry_nr_matches = sumstats(:, 2);
industry_pat_1match = sumstats(:, 3);


figureHandle = figure;
subplot(3,1,1)
plot(plottime, industry_nr_pat, 'Color', color1_pick, 'Marker', 'o', ...
    'MarkerEdgeColor', color1_pick, 'MarkerFaceColor', color1_pick, ...
    'MarkerSize', 1.8)
title('Patents matched to industry')
box off
set(gca,'TickDir','out') 

subplot(3,1,2)
plot(plottime, industry_nr_matches, 'Color', color1_pick, 'Marker', 'o', ...
    'MarkerEdgeColor', color1_pick, 'MarkerFaceColor', color1_pick, ...
    'MarkerSize', 1.8)
title('Keyword matches in industry')
box off
set(gca,'TickDir','out') 

subplot(3,1,3)
plot(plottime, industry_pat_1match, 'Color', color1_pick, 'Marker', 'o', ...
    'MarkerEdgeColor', color1_pick, 'MarkerFaceColor', color1_pick, ...
    'MarkerSize', 1.8)
title('Patents with at least 1 match')
box off
set(gca,'TickDir','out') 

suptitle(industry_name)
set(gcf, 'Color', 'w');




%% Change position and size
set(gcf, 'Position', [300 500 800 700]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


%% Export to pdf
print_pdf_name = horzcat('industry_plots.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
