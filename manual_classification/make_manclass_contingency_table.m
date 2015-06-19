close all
clear all
clc

% Save contingency table to .tex


%% Load stats on classifications
load('classifstat.mat')


%% Print to .txt file in Latex format
printname = 'table_contingency_classfc.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Contingency table}}\n');
fprintf(FID,'\\label{table:contingency_classifications}\n');
fprintf(FID,'\\begin{tabular}{ll|ll|l}\n');

fprintf(FID, '& \\multicolumn{4}{c}{Computerized} \\tabularnewline[0.1cm]\n');
fprintf(FID, '& & No & Yes &   \\tabularnewline\n');
fprintf(FID, '\\cline{2-5}\n');
fprintf(FID, '\\parbox[t]{2mm}{\\multirow{2}{*}{\\rotatebox[origin=c]{90}{Manual}}} & No & %d & %d & %d \\tabularnewline\n', classifstat.nr_codpt - classifstat.sum_automat - length(classifstat.automatic1_manual0), length(classifstat.automatic1_manual0), classifstat.nr_codpt - classifstat.sum_automat);
fprintf(FID, '& Yes & %d & %d & %d \\tabularnewline\n', length(classifstat.manual1_automatic0), classifstat.sum_automat - length(classifstat.manual1_automatic0), classifstat.sum_automat);
fprintf(FID, '\\cline{2-5}\n');
fprintf(FID, '&  & %d & %d & %d \\tabularnewline\n', classifstat.nr_codpt - sum(classifstat.pat_1match), sum(classifstat.pat_1match), classifstat.nr_codpt);

fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');

fprintf(FID,'\\floatfoot{');
fprintf(FID,'\\begin{minipage}{0.3\\textwidth}');
fprintf(FID,' \\textit{Statistics:}\\\\\n');
fprintf(FID,'Accuracy = $\\frac{%d + %d}{%d}$ = %3.2f\\\\\n', ...
    length(classifstat.overlap_class), classifstat.nr_codpt - classifstat.sum_automat - ...
    length(classifstat.automatic1_manual0), classifstat.nr_codpt, ...
    classifstat.accuracy);
fprintf(FID,'Precision = $\\frac{%d}{%d}$ = %3.2f\\\\\n', ...
    length(classifstat.overlap_class), sum(classifstat.pat_1match), classifstat.precision);
fprintf(FID,'Recall = $\\frac{%d}{%d}$ = %3.2f\\\\\n', ...
    length(classifstat.overlap_class),  classifstat.sum_automat, classifstat.recall);
fprintf(FID,'$F_{\\beta = %d}$ = %3.2f\\\\\n', sqrt(classifstat.evalbeta_squared), classifstat.fmeasure);
fprintf(FID,'AUC = %3.3f\n', classifstat.auc);
fprintf(FID,'\\end{minipage}}');

fprintf(FID,'\\end{table}\n');
fclose(FID); 

fprintf('___________________________________________________________\n');
fprintf('Saved: %s.\n', printname)
