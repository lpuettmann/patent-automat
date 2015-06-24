function tests = test_calculate_manclass_stats
    tests = functiontests(localfunctions);
end

function testnr_codpt(testCase)
    correctClass = [0; 0; 1; 0; 1; 0; 0; 0; 1; 0; 1; 1; 0; 0];
    estimatClass = [0; 0; 1; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 0];
       
    alpha = 0.5;

    classifstat = calculate_manclass_stats(correctClass, estimatClass, ...
        alpha);
    actSolution = classifstat.nr_codpt;

    expSolution = 14;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testsum_automat(testCase)
    correctClass = [0; 0; 1; 0; 1; 0; 0; 0; 1; 0; 1; 1; 0; 0];
    estimatClass = [0; 0; 1; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 0];
       
    alpha = 0.5;

    classifstat = calculate_manclass_stats(correctClass, estimatClass, ...
        alpha);
    actSolution = classifstat.sum_automat;

    expSolution = sum(correctClass);
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testaccuracy(testCase)
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
