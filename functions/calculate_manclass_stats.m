function classifstat = calculate_manclass_stats(correctClass, ...
    estimatClass, alpha)
% Analyze the quality of a binary classification algorithm. These can be 
% reported in a contingency table (also called confusion matrix).
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
%   fmeasure ...), see:
%   Manning, Raghavan, Schütze "Introduction to Information Retrieval",
%   first edition (2008), section "8. Evaluation in information retrieval"


if (min(size(correctClass)) > 1) | (min(size(estimatClass)) > 1)
    error('Should be vector.')
end

if (isnan(correctClass)) | (isnan(estimatClass))
    error('Missing values.')
end

if any( not((correctClass == 0) | (correctClass == 1)) | ...
        not((estimatClass == 0) | (estimatClass == 1)) )
    error('There should be only 0 and 1 in vectors.')
end

% Number of classified cases
classifstat.nr_codpt = length(correctClass);

tp = sum( (correctClass==1) & (estimatClass == 1) );
fp = sum( (correctClass==0) & (estimatClass == 1) );
tn = sum( (correctClass==0) & (estimatClass == 0) );
fn =  sum( (correctClass==1) & (estimatClass == 0) );

% Overall agreement rate
classifstat.accuracy = (tp + tn) / classifstat.nr_codpt;

classifstat.precision = tp / (tp + fp);
classifstat.recall = tp / (tp + fn);

classifstat.evalalpha = alpha; % weighting measure
classifstat.evalbeta_squared = (1 - classifstat.evalalpha) / ...
    classifstat.evalalpha; % beta squared

classifstat.fmeasure = ((classifstat.evalbeta_squared + 1) * ...
    classifstat.precision * classifstat.recall) / ...
    (classifstat.evalbeta_squared * classifstat.precision + ...
    classifstat.recall);

% Calculate area under (receiver operating) curve (AUROC)
classifstat.auc = calculate_auc(correctClass, estimatClass);

% Calculate Matthews correlation coefficient
classifstat.matthewscorrcoeff = (tp * tn - fp * fn) / sqrt((tp + fp)*...
    (tp + fn)*(tn + fp)*(tn + fn));

% Save in struct
classifstat.true_positive = tp;
classifstat.false_positive = fp;
classifstat.true_negative = tn;
classifstat.false_negative = fn;
