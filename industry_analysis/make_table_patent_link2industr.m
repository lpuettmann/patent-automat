close all
clear all
clc


addpath('../conversion_patent2industry')
load('nr_appear_allyear.mat')


% Make histogram: patents linked to how many industries
[hist_counts, ~] = hist(nr_appear_allyear, ...
    length(0:max(nr_appear_allyear)));

hist_counts = hist_counts ./ sum(hist_counts);


fprintf('Share of patents linked to at least one industry: %3.2f.\n', ...
    1-hist_counts(1))


%% Make table
print_count = hist_counts * 100;

% Print to .txt file in Latex format
printname = 'table_patlink2industr.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Patents linked to manufacturing industries}}\n');
fprintf(FID,'\\label{tab:patlink2industr}\n');
fprintf(FID,'\\begin{tabular}{lrrrrrrrrrrr}\n');
fprintf(FID,'\\toprule \\addlinespace[0.5em]\n');
fprintf(FID,'\\textbf{Number industries} & \\textbf{0} & \\textbf{1} & \\textbf{2} & \\textbf{3} & \\textbf{4} & \\textbf{5} & \\textbf{6} & \\textbf{7} & \\textbf{8} & \\textbf{9} & \\textbf{10-18}  \\tabularnewline[0.1cm]\n');

fprintf(FID,'  \\textbf{Share} & %3.1f & %3.1f & %3.1f & %3.1f & %3.1f & %3.1f & %3.1f & %3.1f & %3.1f & %3.1f & %3.1f\\tabularnewline[0.1cm]\n', print_count(1), print_count(2), print_count(3), print_count(4), print_count(5), print_count(6), print_count(7), print_count(8), print_count(9), print_count(10), sum(print_count(11:end)));

fprintf(FID,'\\bottomrule\n');
fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\begin{tablenotes}\n');
fprintf(FID,'\\small\n');
fprintf(FID,'\\item\\textit{How to read:} %3.1f percent of patents are not linked to any industry and %3.1f percent of patents are linked to one industry.\n', print_count(1), print_count(2));
fprintf(FID,'\\item\\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID,'\\end{tablenotes}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 


%%
fprintf('Saved: %s.\n', printname)