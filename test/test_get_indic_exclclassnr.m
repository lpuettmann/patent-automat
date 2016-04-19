function tests = test_get_indic_exclclassnr
    tests = functiontests(localfunctions);
end

function test_normalKnown2Excl(testCase)
    exclude_techclass = choose_exclude_techclass();
    uspc_nr = { num2str( exclude_techclass(1) ) }; % this should be exluded
    actSolution = get_indic_exclclassnr(uspc_nr);
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_normalKnownNotExcl(testCase)
    % This doesn't look like a USPC number and should NOT be exluded
    uspc_nr = {'0.000346'}; 
    actSolution = get_indic_exclclassnr(uspc_nr);
    expSolution = 0; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_NegativeStrangeNum(testCase)
    uspc_nr = { num2str( -sqrt(31984) ) }; 
    actSolution = get_indic_exclclassnr(uspc_nr);
    expSolution = 0; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_DoubleCellError(testCase)
    
    % The numbers look right and they are in a cell array, but they should
    % be strings, not doubles.
    uspc_nr = {123; 512; 742}; 
    
    try
        indic_exclclassnr = get_indic_exclclassnr(uspc_nr);
        actSolution = 0; % this is wrong
    catch
        actSolution = 1; % yes, this is right.
    end
    
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end
