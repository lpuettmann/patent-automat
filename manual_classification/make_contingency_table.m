function make_contingency_table(classifstat)

% Print to .txt file in Latex format
printname = 'output/table_contingency.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Contingency table}}\n');
fprintf(FID,'\\label{table:contingency_table}\n');
fprintf(FID,'\\begin{tabular}{lrllll}\n');
fprintf(FID, '\\toprule \n');
fprintf(FID, ' & & & &  & \\tabularnewline[-0.3cm]\n');
fprintf(FID, ' & & \\multicolumn{3}{c}{Computerized} & \\tabularnewline[0.1cm]\n');
fprintf(FID, ' & & \\multicolumn{1}{|l}{No}  & \\multicolumn{1}{l|}{Yes} & \\tabularnewline\n');
fprintf(FID, '\\cline{3-5} \n');
fprintf(FID, '\\parbox[t]{0mm}{\\multirow{2}{*}{\\rotatebox[origin=c]{90}{Manual}}} & No & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & \\tabularnewline\n', classifstat.true_negative, classifstat.false_positive, classifstat.true_negative + classifstat.false_positive);
fprintf(FID, ' & Yes & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & \\tabularnewline\n', classifstat.false_negative, classifstat.true_positive, classifstat.false_negative + classifstat.true_positive);
fprintf(FID, ' \\cline{3-5} \n');
fprintf(FID, ' &  & \\multicolumn{1}{|l}{%d} & \\multicolumn{1}{l|}{%d} & %d & \\tabularnewline\n', classifstat.true_negative + classifstat.false_negative, classifstat.false_positive + classifstat.true_positive, classifstat.nr_codpt);
fprintf(FID, '&  &  & & & \\tabularnewline[-0.1cm]\n');
fprintf(FID, '\\cline{2-6} \n');
fprintf(FID, '\\rule{0pt}{12pt} & Accuracy & \\multicolumn{3}{r}{$\\frac{%d + %d}{%d} = %3.2f$} &  \\tabularnewline\n', classifstat.true_negative, classifstat.true_positive, classifstat.nr_codpt, classifstat.accuracy);
fprintf(FID, '\\rule{0pt}{12pt}& Precision & \\multicolumn{3}{r}{$\\frac{%d}{%d} = %3.2f$} & \\tabularnewline\n', classifstat.true_positive, classifstat.false_positive + classifstat.true_positive, classifstat.precision);
fprintf(FID, '\\rule{0pt}{12pt}& Recall & \\multicolumn{3}{r}{$\\frac{%d}{%d} = %3.2f$} &  \\tabularnewline\n', classifstat.true_positive, classifstat.false_negative + classifstat.true_positive, classifstat.recall);
% Only print the beta once
fprintf(FID, '\\rule{0pt}{12pt}& $F_1^1$ & \\multicolumn{3}{r}{%3.2f} & \\tabularnewline\n', classifstat.fmeasure);
fprintf(FID, '\\rule{0pt}{12pt}& AUC$^2$ & \\multicolumn{3}{r}{%3.2f} & \\tabularnewline\n', classifstat.auc);
fprintf(FID, '\\rule{0pt}{12pt}& MCC$^3$ & \\multicolumn{3}{r}{%3.2f} & \\tabularnewline\n', classifstat.matthewscorrcoeff);

fprintf(FID, '\\bottomrule');
fprintf(FID, '\\multicolumn{6}{l}{\\textit{Note:} Classification based on Algorithm1.} \\tabularnewline\n');

fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\begin{tablenotes}\n');
fprintf(FID,'\\small\n');
fprintf(FID,'\\item $^1$: $F_1$ is the \\textit{balanced F-measure} which is the evenly weightened harmonic mean between Precision and Recall. \n');
fprintf(FID,'\\item $^2$: Area under (the receiver operating) curve.\n');
fprintf(FID,'\\item $^3$: Matthew''s correlation coefficient.\n');
fprintf(FID,'\\item\\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID,'\\end{tablenotes}\n');
% fprintf(FID, '\\multicolumn{6}{l}{\\textit{Source:} USPTO, Google and own calculations.} \\tabularnewline\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 

fprintf('Saved: %s.\n', printname)