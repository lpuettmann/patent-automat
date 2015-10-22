function tests = test_shorten_cellarray
    tests = functiontests(localfunctions);
end

function test_normalShorten3(testCase)

    in_cellarray = {'hi', 'abcdef', '1234567'};
    
    nr_char = 3;
    out_cellarray_short = shorten_cellarray(in_cellarray, nr_char);   
    
    expected_out = {'hi'; 'abc'; '123'};
    
    % + converts logical to double
    actSolution = +strcmp(out_cellarray_short, expected_out); 
    expSolution = [1; 1; 1]; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_Shorten1PartlyCorrect(testCase)

    in_cellarray = {'hi', 'abcdef', '1234567'};
    
    nr_char = 1;
    out_cellarray_short = shorten_cellarray(in_cellarray, nr_char);   
    
    expected_out = {'h'; 'abc'; '123'};
    
    % + converts logical to double
    actSolution = +strcmp(out_cellarray_short, expected_out); 
    expSolution = [1; 0; 0]; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_Shorten2Zero(testCase)

    in_cellarray = {'hi', 'abcdef', '1234567'};
    
    nr_char = 0;
    out_cellarray_short = shorten_cellarray(in_cellarray, nr_char);   
    
    expected_out = {''; ''; 'aaa'};
    
    % + converts logical to double
    actSolution = +strcmp(out_cellarray_short, expected_out); 
    expSolution = [1; 1; 0]; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_CatchErrorShorten2Negativ(testCase)

    in_cellarray = {'hi', 'abcdef', '1234567'};
    
    nr_char = -1;
    
    try
        out_cellarray_short = shorten_cellarray(in_cellarray, nr_char);  
        actSolution = 0;
    catch
        actSolution = 1; % if correctly throws error
    end
    
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_CatchError_inputNotCellArr(testCase)

    in_cellarray = [1:10];
    
    nr_char = 3;
    
    try
        out_cellarray_short = shorten_cellarray(in_cellarray, nr_char);  
        actSolution = 0;
    catch
        actSolution = 1; % if correctly throws error
    end
    
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end
