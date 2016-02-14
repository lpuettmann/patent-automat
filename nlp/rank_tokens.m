function tokRanking = rank_tokens(feat_incidMat, ...
    manAutomat, featTok)
% Rank the tokens in the document according to different criteria. This is
% usual for feature selection, so which of these to treat as variables in
% the following classification.
%
%   IN:
%       - feat_incidMat: N times T matrix with N patents and T tokens.
%       Entry (1, 2) shows how many times the second tokens shows up in the
%       first patent.
%      - manAutomat: vector N times 1 which holds the manually assigned
%      classes of patents. 1 indicates an automation patent, 0 a patent
%      that is not an automation patent.
%      - featTok: T times 1 cell array of strings containing the tokesn.
%
%   NOTE: all tokens have already been extracted, tokenized and counted.
%   Only unique tokens go in here, so no two tokens are the same.
%
%   OUT:
%       - meaningfulTok: M times 1 cell array of strings containing the
%       ranked tokens in descending order. These tokens are a subset of the
%       original tokens to M is smaller or equal N.
%       - mutInf_sorted: M times 1 vector containing the value of the
%       mutual information criterion for the tokens in meaningfulTok.
% 
%   NOTE: Returns only those tokens with its value that have a not NaN
%   value. So it is possible for meaningfulTok and mutInf_sorted to be
%   empty.

% Get an occurence matrix with 1 and 0 indicating entries greater than
% zero.
% So transforms      ________    to  ________     
%                   | 0   3  |      | 0   1  |
%                   | 15  0  |      | 1   0  |
%                    --------        --------
feat_occurMat = +( feat_incidMat > 0 );

mutInf = zeros(size(feat_occurMat, 2), 1);

tic
for t=1:size(feat_occurMat, 2)
    singleTok_class = feat_occurMat(:, t);
    classifstat = calculate_manclass_stats(manAutomat, singleTok_class);
    mutInf(t) = classifstat.mutual_information;
    
    if mod(t, 5000) == 0
        fprintf('%d/%d: calculated mutual information. (%d seconds)\n', t, ...
            size(feat_occurMat, 2), round(toc))
    end
end

% Replace NaNs with minus infinity for later ranking.
indic_isnan = isnan(mutInf);
mutInf_notNaN = mutInf( not( indic_isnan ) );
featTok_notNaN = featTok( not( indic_isnan ) );

% Sort the tokens according to the mutual information criterion
[tokRanking.mutInf_sorted, ix_sort] = sort(mutInf_notNaN, 'descend');
tokRanking.meaningfulTok = featTok_notNaN( ix_sort );

% Save struct as a table
tokRanking = struct2table(tokRanking);
