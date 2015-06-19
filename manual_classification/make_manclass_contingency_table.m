close all
clear all
clc

% Save contingency table to .tex


%% Load stats on classifications
load('conttab.mat')


%% Print to .txt file in Latex format
printname = 'table_contingency_classfc.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Contingency table}}\n');
fprintf(FID,'\\label{table:contingency_classifications}\n');
fprintf(FID,'\\begin{tabular}{ll|ll|ll|ll|ll}\n');

fprintf(FID, '& & \\multicolumn{7}{c}{Computerized} \\tabularnewline[0.1cm]\n');
fprintf(FID, '& & \\multicolumn{3}{c}{$A_1$} & & \\multicolumn{3}{c}{$A_2$} \\tabularnewline[0.1cm]\n');
fprintf(FID, '& & No & Yes & & & No & Yes &  \\tabularnewline\n');
fprintf(FID, '\\cline{2-5} \\cline{7-9}\n');
fprintf(FID, '\\parbox[t]{2mm}{\\multirow{2}{*}{\\rotatebox[origin=c]{90}{Manual}}} & No & %d & %d & %d & & %d & %d & %d \\tabularnewline\n', conttab.val(1,:,1), conttab.val(1,:,2));
fprintf(FID, '& Yes & %d & %d & %d & & %d & %d & %d \\tabularnewline\n', conttab.val(2,:,1), conttab.val(2,:,2));
fprintf(FID, '\\cline{2-5} \\cline{7-9}\n');
fprintf(FID, '&  & %d & %d & %d & & %d & %d & %d \\tabularnewline\n', conttab.val(3,:,1), conttab.val(3,:,2));

fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');

fprintf(FID,'\\floatfoot{');
fprintf(FID,'\\begin{minipage}{0.3\\textwidth}');
fprintf(FID,' \\textit{Statistics:}\\\\\n');
fprintf(FID,'Accuracy = $\\frac{%d + %d}{%d}$ = %3.2f\\\\\n', ...
    conttab.stats{1});
fprintf(FID,'Precision = $\\frac{%d}{%d}$ = %3.2f\\\\\n', conttab.stats{2});
    
fprintf(FID,'Recall = $\\frac{%d}{%d}$ = %3.2f\\\\\n', conttab.stats{3});
    
fprintf(FID,'$F_{\\beta = %d}$ = %3.2f\\\\\n', conttab.stats{4});
fprintf(FID,'AUC = %3.3f\n', conttab.stats{5});
fprintf(FID,'\\end{minipage}}');

fprintf(FID,'\\end{table}\n');
fclose(FID); 

fprintf('___________________________________________________________\n');
fprintf('Saved: %s.\n', printname)


run ../copy_selected_files
warning('Automatically copy file over to project paper directory.')