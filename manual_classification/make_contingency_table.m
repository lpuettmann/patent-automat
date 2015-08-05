function make_contingency_table(classifstat)

% Print to .txt file in Latex format
printname = 'output/table_contingency.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Contingency table}}\n');
fprintf(FID,'\\label{table:contingency_table}\n');
fprintf(FID,'\\begin{tabular}{lrlll}\n');
fprintf(FID, '\\toprule');
fprintf(FID, ' & & & &  \\tabularnewline[-0.3cm]\n');
fprintf(FID, ' & & \\multicolumn{3}{c}{Computerized} \\tabularnewline[0.1cm]\n');
fprintf(FID, ' & & \\multicolumn{1}{|l}{No}  & \\multicolumn{1}{l|}{Yes} \\tabularnewline\n');
fprintf(FID, '\\cline{3-5} \n');
fprintf(FID, '\\parbox[t]{0mm}{\\multirow{2}{*}{\\rotatebox[origin=c]{90}{Manual}}} & No & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d \\tabularnewline\n', classifstat.true_negative, classifstat.false_positive, classifstat.true_negative + classifstat.false_positive);
fprintf(FID, ' & Yes & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d \\tabularnewline\n', classifstat.false_negative, classifstat.true_positive, classifstat.false_negative + classifstat.true_positive);
fprintf(FID, ' \\cline{3-5} \n');
fprintf(FID, ' &  & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d \\tabularnewline\n', classifstat.true_negative + classifstat.false_negative, classifstat.false_positive + classifstat.true_positive, classifstat.nr_codpt);

fprintf(FID, '\\bottomrule');
fprintf(FID,'\\end{tabular}\n');
% fprintf(FID,'\\begin{tablenotes}\n');
% fprintf(FID,'\\small\n');
%fprintf(FID,'\\item\\textit{Note:} \n');
% fprintf(FID,'\\end{tablenotes}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 

fprintf('Saved: %s.\n', printname)
