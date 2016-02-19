function tests = test_rank_tokens
    tests = functiontests(localfunctions);
end

function testNormalBigNotEmpty(testCase)
    
    N = 200;
    T = 1000;
    feat_incidMat = randi([0, 1], N, T);
    manAutomat = randi([0, 1], N, 1);
    featTok = repmat({'a'}, T, 1);
                 
    tokRanking = rank_tokens(feat_incidMat, ...
        manAutomat, featTok);

    % Check that this large sample returns some positive values
    actSolution = +isempty(tokRanking.meaningfulTok); 
    expSolution = 0; 

    verifyEqual(testCase, actSolution, expSolution)
end

function testKnownAnalyticSol(testCase)
    % Check that it returns the correct mutual information as calculated by
    % underlying function.

    feat_incidMat = [ones(10, 1); zeros(40, 1); ones(50, 1)];
    manAutomat = [zeros(40, 1); ones(60, 1)];
    featTok = 'testtoken';
                 
    tokRanking = rank_tokens(feat_incidMat, ...
        manAutomat, featTok);
    actSolution = tokRanking.mutInf_sorted;

    classifstat = calculate_manclass_stats(manAutomat, feat_incidMat);
    expSolution = classifstat.mutual_information;
    
    numdiff = abs( (actSolution - expSolution) / actSolution );
    verifyLessThan(testCase, numdiff, eps)
end

function testKnownRanking(testCase)
    % Check that ranking of tokens correct for two known tokens.

    feat_incidMat = [ones(10, 2); zeros(40, 2); ones(50, 2)];
    feat_incidMat(1, 2) = 0;
    
    manAutomat = [zeros(40, 1); ones(60, 1)];
    featTok = {'token1'; 'token2'};
                 
    tokRanking = rank_tokens(feat_incidMat, ...
        manAutomat, featTok);
   
    actSolution = +strcmp(tokRanking.meaningfulTok{1}, 'token2');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end



