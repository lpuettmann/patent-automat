function tests = test_check_classnr_uspc
    tests = functiontests(localfunctions);
end

function testNormalNone(testCase)

    inMat = [1;
            4;
            4;
            4;
            4;
            3];            
            
    res = check_classnr_uspc(inMat);
    actSolution = +any( res );
    expSolution = 0;    
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testKnown1Nr(testCase)

    % Here I am HARD CODING one of the tech numbers that we are excluding.
    % If we later decide to change which numbers to exclude and this is one
    % of them, then this would throw an error. (In that case, change this
    % here or delete this test case if you know what you're doing.)
    inMat = 564;
    actSolution = check_classnr_uspc(inMat);
    expSolution = 1;    
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalAllKnown(testCase)

    exclude_techclass = choose_exclude_techclass();    
    inMat = exclude_techclass;
    res = check_classnr_uspc(inMat);
    actSolution = +all( res );
    expSolution = 1;    
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testStrTest4Error(testCase)

    try
        res = check_classnr_uspc('ABCD');
        actSolution = 0;
    catch
        actSolution = 1;
    end
    
    expSolution = 1;    
    
    verifyEqual(testCase, actSolution, expSolution)
end




