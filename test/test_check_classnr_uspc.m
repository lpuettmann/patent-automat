function tests = test_check_classnr_uspc
    tests = functiontests(localfunctions);
end

function test_normalKnown2Excl(testCase)
    exclude_techclass = choose_exclude_techclass();
    pickExcl = exclude_techclass(1);
    classnr_uspc = pickExcl; % this should be exluded
    actSolution = check_classnr_uspc(classnr_uspc);
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_normalKnownNotExcl(testCase)
    % This doesn't look like a USPC number and should NOT be exluded
    classnr_uspc = 0.000346; 
    actSolution = check_classnr_uspc(classnr_uspc);
    expSolution = 0; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_NegativeStrangeNum(testCase)
    classnr_uspc = -sqrt(31984); 
    actSolution = check_classnr_uspc(classnr_uspc);
    expSolution = 0; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_StrError(testCase)
    classnr_uspc = 'Hello World!'; 
    
    % Should not work with a string, so check that it throws an error
    try
        indic_exclclassnr = check_classnr_uspc(classnr_uspc);
        actSolution = 0; % this is wrong
    catch
        actSolution = 1; % yes, this is right.
    end
    
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_CellArrError(testCase)
    
    % The numbers look right, but they are in a cell array, not in a matrix
    % as excpected, so check that it throws an error.
    classnr_uspc = {123; 512; 742}; 
    
    try
        indic_exclclassnr = check_classnr_uspc(classnr_uspc);
        actSolution = 0; % this is wrong
    catch
        actSolution = 1; % yes, this is right.
    end
    
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end
