function make_table_evalstats(classifstat)

% Print to .txt file in Latex format
printname = 'output/table_evalstats.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{tabular}{lrllll}\n');
fprintf(FID, '\\rule{0pt}{12pt} & Accuracy & \\multicolumn{3}{r}{$\\frac{%d + %d}{%d} = %3.2f$} &  \\tabularnewline\n', classifstat.true_negative, classifstat.true_positive, classifstat.nr_codpt, classifstat.accuracy);
fprintf(FID, '\\rule{0pt}{12pt}& Precision & \\multicolumn{3}{r}{$\\frac{%d}{%d} = %3.2f$} & \\tabularnewline\n', classifstat.true_positive, classifstat.false_positive + classifstat.true_positive, classifstat.precision);
fprintf(FID, '\\rule{0pt}{12pt}& Recall & \\multicolumn{3}{r}{$\\frac{%d}{%d} = %3.2f$} &  \\tabularnewline\n', classifstat.true_positive, classifstat.false_negative + classifstat.true_positive, classifstat.recall);
% Only print the beta once
fprintf(FID, '\\rule{0pt}{12pt}& $F_1^1$ & \\multicolumn{3}{r}{%3.2f} & \\tabularnewline\n', classifstat.fmeasure);
fprintf(FID, '\\rule{0pt}{12pt}& AUC$^2$ & \\multicolumn{3}{r}{%3.2f} & \\tabularnewline\n', classifstat.auc);
fprintf(FID, '\\rule{0pt}{12pt}& MCC$^3$ & \\multicolumn{3}{r}{%3.2f} & \\tabularnewline\n', classifstat.matthewscorrcoeff);
fprintf(FID,'\\end{tabular}\n');
fclose(FID); 
