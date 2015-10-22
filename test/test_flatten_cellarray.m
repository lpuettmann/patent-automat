function tests = test_flatten_cellarray
    tests = functiontests(localfunctions);
end

function testNormal_1(testCase)
    
    in_cellarray = {{'a'}; {'b'}; {'123'}; {'d'}; {'This is a sentence.'}};

    out_cellarray_flat = flatten_cellarray(in_cellarray)
    
    actSolution = out_cellarray_flat;
    expSolution = 52;    
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormal_2(testCase)
    
    in_cellarray = {{'a'}; {'b'}; { {'hi'}; {'there'} } }

    out_cellarray_flat = flatten_cellarray(in_cellarray)
    
    actSolution = out_cellarray_flat;
    expSolution = 52;    
    
    verifyEqual(testCase, actSolution, expSolution)
end

