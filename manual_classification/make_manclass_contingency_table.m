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
fprintf(FID,'\\caption{{\\normalsize Comparison of classification algorithms}}\n');
fprintf(FID,'\\label{table:contingency_classifications}\n');
fprintf(FID,'\\begin{tabular}{lrllllllllllll}\n');
fprintf(FID, '\\toprule');
fprintf(FID, '&  &  & &  & &  &  & & & & & \\tabularnewline[-0.3cm]\n');
fprintf(FID, '& & \\multicolumn{11}{c}{Computerized} \\tabularnewline[0.1cm]\n');
fprintf(FID, '\\cline{3-13}\n');
fprintf(FID, '& & \\multicolumn{3}{c}{$A_1$} & & \\multicolumn{3}{c}{$A_2$} & & \\multicolumn{3}{c}{$A_3$} \\tabularnewline[0.1cm]\n');
fprintf(FID, '& & \\multicolumn{1}{|l}{No}  & \\multicolumn{1}{l|}{Yes} & & & \\multicolumn{1}{|l}{No} & \\multicolumn{1}{l|}{Yes} &  & & \\multicolumn{1}{|l}{No} & \\multicolumn{1}{l|}{Yes} & \\tabularnewline\n');
fprintf(FID, '\\cline{3-5} \\cline{7-9} \\cline{11-13}\n');
fprintf(FID, '\\parbox[t]{0mm}{\\multirow{2}{*}{\\rotatebox[origin=c]{90}{Manual}}} & No & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d \\tabularnewline\n', conttab.val(1,:,1), conttab.val(1,:,2),  conttab.val(1,:,3));
fprintf(FID, '& Yes & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d \\tabularnewline\n', conttab.val(2,:,1), conttab.val(2,:,2), conttab.val(2,:,3));
fprintf(FID, '\\cline{3-5} \\cline{7-9} \\cline{11-13}\n');
fprintf(FID, '&  & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d \\tabularnewline\n', conttab.val(3,:,1), conttab.val(3,:,2), conttab.val(3,:,3));
fprintf(FID, '&  &  & &  & &  &  & & & & & \\tabularnewline[-0.1cm]\n');
fprintf(FID, '\\cline{3-5} \\cline{7-9} \\cline{11-13}\n');
fprintf(FID, '\\rule{0pt}{12pt}& Accuracy & \\multicolumn{3}{r}{$\\frac{%d + %d}{%d} = %3.2f$} & & \\multicolumn{3}{r}{$\\frac{%d + %d}{%d} = %3.2f$} & & \\multicolumn{3}{r}{$\\frac{%d + %d}{%d} = %3.2f$}\\tabularnewline\n', conttab.stats{1,:,1}, conttab.stats{1,:,2}, conttab.stats{1,:,3});
fprintf(FID, '\\rule{0pt}{12pt}& Precision & \\multicolumn{3}{r}{$\\frac{%d}{%d} = %3.2f$} & & \\multicolumn{3}{r}{$\\frac{%d}{%d} = %3.2f$} & & \\multicolumn{3}{r}{$\\frac{%d}{%d} = %3.2f$} \\tabularnewline\n', conttab.stats{2,:,1}, conttab.stats{2,:,2}, conttab.stats{2,:,3});
fprintf(FID, '\\rule{0pt}{12pt}& Recall & \\multicolumn{3}{r}{$\\frac{%d}{%d} = %3.2f$} & & \\multicolumn{3}{r}{$\\frac{%d}{%d} = %3.2f$}  & & \\multicolumn{3}{r}{$\\frac{%d}{%d} = %3.2f$} \\tabularnewline\n', conttab.stats{3,:,1}, conttab.stats{3,:,2}, conttab.stats{3,:,3});
% Only print the beta once
fprintf(FID, '\\rule{0pt}{12pt}& $F_{\\beta = %d}$ & \\multicolumn{3}{r}{%3.2f} & & \\multicolumn{3}{r}{%3.2f} & & \\multicolumn{3}{r}{%3.2f}\\tabularnewline\n', conttab.stats{4,:,1}(1), conttab.stats{4,:,1}(2), conttab.stats{4,:,2}(2), conttab.stats{4,:,3}(2));
fprintf(FID, '\\rule{0pt}{12pt}& AUC & \\multicolumn{3}{r}{%3.2f} & & \\multicolumn{3}{r}{%3.2f} & & \\multicolumn{3}{r}{%3.2f}\\tabularnewline\n', conttab.stats{5,:,1}, conttab.stats{5,:,2}, conttab.stats{5,:,3});
fprintf(FID, '\\cline{2-13}\\tabularnewline[-0.2cm]\n');
fprintf(FID, '& Criterion & \\multicolumn{3}{r}{a $>0$} & & \\multicolumn{3}{r}{a $>0$} & & \\multicolumn{3}{r}{a $>1$} \\tabularnewline[0.1cm]\n');
fprintf(FID, '& Exlcude & \\multicolumn{3}{r}{--} & & \\multicolumn{3}{r}{Chemicals, drugs} & & \\multicolumn{3}{r}{--} \\tabularnewline[0.1cm]\n');

fprintf(FID, '\\bottomrule');
fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\begin{tablenotes}\n');
fprintf(FID,'\\small\n');
fprintf(FID,'\\item\\textit{Note:} a: number of keyword \\textit{automat} matches in patent.\n');
fprintf(FID,'\\item\\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID,'\\end{tablenotes}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 

fprintf('Saved: %s.\n', printname)


run ../copy_selected_files
