function tests = test_customize_ftset
    tests = functiontests(localfunctions);
end

function testIndicFiletype1(testCase)
    
    ftset = customize_ftset(1976);
    actSolution = ftset.indic_filetype;
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testIndicFiletype2(testCase)
    
    ftset = customize_ftset(2003);
    actSolution = ftset.indic_filetype;
    expSolution = 2;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testIndicFiletype3(testCase)
    
    ftset = customize_ftset(2009);
    actSolution = ftset.indic_filetype;
    expSolution = 3;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testTitleString1(testCase)
    
    ftset = customize_ftset(1982);
    actSolution = +strcmp(ftset.indic_titlefind, 'TTL ');    
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testBodyString2(testCase)
    
    ftset = customize_ftset(2004);
    actSolution = +strcmp(ftset.indic_bodyfind, '<SDODE>');    
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end


function test2001txt(testCase)
    
    ftset = customize_ftset(2001, 'txt');
    actSolution = ftset.indic_filetype;    
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test2001xml(testCase)
    
    ftset = customize_ftset(2001, 'xml');
    actSolution = +strcmp(ftset.patent_findstr, '<!DOCTYPE PATDOC PUBLIC "-//USPTO//DTD ST.32 US PATENT GRANT V2.4 2000-09-20//EN" [');   
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test2001error(testCase)

    try
        ftset = customize_ftset(2001);
        actSolution = 0;
    catch
        actSolution = 1;
    end        

    expSolution = 1;
    verifyEqual(testCase, actSolution, expSolution)
end


function test2001NoCauseTroubleXML(testCase)
    
    ftset = customize_ftset(1976, 'xml');
    actSolution = +strcmp(ftset.indic_bodyfind, 'BSUM');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test2001NoCauseTroubleTXT(testCase)
    
    ftset = customize_ftset(1976, 'txt');
    actSolution = +strcmp(ftset.indic_bodyfind, 'BSUM');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end
