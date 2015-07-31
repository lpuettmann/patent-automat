function tests = test_setWeekend
    tests = functiontests(localfunctions);
end

function test1976Case52Weeks(testCase)
    
    actSolution = set_weekend(1976);
    expSolution = 52;    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function test1982Case52Weeks(testCase)
    
    actSolution = set_weekend(1982);
    expSolution = 52;    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function test1980Case53Weeks(testCase)
    
    actSolution = set_weekend(1980);
    expSolution = 53;    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function test2014Case52Weeks(testCase)
    
    actSolution = set_weekend(2014);
    expSolution = 52;    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function test2013Case53Weeks(testCase)
    
    actSolution = set_weekend(2013);
    expSolution = 53;    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function test2015withVaryingWeeks(testCase)
    
    actSolution = set_weekend(2015);
    expSolution = 11;    
    
    verifyEqual(testCase, actSolution, expSolution)
end

