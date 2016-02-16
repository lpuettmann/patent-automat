function tests = test_compile_incidence_matrix
    tests = functiontests(localfunctions);
end

function testNormalCase1(testCase)
    
    tokenList = {'a'; 'b'; 'c'; 'd'; 'e'};
    docTokens = {{'b'; 'd'}; {'d'}; {'e'; 'a'; 'b'; 'c'}};

    incidMat = compile_incidence_matrix(tokenList, docTokens);
    
    % Convert sparse to full matrix
    incidMat = full(incidMat);
    
    actSolution = + all(incidMat(3, :) == [1, 1, 1, 0, 1]); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalCase2(testCase)
    
    tokenList = {'a'; 'b'};
    docTokens = {{'a'; 'b'}; {'ZZZZZZZZ123'}};
  
    incidMat = compile_incidence_matrix(tokenList, docTokens);

    % Convert sparse to full matrix
    incidMat = full(incidMat);
    
    actSolution = + all( all(incidMat == [1, 1; 0, 0]) ); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end
