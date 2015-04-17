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
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Share of automation patents}}\n');
fprintf(FID,'\\label{tab:word_distribution}\n');
fprintf(FID,'\\begin{tabular}{lrrrllrrr}\n'); 
fprintf(FID,'\\toprule \\addlinespace[0.5em]\n');
fprintf(FID,' & \\textbf{A$^1$} & \\textbf{P} & \\%% & \\phantom{aaa} & & \\textbf{A$^1$} & \\textbf{P} & \\%% \\tabularnewline[0.1cm]\n');
fprintf(FID,'\\midrule \\addlinespace[0.5em]\n');

addyear = 20;

for t=1:floor(length(patent_match_summary.nr_patents_yr) / 2)
    ix_year = year_start + t - 1;
   
    fprintf(FID,'%d & %d & %d & %3.1f & & %d & %d & %d & %3.1f \\tabularnewline[0.1cm]\n', ix_year, patent_match_summary.nr_distinct_patents_hits(t), patent_match_summary.nr_patents_yr(t), patent_match_summary.nr_distinct_patents_hits(t)/patent_match_summary.nr_patents_yr(t)*100, ix_year + addyear, patent_match_summary.nr_distinct_patents_hits(t + addyear), patent_match_summary.nr_patents_yr(t + addyear), patent_match_summary.nr_distinct_patents_hits(t + addyear)/patent_match_summary.nr_patents_yr(t + addyear)*100);
end


fprintf(FID,'\\bottomrule\n');
fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 


%%
fprintf('Saved: %s.\n', printname)

