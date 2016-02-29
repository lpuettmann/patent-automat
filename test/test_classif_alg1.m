function tests = test_classif_alg1
    tests = functiontests(localfunctions);
end

function testNormalZero(testCase)

    searchdict = {'automat', 'robot', 'movabl', 'autonom', ...
        'adapt', 'self-generat', 'detect', 'program', 'comput'};
    title_matches = zeros(20, 9);
    abstract_matches = zeros(20, 9);
    body_matches = zeros(20, 9);
    
    class_pat = classif_alg1(searchdict, title_matches, ...
        abstract_matches, body_matches);

    actSolution = +any( class_pat ); 
    expSolution = 0; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalNoneClass(testCase)

    searchdict = {'automat', 'robot', 'movabl', 'autonom', ...
        'adapt', 'self-generat', 'detect', 'program', 'comput'};
    title_matches = zeros(20, 9);
    abstract_matches = zeros(20, 9);
    body_matches = zeros(20, 9);
    body_matches(2, 8) = 1;
    body_matches(7, 9) = 1;
    
    class_pat = classif_alg1(searchdict, title_matches, ...
        abstract_matches, body_matches);

    actSolution = +any( class_pat ); 
    expSolution = 0; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormal1Classif(testCase)

    searchdict = {'automat', 'robot', 'movabl', 'autonom', ...
        'adapt', 'self-generat', 'detect', 'program', 'comput'};
    title_matches = zeros(20, 9);
    abstract_matches = zeros(20, 9);
    body_matches = zeros(20, 9);
    body_matches(1, 1) = 1;
    
    class_pat = classif_alg1(searchdict, title_matches, ...
        abstract_matches, body_matches);

    actSolution = + ( (sum(class_pat) == 1) && (class_pat(1, 1) == 1) ); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormal2Classif(testCase)

    searchdict = {'automat', 'robot', 'movabl', 'autonom', ...
        'adapt', 'self-generat', 'detect', 'program', 'comput'};
    title_matches = zeros(20, 9);
    abstract_matches = zeros(20, 9);
    body_matches = zeros(20, 9);
    body_matches(1, 1) = 1;
    body_matches(2, 1) = 1;
    body_matches(1, 2) = 150;
    
    class_pat = classif_alg1(searchdict, title_matches, ...
        abstract_matches, body_matches);

    actSolution = + ( (sum(class_pat) == 2) && (class_pat(2, 1) == 1) ); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNegativeMatches(testCase)

    searchdict = {'automat', 'robot', 'movabl', 'autonom', ...
        'adapt', 'self-generat', 'detect', 'program', 'comput'};
    title_matches = zeros(20, 9);
    abstract_matches = zeros(20, 9);
    body_matches = zeros(20, 9);
    body_matches(5, 3) = -16;
    
    class_pat = classif_alg1(searchdict, title_matches, ...
        abstract_matches, body_matches);

    actSolution = + ( (sum(class_pat) == 0) && (class_pat(5, 1) == 0) ); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testMoreUnusedTokens(testCase)

    searchdict = {'putthisin_here', 'automat', 'robot', 'movabl', ...
        'autonom', 'adapt', 'self-generat', 'detect', 'program', ...
        'comput'};
    title_matches = zeros(20, 10);
    abstract_matches = zeros(20, 10);
    body_matches = zeros(20, 10);
    body_matches(5, 3) = -16;
    
    class_pat = classif_alg1(searchdict, title_matches, ...
        abstract_matches, body_matches);

    actSolution = + ( (sum(class_pat) == 0) && (class_pat(5, 1) == 0) ); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testMoreTokwithPosMatch(testCase)

    searchdict = {'putthisin_here', 'automat', 'robot', 'movabl', ...
        'autonom', 'adapt', 'self-generat', 'detect', 'program', ...
        'comput'};
    title_matches = zeros(20, 10);
    abstract_matches = zeros(20, 10);
    body_matches = zeros(20, 10);
    body_matches(2, 1) = 3;
    
    class_pat = classif_alg1(searchdict, title_matches, ...
        abstract_matches, body_matches);

    actSolution = +( sum(class_pat) == 0); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end
