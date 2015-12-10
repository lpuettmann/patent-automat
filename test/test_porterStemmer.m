function tests = test_porterStemmer
    tests = functiontests(localfunctions);
end

function testNormalCase1(testCase)

    inString = 'caresses'; 
    word_stem = porterStemmer(inString);
    
    actSolution = +strcmp(word_stem, 'caress');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalCase2(testCase)

    inString = 'ponies'; 
    word_stem = porterStemmer(inString);
    
    actSolution = +strcmp(word_stem, 'poni');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalCase3(testCase)

    inString = 'caress'; 
    word_stem = porterStemmer(inString);
    
    actSolution = +strcmp(word_stem, 'caress');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalCase4(testCase)

    inString = 'cats'; 
    word_stem = porterStemmer(inString);
    
    actSolution = +strcmp(word_stem, 'cat');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalCase5(testCase)

    inString = 'university'; 
    word_stem = porterStemmer(inString);
    
    actSolution = +strcmp(word_stem, 'univers');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalCase6(testCase)

    inString = 'alumnus'; 
    word_stem = porterStemmer(inString);
    
    actSolution = +strcmp(word_stem, 'alumnu');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end
