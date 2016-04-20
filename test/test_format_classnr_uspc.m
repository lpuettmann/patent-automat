function tests = test_format_classnr_uspc
    tests = functiontests(localfunctions);
end

function testNormal(testCase)

    classnr_uspc = {'123456'};
    
    actSolution = format_classnr_uspc(classnr_uspc);
    expSolution = 123; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalSpace(testCase)

    classnr_uspc = {'78 9123'};
    
    actSolution = format_classnr_uspc(classnr_uspc);
    expSolution = 78; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalPunctuation(testCase)

    classnr_uspc = {'42X123Y'};
    
    actSolution = format_classnr_uspc(classnr_uspc);
    expSolution = 42; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalSeveral(testCase)

    classnr_uspc = {'4192873123', '23', '12A -1123'};
    
    res = format_classnr_uspc(classnr_uspc);
    actSolution = +(419==res(1) & 23==res(2) & 12==res(3));
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testAlphabeticOnly(testCase)

    classnr_uspc = {'ABC'};
    
    actSolution = format_classnr_uspc(classnr_uspc);
    expSolution = 0; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testVerbosityNormalSilent(testCase)

    classnr_uspc = {'123456'};
    actSolution = format_classnr_uspc(classnr_uspc, 'silent');
    expSolution = 123; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testVerbosityError(testCase)

    classnr_uspc = {'123456'};
    
    try
        res = format_classnr_uspc(classnr_uspc, 'greattimes');
        actSolution = 0; % we should not get here
    catch
        actSolution = 1; % this is right
    end
    
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testEmptyStr(testCase)

    classnr_uspc = {'123', ''};
    
    res = format_classnr_uspc(classnr_uspc);
    actSolution = res(2);
    expSolution = 0; 
    
    verifyEqual(testCase, actSolution, expSolution)
end
