function make_contingency_table(classifstat)

% Print to .txt file in Latex format
printname = 'output/table_contingency.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{tabular}{lrllll}\n');
fprintf(FID, ' & & & &  & \\tabularnewline[-0.3cm]\n');
fprintf(FID, ' & & \\multicolumn{3}{c}{Computerized} & \\tabularnewline[0.1cm]\n');
fprintf(FID, ' & & \\multicolumn{1}{|l}{No}  & \\multicolumn{1}{l|}{Yes} & \\tabularnewline\n');
fprintf(FID, '\\cline{3-5} \n');
fprintf(FID, '\\parbox[t]{0mm}{\\multirow{2}{*}{\\rotatebox[origin=c]{90}{Manual}}} & No & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & \\tabularnewline\n', classifstat.true_negative, classifstat.false_positive, classifstat.true_negative + classifstat.false_positive);
fprintf(FID, ' & Yes & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & \\tabularnewline\n', classifstat.false_negative, classifstat.true_positive, classifstat.false_negative + classifstat.true_positive);
fprintf(FID, ' \\cline{3-5} \n');
fprintf(FID, ' &  & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & \\tabularnewline\n', classifstat.true_negative + classifstat.false_negative, classifstat.false_positive + classifstat.true_positive, classifstat.nr_codpt);
fprintf(FID, '  &  &  &  &  & \\tabularnewline\n');
fprintf(FID, ' & \\multicolumn{5}{l}{``No": not automation patent}  \\tabularnewline\n');
fprintf(FID,'\\end{tabular}\n');
fclose(FID); 
