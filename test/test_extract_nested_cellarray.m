function tests = test_extract_nested_cellarray
    tests = functiontests(localfunctions);
end

function testNormalCase(testCase)
    inNestedCellArray = {{'a'}; {'b'}; {'c'}; {'d'}; {'e'}};     
    allCells = extract_nested_cellarray(inNestedCellArray);
    correctCells = {'a'; 'b'; 'c'; 'd'; 'e'};
    
    actSolution = + all( strcmp(allCells, correctCells) );
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end
