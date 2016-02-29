function classifstat = calculate_manclass_stats(correctClass, ...
    estimatClass, evalalpha)
% Analyze the quality of a binary classification algorithm. These can be 
% reported in a contingency table (also called confusion matrix).
%
% IN:
%       correctClass: vector of 0 and 1 indicating the correct
%                    classification
%       estimatClass: vector of 0 and 1 indicating the estimated
%                    classification (same size as correctClass)
%
%
% OPTIONAL IN:
%       evalalpha: number in [0, 1] indicating the weights for the 
%                  F-measure. The default is set to 0.5 which gives equal 
%                  weight to precision and recall.
%
%
% Out:
%       classifstat: structure holding the statistics
%
%   For  definitions of evaluation measures (accuracy, precision, recall,
%   fmeasure ...), see:
%   Manning, Raghavan, Schuetze "Introduction to Information Retrieval",
%   first edition (2008), section "8. Evaluation in information retrieval"

if nargin < 3
    evalalpha = 0.5;
end

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
N = length(correctClass);

tp = sum( (correctClass==1) & (estimatClass == 1) );
fp = sum( (correctClass==0) & (estimatClass == 1) );
tn = sum( (correctClass==0) & (estimatClass == 0) );
fn = sum( (correctClass==1) & (estimatClass == 0) );

% Overall agreement rate
classifstat.accuracy = (tp + tn) / N;

classifstat.precision = tp / (tp + fp);
classifstat.recall = tp / (tp + fn);

classifstat.evalalpha = evalalpha; % weighting measure
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

% Calculate Cohen's kappa
p_man_yes = sum(correctClass) / N;
p_comp_yes = sum(estimatClass) / N;
p_rand_agree = p_man_yes * p_comp_yes + (1 - p_man_yes) * ...
    (1 - p_comp_yes); % probability of random agreement
classifstat.cohenskappa = 1 - ((1 - classifstat.accuracy) / ...
    (1 - p_rand_agree));

% Calculate mutual information
N11 = tp;
N10 = fp;
N01 = fn;
N00 = tn;

N1dot = tp + fp;
Ndot1 = tp + fn;
N0dot = fn + tn;
Ndot0 = fp + tn;

classifstat.mutual_information = ...
   (N11 * log2( (N*N11) / (N1dot*Ndot1) ) + ...
    N01 * log2( (N*N01) / (N0dot*Ndot1) ) + ...
    N10 * log2( (N*N10) / (N1dot*Ndot0) ) + ...
    N00 * log2( (N*N00) / (N0dot*Ndot0) ) ) / N;

% Calculate conditional probabilities of being in either class (automation
% or non-automation patent) for all tokens that we searched for.
% This is the Bernoulli Naive Bayes model.
% Use Laplace (+1) smoothing. The 2 in the denominator comes from there
% being two cases to differentiate.
classifstat.cond_prob_yes = (tp + 1) / (fn + tp + 2);
classifstat.cond_prob_no = (fp + 1) / (tn + fp + 2);


% Save in struct
classifstat.nr_codpt = N;
classifstat.true_positive = tp;
classifstat.false_positive = fp;
classifstat.true_negative = tn;
classifstat.false_negative = fn;
