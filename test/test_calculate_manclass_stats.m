function tests = test_calculate_manclass_stats
    tests = functiontests(localfunctions);
end

function testNrCodpt(testCase)
    correctClass = [0; 0; 1; 0; 1; 0; 0; 0; 1; 0; 1; 1; 0; 0];
    estimatClass = [0; 0; 1; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 0];      
    alpha = 0.5;
    classifstat = calculate_manclass_stats(correctClass, estimatClass, ...
        alpha);
    actSolution = classifstat.nr_codpt;
    expSolution = 14; 
    verifyEqual(testCase, actSolution, expSolution)
end

function testAccuracy(testCase)
    correctClass = [0; 0; 1; 0; 1; 0; 0; 0; 1; 0; 1; 1; 0; 0];
    estimatClass = [0; 0; 1; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 0];
      
    alpha = 0.5;
    classifstat = calculate_manclass_stats(correctClass, estimatClass, ...
        alpha);
    actSolution = classifstat.accuracy;
    expSolution = sum((correctClass == estimatClass)) / ...
        length(correctClass);   
    verifyEqual(testCase, actSolution, expSolution)
end

function testMatthewsCorrCoeff(testCase)
    correctClass = [0; 0; 1; 0; 1; 0; 0; 0; 1; 0; 1; 1; 0; 0];
    estimatClass = [0; 0; 1; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 0];
      
    alpha = 0.5;
    classifstat = calculate_manclass_stats(correctClass, estimatClass, ...
        alpha);
    actSolution = classifstat.matthewscorrcoeff;
    expSolution = 0.5185449728;
    diffSolutions = (actSolution - expSolution) / actSolution;
    verifyLessThan(testCase, diffSolutions, 10^-3)
end

function testCowensKappa(testCase)
    correctClass = [1; 1; 1; 1; 1; 0; 0; 0; 0; 0];
    estimatClass = [1; 1; 1; 1; 0; 1; 1; 0; 0; 0];

    classifstat = calculate_manclass_stats(correctClass, estimatClass);
    actSolution = classifstat.cohenskappa;
    expSolution = 0.4;
    diffSolutions = (actSolution - expSolution) / actSolution;
    verifyLessThan(testCase, diffSolutions, 10^-3)
end

function testMutualInformation(testCase)
    % Check the example from Manning, Raghavan and Schuetze (2008),
    % p. 252-253.
    N = 801948;
    tp = 49;
    fp = 27652;
    fn = 141;
    tn = 774106;
    
    % Make two vectors that reproduce exactly those true and false
    % positives and negatives
    correctClass = zeros(N, 1);
    correctClass(1:tp) = 1; % tp
    correctClass(tp + fp + 1 : tp + fp + fn) = 1; % fn
   
    estimatClass = zeros(N, 1);
    estimatClass(1 : tp + fp) = 1; % tp + fp;
    
    % Carry out the test
    classifstat = calculate_manclass_stats(correctClass, estimatClass);
    actSolution = classifstat.mutual_information;
    expSolution = 0.0001105;
    diffSolutions = (actSolution - expSolution) / actSolution;
    verifyLessThan(testCase, diffSolutions, 10^-3)
end

function testBernoulliNaiveBayesCondProb_Yes1(testCase)
    % See Manning, Raghavan and Schuetze (2008), p.261 and p.264
    correctClass = [1; 1; 1; 0];
    estimatClass = [1; 1; 1; 1]; % occurence: "Chinese"
    classifstat = calculate_manclass_stats(correctClass, estimatClass);
    actSolution = classifstat.cond_prob_yes;
    expSolution = 4/5;
    verifyEqual(testCase, actSolution, expSolution)
end

function testBernoulliNaiveBayesCondProb_Yes2(testCase)
    % See Manning, Raghavan and Schuetze (2008), p.261 and p.264
    correctClass = [1; 1; 1; 0];
    estimatClass = [0; 0; 0; 1]; % occurence: "Tokyo"
    classifstat = calculate_manclass_stats(correctClass, estimatClass);
    actSolution = classifstat.cond_prob_yes;
    expSolution = 1/5;
    verifyEqual(testCase, actSolution, expSolution)
end

function testBernoulliNaiveBayesCondProb_No1(testCase)
    % See Manning, Raghavan and Schuetze (2008), p.261 and p.264
    correctClass = [1; 1; 1; 0];
    estimatClass = [1; 1; 1; 1]; % occurence: "Chinese"
    classifstat = calculate_manclass_stats(correctClass, estimatClass);
    actSolution = classifstat.cond_prob_no; % not class China
    expSolution = 2/3;
    verifyEqual(testCase, actSolution, expSolution)
end

function testBernoulliNaiveBayesCondProb_No2(testCase)
    % See Manning, Raghavan and Schuetze (2008), p.261 and p.264
    correctClass = [1; 1; 1; 0];
    estimatClass = [0; 0; 0; 1]; % occurence: "Tokyo"
    classifstat = calculate_manclass_stats(correctClass, estimatClass);
    actSolution = classifstat.cond_prob_no; % not class China
    expSolution = 2/3;
    verifyEqual(testCase, actSolution, expSolution)
end


