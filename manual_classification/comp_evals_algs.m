function classalg_comparison = comp_evals_algs(choose_compalg_list, ...
    computerClass, manclassData)

for i=1:length(choose_compalg_list)
    ix_alg = find( strcmp(computerClass.algorithm_name, ...
        choose_compalg_list{i}) );
    
    classifstat = calculate_manclass_stats(manclassData.manAutomat, ...
        computerClass.compAutomat(:, ix_alg));
    
    classalg_comparison.accuracy(i) = classifstat.accuracy;
    classalg_comparison.precision(i) = classifstat.precision;
    classalg_comparison.recall(i) = classifstat.recall;
    classalg_comparison.fmeasure(i) = classifstat.fmeasure;
    classalg_comparison.auc(i) = classifstat.auc;
    classalg_comparison.matthewscorrcoeff(i) = ...
        classifstat.matthewscorrcoeff;
    classalg_comparison.nr_Yes(i) = classifstat.false_positive + ...
        classifstat.true_positive;
end

classalg_comparison.algorithm_name = choose_compalg_list;
