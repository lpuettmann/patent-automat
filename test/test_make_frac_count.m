function tests = test_make_frac_count
    tests = functiontests(localfunctions);
end

function test_normal(testCase)

    in_cellarray = {{'a'}; {'b'}; {'c'}; {'d'}};
    alg1 = [0; 0; 0; 1];
    

    [frac_counts, alg1_flatten] = make_frac_count(in_cellarray, alg1);
  
    actSolution = isequal(frac_counts, [1; 1; 1; 1]) & ...
        isequal(alg1_flatten, alg1);
    actSolution = +actSolution; % convert logical to double
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_oneNested(testCase)

    in_cellarray = {{'a'}; {'b'; 'z'}; {'c'}; {'d'}};
    alg1 = [0; 0; 0; 1];
    

    [~, alg1_flatten] = make_frac_count(in_cellarray, alg1);
  
    actSolution =  +isequal( alg1_flatten, [0; 0; 0; 0; 1]);
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end
