function tests = test_flatten_cellarray
    tests = functiontests(localfunctions);
end

function testNonNested(testCase)
    
    in_cellarray = {{'a'}; {'b'}; {'123'}; {'d'}; {'This is a sentence.'}};

    out_cellarray_flat = flatten_cellarray(in_cellarray);
    
    expected_out = {'a'; 'b'; '123'; 'd'; 'This is a sentence.'};
    
    % + converts logical to double
    actSolution = +strcmp(out_cellarray_flat, expected_out); 
    expSolution = [1; 1; 1; 1; 1]; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalNested(testCase)
    
    in_cellarray = {{'a'}; {'b'}; { 'hi'; 'there' } };

    out_cellarray_flat = flatten_cellarray(in_cellarray);
    
    expected_out = {'a'; 'b'; 'hi'; 'there'};
    
    % + converts logical to double
    actSolution = +strcmp(out_cellarray_flat, expected_out); 
    expSolution = [1; 1; 1; 1];    
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_tooManyNestedCatchError(testCase)
    
    % This cell array has three nested layers and the function doesn't work
    % for this.
    in_cellarray = {{'a'}; {'b'}; { 'hi'; {'there'; 'this'} } };

    try
        out_cellarray_flat = flatten_cellarray(in_cellarray);
        actSolution = 0;
    catch % Check that the function throws an error
        actSolution = 1; % if function correctly throws error
    end

    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_CatchErrorNotCellarray(testCase)
    
    in_cellarray = [1:10];

    try
        out_cellarray_flat = flatten_cellarray(in_cellarray);
        actSolution = 0;
    catch % Check that the function throws an error
        actSolution = 1; % if function correctly throws error
    end

    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_CatchErrorMultyDimCellArray(testCase)
    
    in_cellarray = {'a', 'b'; 'c', 'd'};

    try
        out_cellarray_flat = flatten_cellarray(in_cellarray);
        actSolution = 0;
    catch % Check that the function throws an error
        actSolution = 1; % if function correctly throws error
    end

    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end
