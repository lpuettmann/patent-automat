function tests = test_strtrim_punctuation
    tests = functiontests(localfunctions);
end

function testNormalCase(testCase)
    
    inCellArray = {'Hello world.'};
    outCellArray = strtrim_punctuation(inCellArray);
    
    actSolution = +strcmp(outCellArray, 'Hello world'); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testStrTrimPunctOfList(testCase)
    
    inCellArray = {'hi'; 'there'; '--ato-mat-'; 'moonlight-'; ...
        '-*-marsiantoystory***'; '--------hello'; 'hello---'; '-hello-'; ...
        ''; '111111111111111'; '2222---222---'; '---aaaa---aaaa'; ...
        '---zzz---zzz---zzz'; '111---111---111---'};
    outCellArray = strtrim_punctuation(inCellArray);
    
    correctResult = {'hi'; 'there'; 'ato-mat'; 'moonlight'; ...
        'marsiantoystory'; 'hello'; 'hello'; 'hello'; ...
        ''; '111111111111111'; '2222---222'; 'aaaa---aaaa'; ...
        'zzz---zzz---zzz'; '111---111---111'};
    
    actSolution = +min( strcmp(outCellArray, correctResult) ); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end
