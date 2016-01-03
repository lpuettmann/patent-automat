function tests = test_get_occurstats
    tests = functiontests(localfunctions);
end

function testWorksWithSmallMat(testCase)

    incidMat = [1, 0;
                0, 1];
    uniqueT = {'term1'; 'term2'};
    manAutomat = [0; 1];
    occurstats = get_occurstats(incidMat, uniqueT, manAutomat);

    actSolution = length(occurstats.aPat_sortedOccur);
    expSolution = 2;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalMagic1(testCase)

    incidMat = magic(5);
    uniqueT = {'term1'; 'term2'; 'term3'; 'term4'; 'term5'};
    manAutomat = [0; 1; 1; 0; 0];
    occurstats = get_occurstats(incidMat, uniqueT, manAutomat);

    actSolution = occurstats.all_sortedOccur(1);
    expSolution = 5;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalMagic2(testCase)

    incidMat = magic(5);
    uniqueT = {'term1'; 'term2'; 'term3'; 'term4'; 'term5'};
    manAutomat = [0; 1; 1; 0; 0];
    occurstats = get_occurstats(incidMat, uniqueT, manAutomat);

    actSolution = occurstats.aPat_sortedOccur(3);
    expSolution = 2;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testRandom(testCase)

    incidMat = randi([-10, 10], 3, 3);
    incidMat(2,2) = 1;
    
    uniqueT = {'term1'; 'term2'; 'term3'};
    manAutomat = [0; 0; 1];
    occurstats = get_occurstats(incidMat, uniqueT, manAutomat);

    j = find( strcmp( occurstats.nPat_sortedT, 'term2') );
    
    actSolution = +(occurstats.nPat_sortedOccur(j) >= 1);
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end



