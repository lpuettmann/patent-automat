close all
clear all
clc

% Define parameters
year_start = 1976;
year_end = 2014;





%% Load summary data
build_load_filename = horzcat('patent_match_summary_', num2str(year_start), ...
    '-', num2str(year_end), '.mat');
load(build_load_filename)


%% Print some summaries
fprintf('Total number of identified patents all years: %d.\n', ...
    sum(patent_match_summary.nr_patents_yr))



%% Some settings for the plots
plot_time = year_start:year_end;
color1_pick = [0.7900, 0.3800, 0.500];
color2_pick = [0.000,0.639,0.561];
color3_pick = [0.890,0.412,0.525];
color4_pick = [0.890,0.412,0.525];

color1_pick = [49, 130, 189] ./ 255; % necessary conversion to RGB  
color2_pick = [158, 202, 225] ./ 255;

my_light_gray = [0.95, 0.95, 0.95];
my_dark_gray = [0.8, 0.8, 0.8];


figureHandle = figure;

% Plot total number of identified patents per year
bar(plot_time, patent_match_summary.nr_patents_yr, 'FaceColor', ...
    color1_pick, 'EdgeColor', 'k')
hold on
bar(plot_time, patent_match_summary.nr_distinct_patents_hits, ...
    'FaceColor', color2_pick, 'EdgeColor', 'k')
hold off

set(gca,'FontSize',12) % change default font size of axis labels
box off
set(gca,'TickDir','out'); 
ylim([0 400000])
set(gca, 'YTickLabel', num2str(get(gca, 'YTick')')) % turn scientific notation off

get(gca, 'YTickLabel');
new_yticks = {'0'; ''; '100000'; ''; '200000'; ''; '300000'; ''; '400000'};
set(gca, 'yticklabel', new_yticks); 

xlim([year_start-0.5, year_end+1.5])

% General settings
set(gcf, 'Color', 'w');

set(0,'DefaultTextFontName','Palatino') % set font
set(0,'DefaultAxesFontName','Palatino') % set font




%% Change position and size
set(gcf, 'Position', [100 200 700 400]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


%% Add text
arrow_x = [0.169, 0.15];
arrow_y = [0.32, 0.26];
annotation('textarrow', arrow_x, arrow_y, 'String', '70900', ...
        'FontSize', 12, 'HorizontalAlignment', 'left', ...
        'HeadStyle', 'none'); % [x y w h]
    
annotation('textarrow',[0.861157082748948 0.872370266479663],...
    [0.83452380952381 0.792857142857143],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'FontSize',12,...
    'String','327000',...
    'HeadStyle','none');



%% Export to pdf
print_pdf_name = horzcat('barchart_identified_patents_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')




%% Make table

% Print to .txt file in Latex format
printname = 'table_autompat_share.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Overview}}\n');
fprintf(FID,'\\label{tab:word_distribution}\n');
fprintf(FID,'\\begin{tabular}{lrrr}\n');
fprintf(FID,'\\toprule \\addlinespace[0.5em]\n');
fprintf(FID,' & \\textbf{Automation patents} & \\textbf{Total patents} & \\textbf{Share (\\%%)}\\tabularnewline[0.1cm]\n');
fprintf(FID,'\\midrule \\addlinespace[0.5em]\n');

for t=1:length(patent_match_summary.nr_patents_yr)
    ix_year = year_start + t - 1;
    fprintf(FID,'%d & %d & %d & %3.1f \\tabularnewline[0.1cm]\n', ix_year, patent_match_summary.nr_distinct_patents_hits(t), patent_match_summary.nr_patents_yr(t), patent_match_summary.nr_distinct_patents_hits(t)/patent_match_summary.nr_patents_yr(t)*100);
end

fprintf(FID,' & \\textbf{%d} & \\textbf{%d} & \\textbf{%3.1f} \\tabularnewline[0.1cm]\n', sum(patent_match_summary.nr_distinct_patents_hits), sum(patent_match_summary.nr_patents_yr), sum(patent_match_summary.nr_distinct_patents_hits)/sum(patent_match_summary.nr_patents_yr)*100);

fprintf(FID,'\\bottomrule\n');
fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\begin{tablenotes}\n');
fprintf(FID,'\\small\n');
fprintf(FID,'\\item \\textit{Note:} Automation patents are defined as patents with at least one keyword match; both categories exclude named patents such as design patents.\n');
fprintf(FID,'\\item \\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID,'\\end{tablenotes}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 


%%
fprintf('Saved: %s.\n', printname)

