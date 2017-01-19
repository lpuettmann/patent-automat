function tests = test_strip_patentnr
    tests = functiontests(localfunctions);
end

function testNormal(testCase)
    
    patentnr = {'D0435713'; 'D0435713'; 'D0435713'};
    ix_year = 1976;
    opt2001 = 'txt';

    patent_number_cleaned = strip_patentnr(patentnr, ix_year, opt2001); 
    actSolution = +min( strcmp(patent_number_cleaned{1,1}, '043571') ); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalNoOpt2001(testCase)
    
    patentnr = {'D0435713'; 'D0435713'; 'D0435713'};
    ix_year = 1976;

    patent_number_cleaned = strip_patentnr(patentnr, ix_year);
    actSolution = +min( strcmp(patent_number_cleaned{1,1}, '043571') ); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testRightLength7(testCase)
    
    patentnr = {'D0558525'; 'D0558526'; 'D0558527'; 'D0558528'; ....
        'D0558529'; 'D0558530'; 'D0558531'; 'D0558532'; 'D0558533'};
    ix_year = 2008;

    patent_number_cleaned = strip_patentnr(patentnr, ix_year);
    actSolution = numel(patent_number_cleaned{2}); 
    expSolution = 7; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testMissInput(testCase)
    
    patentnr = {'ABCDEFG'};
    ix_year = 2001;

    try 
        patent_number_cleaned = strip_patentnr(patentnr, ix_year);
        actSolution = 0;
    catch
        actSolution = 1;
    end
    
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test2001txtRightLen(testCase)
    
    patentnr = {'ABCDEFG'};
    ix_year = 2001;
    opt2001 = 'txt';

    patent_number_cleaned = strip_patentnr(patentnr, ix_year, opt2001);
    actSolution = length(patent_number_cleaned{1});
    expSolution = 5; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test2001xmlRightLen(testCase)
    
    patentnr = {'ABCDEFG'};
    ix_year = 2001;
    opt2001 = 'xml';

    patent_number_cleaned = strip_patentnr(patentnr, ix_year, opt2001);
    actSolution = length(patent_number_cleaned{1});
    expSolution = 6; 
    
    verifyEqual(testCase, actSolution, expSolution)
end
