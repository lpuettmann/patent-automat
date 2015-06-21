function tests = test_count_elements_cell
    tests = functiontests(localfunctions);
end


function testSimpleCount(testCase)

    in_cellarray = {[1];
                    [4];
                    [4];
                    [4];
                    [4];
                    [3]};            
            
    element_count = count_elements_cell(in_cellarray);
    actSolution = element_count;
    expSolution = 6;    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testNested(testCase)

    in_cellarray = {[1];
                    [4];
                    [3, 2]};            
            
    element_count = count_elements_cell(in_cellarray);
    actSolution = element_count;
    expSolution = 4;    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testEmptyCase(testCase)

    in_cellarray = {[1];
                    [];
                    [3, 2]};            
            
    element_count = count_elements_cell(in_cellarray);
    actSolution = element_count;
    expSolution = 3;    
    
    verifyEqual(testCase, actSolution, expSolution)
end