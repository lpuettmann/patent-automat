function tests = test_extract_pat_fileplace
    tests = functiontests(localfunctions);
end

function testNrPatInFile(testCase)
    
    patentnr = 4100602;
    indic_year = 1978;
    opt2001 = 'txt';

    patfplace = extract_pat_fileplace(patentnr, indic_year);
    
    actSolution = patfplace.nr_pat_in_file; 
    expSolution = 1429; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testWeek(testCase)
    
    patentnr = 7135110;
    indic_year = 2006;

    patfplace = extract_pat_fileplace(patentnr, indic_year);
    
    actSolution = patfplace.week; 
    expSolution = 46; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testLineStart(testCase)
    
    patentnr = 08944546;
    indic_year = 2015;

    patfplace = extract_pat_fileplace(patentnr, indic_year);
    
    actSolution = patfplace.line_start; 
    expSolution = 1179035; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testLineEndIfLastPatInWeeklFile(testCase)
    
    patentnr = 045205086;
    indic_year = 1985;

    patfplace = extract_pat_fileplace(patentnr, indic_year);
    
    actSolution = +isnan( patfplace.line_end ); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end