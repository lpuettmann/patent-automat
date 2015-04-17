close all
clear all
clc

% Define parameters
year_start = 1976;
year_end = 2015;





%% Load patent match summary data
build_load_filename = horzcat('patent_match_summary_', num2str(year_start), ...
    '-', num2str(year_end), '.mat');
load(build_load_filename)


%% Print some summaries
fprintf('Total number of identified patents all years: %d.\n', ...
    sum(patent_match_summary.nr_patents_yr))

fprintf('Total number of keyword matches in all years: %d.\n', ...
    sum(patent_match_summary.total_matches_yr))


%% Load data on how many patents are matched to industries
addpath('conversion_patent2industry')
load('share_patents_linked.mat')



%% Make table

% Print to .txt file in Latex format
printname = 'table_overview.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Overview of yearly matched patents}}\n');
fprintf(FID,'\\label{tab:word_distribution}\n');
fprintf(FID,'\\begin{tabular}{lrrrrr}\n');
fprintf(FID,'\\toprule \\addlinespace[0.5em]\n');
fprintf(FID,' & \\textbf{Automation} & \\textbf{Total} & \\textbf{Share (\\%%)} & & \\textbf{Share matched} \\tabularnewline[0.05cm]\n');
fprintf(FID,' & \\textbf{patents$^1$} & \\textbf{patents} &  &  & \\textbf{to industries (\\%%)} \\tabularnewline[0.1cm]\n');
fprintf(FID,'\\cmidrule(l){2-4} \\cmidrule(l){6-6} \\addlinespace[0.5em] \n');

for t=1:length(patent_match_summary.nr_patents_yr)
    ix_year = year_start + t - 1;
    
    if ix_year == 2015
       fprintf(FID,'2015$^2$ & %d & %d & %3.1f & & -- \\tabularnewline[0.1cm]\n', patent_match_summary.nr_distinct_patents_hits(t), patent_match_summary.nr_patents_yr(t), patent_match_summary.nr_distinct_patents_hits(t)/patent_match_summary.nr_patents_yr(t)*100);
    else
        fprintf(FID,'%d & %d & %d & %3.1f & & %3.1f \\tabularnewline[0.1cm]\n', ix_year, patent_match_summary.nr_distinct_patents_hits(t), patent_match_summary.nr_patents_yr(t), patent_match_summary.nr_distinct_patents_hits(t)/patent_match_summary.nr_patents_yr(t)*100, share_patents_linked(t)*100);
    end
end


fprintf(FID,'\\textbf{Total} & \\textbf{%d} & \\textbf{%d} & \\textbf{%3.1f} &  & \\textbf{%3.1f}\\tabularnewline[0.1cm]\n', sum(patent_match_summary.nr_distinct_patents_hits), sum(patent_match_summary.nr_patents_yr), sum(patent_match_summary.nr_distinct_patents_hits)/sum(patent_match_summary.nr_patents_yr)*100, mean(share_patents_linked)*100);

fprintf(FID,'\\bottomrule\n');
fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\begin{tablenotes}\n');
fprintf(FID,'\\small\n');
fprintf(FID,'\\item $^1$: automation patents are defined as patents with at least one keyword match.\n');

if year_end == 2015
    fprintf(FID,'\\item $^2$: up to 23.03.2015.\n');
end

fprintf(FID,'\\item \\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID,'\\end{tablenotes}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 


%%
fprintf('Saved: %s.\n', printname)

