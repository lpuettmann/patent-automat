function classifstat = calculate_manclass_stats(correctClass, ...
    estimatClass, alpha)
% Analyze the quality of a classification algorithm.
%
% IN:
%       correctClass: vector of 0 and 1 indicating the correct
%                    classification
%       estimatClass: vector of 0 and 1 indicating the estimated
%                    classification (same size as correctClass)
%       alpha: number in [0, 1] indicating the weights for the F-measure
%
% Out:
%       classifstat: structure holdind the statistics
%
%   For  definitions of evaluation measures (accuracy, precision, recall,
%   fmeasure...), see:
%   Manning, Raghavan, Schütze "Introduction to Information Retrieval",
%   first edition (2008), section "8. Evaluation in information retrieval"


if (min(size(correctClass)) > 1) | (min(size(estimatClass)) > 1)
    error('Should be vector.')
end
    

classifstat.computerClass = estimatClass;
classifstat.nr_codpt = length(correctClass);
classifstat.sum_automat = sum(correctClass);
share_automat = classifstat.sum_automat / classifstat.nr_codpt;


pos_manclass_automat = find(correctClass);
pos_pat_1match = find(estimatClass);


% Calculate area under (receiver operating) curve (AUROC)
classifstat.auc = calculate_auc(correctClass, estimatClass);

% Calculate the overall agreement rate
classifstat.accuracy = sum(correctClass == estimatClass) / classifstat.nr_codpt;
complete_class = union(pos_pat_1match, pos_manclass_automat);
classifstat.overlap_class = intersect(pos_pat_1match, pos_manclass_automat);
differ_class = setdiff(complete_class, classifstat.overlap_class);

classifstat.precision = length(classifstat.overlap_class) / sum(estimatClass);
classifstat.recall = length(classifstat.overlap_class) / classifstat.sum_automat;

classifstat.evalalpha = alpha; % weighting measure
classifstat.evalbeta_squared = (1 - classifstat.evalalpha) / classifstat.evalalpha; % beta squared

classifstat.fmeasure = ((classifstat.evalbeta_squared + 1) * classifstat.precision * ...
    classifstat.recall) / (classifstat.evalbeta_squared * classifstat.precision + ...
    classifstat.recall);


classifstat.manual1_automatic0 = setdiff(pos_manclass_automat, pos_pat_1match);
classifstat.automatic1_manual0 = setdiff(pos_pat_1match, pos_manclass_automat);

