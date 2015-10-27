function tests = test_extract_first2digits
    tests = functiontests(localfunctions);
end

function testNormal1(testCase)

    vec_in = [998:1003]';

    first_digits = extract_first2digits(vec_in);
        
    % plus converts logical to double
    actSolution = +all( first_digits == [9; 9; 10; 10; 10; 10] );
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testNaNall(testCase)

    vec_in = [1:10]';

    first_digits = extract_first2digits(vec_in);
        
    actSolution = +all( isnan(first_digits) ); 
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end