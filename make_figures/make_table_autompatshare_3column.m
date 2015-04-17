close all
clear all
clc

% Define parameters
year_start = 1976;
year_end = 2015;





%% Load summary data
build_load_filename = horzcat('patent_match_summary_', num2str(year_start), ...
    '-', num2str(year_end), '.mat');
load(build_load_filename)


%% Print some summaries
fprintf('Total number of identified patents all years: %d.\n', ...
    sum(patent_match_summary.nr_patents_yr))


%% Make table

% Print to .txt file in Latex format
printname = 'table_autompat_share.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Share of automation patents}}\n');
fprintf(FID,'\\label{tab:word_distribution}\n');
fprintf(FID,'\\begin{tabular}{lrrrllrrrllrrr}\n'); 
fprintf(FID,'\\toprule \\addlinespace[0.5em]\n');
fprintf(FID,' & \\textbf{\\#A$^1$} & \\textbf{\\#P$^1$} & \\textbf{\\%%} & \\phantom{aaa} & & \\textbf{\\#A$^1$} & \\textbf{\\#P$^1$} & \\textbf{\\%%} & \\phantom{aaa} & & \\textbf{\\#A$^1$} & \\textbf{\\#P$^1$} & \\textbf{\\%%}\\tabularnewline[0.1cm]\n');
fprintf(FID,'\\midrule \\addlinespace[0.5em]\n');

addyear = 13;
addyear2 = addyear*2;

for t=1:13
    ix_year = year_start + t - 1;
   
    fprintf(FID,'%d & %d & %d & %3.1f & & %d & %d & %d & %3.1f & & %d & %d & %d & %3.1f \\tabularnewline[0.1cm]\n', ix_year, patent_match_summary.nr_distinct_patents_hits(t), patent_match_summary.nr_patents_yr(t), patent_match_summary.nr_distinct_patents_hits(t)/patent_match_summary.nr_patents_yr(t)*100, ix_year + addyear, patent_match_summary.nr_distinct_patents_hits(t + addyear), patent_match_summary.nr_patents_yr(t + addyear), patent_match_summary.nr_distinct_patents_hits(t + addyear)/patent_match_summary.nr_patents_yr(t + addyear)*100, ix_year + addyear2, patent_match_summary.nr_distinct_patents_hits(t + addyear2), patent_match_summary.nr_patents_yr(t + addyear2), patent_match_summary.nr_distinct_patents_hits(t + addyear2)/patent_match_summary.nr_patents_yr(t + addyear2)*100);
end
 
fprintf(FID,'& & & & & & & & & & 2015$^3$ & %d & %d & %3.1f  \\tabularnewline[0.1cm]\n', patent_match_summary.nr_distinct_patents_hits(end), patent_match_summary.nr_patents_yr(end), patent_match_summary.nr_distinct_patents_hits(end)/patent_match_summary.nr_patents_yr(end)*100);
fprintf(FID,'& & & & & & & & & & \\textbf{Total} & \\textbf{%d} & \\textbf{%d} & \\textbf{%3.1f} \\tabularnewline[0.1cm]\n', sum(patent_match_summary.nr_distinct_patents_hits), sum(patent_match_summary.nr_patents_yr), sum(patent_match_summary.nr_distinct_patents_hits)/sum(patent_match_summary.nr_patents_yr)*100);

fprintf(FID,'\\bottomrule\n');
fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\begin{tablenotes}\n');
fprintf(FID,'\\small\n');
fprintf(FID,'\\item $^1$: \\#A = number of automation patents. Automation patents are defined as patents with at least one keyword match.\n');
fprintf(FID,'\\item $^2$: \\#P = total number of patents.\n');

if year_end == 2015
    fprintf(FID,'\\item $^3$: up to 23.03.2015.\n');
end

fprintf(FID,'\\item \\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID,'\\end{tablenotes}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 


%%
fprintf('Saved: %s.\n', printname)

