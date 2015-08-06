function make_table_compare_classalg(classalg_comparison)


nr_algs = length(classalg_comparison.accuracy);

nr_splits = 3;

splitline = nr_algs / nr_splits;

str_tabularsize = ['\\begin{tabular}{r', repmat('l', 1, splitline), '}\n'];
num_multiinsert = [repmat('& %3.2f ', 1, splitline), ' \\tabularnewline \n'];
int_multiinsert = [repmat('& %d ', 1, splitline), ' \\tabularnewline \n'];

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

for j=1:nr_splits
    split_start = 1 + (j-1)*splitline;
    split_end = j*splitline;
    
    fprintf(FID, ' ');
    for i= split_start : split_end
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
    
    if j == nr_splits
        fprintf(FID, '\\bottomrule \n');
    else
        fprintf(FID, '\\tabularnewline \n');
    end
end


fprintf(FID,'\\end{tabular} \n');
fprintf(FID, '\\begin{tablenotes}\n');
fprintf(FID, '\\small\n');
fprintf(FID,'\\item\\textit{Note:} Every column is a different classification algorithms.\n');
fprintf(FID,'\\item F-measure: balanced F-measure which is the evenly weightened harmonic mean between Precision and Recall. \n');
fprintf(FID,'\\item AUC: Area under (the receiver operating) curve.\n');
fprintf(FID,'\\item MCC: Matthew''s correlation coefficient.\n');
fprintf(FID,'\\item\\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID, '\\end{tablenotes}\n');
fprintf(FID, '\\end{threeparttable}\n');
fprintf(FID, '\\end{small}\n');
fprintf(FID, '\\end{table}\n');
fclose(FID); 

fprintf('Saved: %s.\n', printname)
