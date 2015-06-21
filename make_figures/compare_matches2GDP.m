close all
clear all
clc



%%
year_start = 1976;
year_end = 2015;



%% Load United States real GDP 1975-2014
raw_excel_data = xlsread('gdplev.xls');
rgdp = raw_excel_data(48:86, 3);


addpath('../functions'); % for gridxy

%% Load patent matches summary
load('patent_match_summary_1976-2015')

nr_patents_yr = patent_match_summary.nr_patents_yr(1:end-1);
total_matches_yr = patent_match_summary.total_matches_yr(1:end-1);
total_automix_yr = patent_match_summary.total_automix_yr(1:end-1);


%% Normalize series
rgdp_norm = rgdp ./ rgdp(1);
nr_patents_yr_norm = nr_patents_yr ./ nr_patents_yr(1);
total_matches_yr_norm = total_matches_yr ./ total_matches_yr(1);
total_automix_yr_norm = total_automix_yr ./ total_automix_yr(1);

% lambda = 100;

% [rgdp_norm, ~]= hpfilter(rgdp_norm, lambda);
% [nr_patents_yr_norm, ~] = hpfilter(nr_patents_yr_norm, lambda);
% [total_matches_yr_norm, ~] = hpfilter(total_matches_yr_norm, lambda);
% [total_automix_yr_norm, ~] = hpfilter(total_automix_yr_norm, lambda);
% 
% [~, rgdp_norm]= hpfilter(rgdp_norm, lambda);
% [~, nr_patents_yr_norm] = hpfilter(nr_patents_yr_norm, lambda);
% [~, total_matches_yr_norm] = hpfilter(total_matches_yr_norm, lambda);
% [~, total_automix_yr_norm] = hpfilter(total_automix_yr_norm, lambda);



%% Make plot

% % Set font
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

% Colors
color1_pick = [244,165,130]./ 255;
color2_pick = [33,102,172]./ 255;
color3_pick = [178,24,43]./ 255;
my_gray = [0.8, 0.8, 0.8];

plottime = year_start:year_end-1;

figureHandle = figure;

plot(plottime, nr_patents_yr_norm, 'Color', color1_pick, 'LineWidth', 1.5, ...
    'Marker', 'o', 'MarkerSize', 1.8, 'MarkerFaceColor', color1_pick)
hold on
plot(plottime, rgdp_norm, 'Color', color2_pick, 'LineWidth', 1.5, ...
    'Marker', 'square', 'MarkerSize', 1.8, 'MarkerFaceColor', color2_pick)
hold on
plot(plottime, total_matches_yr_norm, 'Color', color3_pick, 'LineWidth', 1.5, ...
    'Marker', 'diamond', 'MarkerSize', 1.8, 'MarkerFaceColor', color3_pick)
hold on
set(gca,'TickDir','out') 
box off
set(gcf, 'Color', 'w');
xlim([plottime(1) plottime(end)+0.5])
xticks = get(gca, 'XTick');
xticks = [1976, xticks, 2014];
set(gca, 'XTick', xticks) % Set the x-axis tick labels

yLimits = get(gca,'YLim');

ygrid_lines = [yLimits(1):1:yLimits(end)];
ygrid_lines(find(ygrid_lines==yLimits(1))) = []; % remove bottom grid line
ygrid_lines(find(ygrid_lines==yLimits(2))) = []; % remove grid line at the top
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', 0.9);

ax2 = axes('Position', get(gca, 'Position'),'Color','none');
set(ax2,'XTick',[], 'YTick',[], 'YColor','w')





%% Change position and size
set(gcf, 'Position', [100 200 700 400]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


%% Add text
% Create textarrow
annotation(figureHandle,'textarrow',[0.79523842917251 0.817671809256662],...
    [0.739285714285719 0.695238095238096],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'FontSize',12,...
    'String','Matches',...
    'Color', color3_pick, ...
    'HeadStyle','none');


% Create textarrow
annotation(figureHandle,'textarrow',[0.289617110799439 0.290322580645161],...
    [0.34857142857143 0.3],'TextEdgeColor','none','HorizontalAlignment','left',...
    'FontSize',12, ...
    'String','Real GDP',...
    'Color', color2_pick, ...
    'HeadStyle','none');

% Create textarrow
annotation(figureHandle,'textarrow',[0.553983169705467 0.544179523141655],...
    [0.258095238095241 0.271428571428572],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'FontSize',12,...
    'String','Patents',...
    'HeadStyle','none',...
    'Color',[0.956862745098039 0.647058823529412 0.509803921568627]);




%% Export to pdf
print_pdf_name = horzcat('compare_w_rGDP_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
