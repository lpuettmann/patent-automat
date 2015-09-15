function make_table_compare_classalg(classalg_comparison, max_line)


nr_algs = length(classalg_comparison.accuracy);

nr_splits = floor( nr_algs / max_line );
nr_rem = mod(nr_algs, max_line);

str_tabularsize = ['\\begin{tabular}{r', repmat('l', 1, max_line), '}\n'];
num_multiinsert = [repmat('& %3.2f ', 1, max_line), ' \\tabularnewline \n'];
int_multiinsert = [repmat('& %d ', 1, max_line), ' \\tabularnewline \n'];
num_restinsert = [repmat('& %3.2f ', 1, nr_rem), repmat('& ', 1, max_line - nr_rem), ' \\tabularnewline \n'];
int_restinsert = [repmat('& %d ', 1, nr_rem), repmat('& ', 1, max_line - nr_rem), ' \\tabularnewline \n'];

% Print to .txt file in Latex format
printname = 'output/table_compare_classalg.tex';

FID = fopen(printname, 'w');

fprintf(FID, '\\begin{table}\n');
fprintf(FID, '\\begin{small}\n');
fprintf(FID, '\\begin{threeparttable}\n');
fprintf(FID, '\\caption{{\\normalsize Evaluation of different classification algorithms}}\n');
fprintf(FID, '\\label{table:table_compare_classalg}\n');
fprintf(FID, str_tabularsize);
fprintf(FID, '\\toprule \n');

for j=1:(nr_splits)
    split_start = 1 + (j-1)*max_line;
    split_end = j*max_line;
    
    fprintf(FID, ' ');
    for i = split_start : split_end
        fprintf(FID, '& \\textbf{%s} ', ...
            classalg_comparison.algorithm_name{i});
    end
    fprintf(FID, ' \\tabularnewline \n');

    fprintf(FID, ['Accuracy ', num_multiinsert], ...
        classalg_comparison.accuracy(split_start:split_end));
    fprintf(FID, ['Precision ', num_multiinsert], ...
        classalg_comparison.precision(split_start:split_end));
    fprintf(FID, ['Recall ', num_multiinsert], ...
        classalg_comparison.recall(split_start:split_end));
    fprintf(FID, ['F-measure ', num_multiinsert], ...
        classalg_comparison.fmeasure(split_start:split_end));
    fprintf(FID, ['AUC ', num_multiinsert], ...
        classalg_comparison.auc(split_start:split_end));
    fprintf(FID, ['MCC ', num_multiinsert], ...
        classalg_comparison.matthewscorrcoeff(split_start:split_end));
    fprintf(FID, ['Number "Yes" ', int_multiinsert], ...
        classalg_comparison.nr_Yes(split_start:split_end));
    
    if j == (nr_splits + (nr_rem>0))
        fprintf(FID, '\\bottomrule \n');
    else
        fprintf(FID, '\\tabularnewline \n');
    end
end

if nr_rem > 0
    split_start = 1 + nr_splits*max_line;
    split_end = nr_algs;
    
    fprintf(FID, ' ');
    for i = split_start : split_end
        fprintf(FID, '& \\textbf{%s} ', ...
            classalg_comparison.algorithm_name{i});
    end
    fprintf(FID, ' \\tabularnewline \n');

    fprintf(FID, ['Accuracy ', num_restinsert], ...
        classalg_comparison.accuracy(split_start:split_end));
    fprintf(FID, ['Precision ', num_restinsert], ...
        classalg_comparison.precision(split_start:split_end));
    fprintf(FID, ['Recall ', num_restinsert], ...
        classalg_comparison.recall(split_start:split_end));
    fprintf(FID, ['$F_1$-measure ', num_restinsert], ...
        classalg_comparison.fmeasure(split_start:split_end));
    fprintf(FID, ['AUC ', num_restinsert], ...
        classalg_comparison.auc(split_start:split_end));
    fprintf(FID, ['MCC ', num_restinsert], ...
        classalg_comparison.matthewscorrcoeff(split_start:split_end));
    fprintf(FID, ['Number "Yes" ', int_restinsert], ...
        classalg_comparison.nr_Yes(split_start:split_end));
    
    fprintf(FID, '\\bottomrule \n');
end

fprintf(FID,'\\end{tabular} \n');
fprintf(FID, '\\begin{tablenotes}\n');
fprintf(FID, '\\small\n');
fprintf(FID,'\\item\\textit{Note:} "automat" classifies all patents as automation patent that include "automat" at least once.');
fprintf(FID,'\\item Bessen-Hunt: (anywhere in patent:) ``software" OR (``computer" AND ``program") ANDNOT ((in title:) ``chip" OR ``semiconductor" OR ``bus" OR ``circuit" OR ``circuitry") ANDNOT ((anwhere in patent:) ``antigen" OR ``antigenic" OR ``chromatography").\n');
fprintf(FID,'\\item $F_1$-measure: balanced F-measure which is the evenly weightened harmonic mean between Precision and Recall. \n');
fprintf(FID,'\\item AUC: Area under (the receiver operating) curve.\n');
fprintf(FID,'\\item MCC: Matthew''s correlation coefficient.\n');
fprintf(FID,'\\item\\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID, '\\end{tablenotes}\n');
fprintf(FID, '\\end{threeparttable}\n');
fprintf(FID, '\\end{small}\n');
fprintf(FID, '\\end{table}\n');
fclose(FID); 
