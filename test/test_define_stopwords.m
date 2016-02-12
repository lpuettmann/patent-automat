function tests = test_define_stopwords
    tests = functiontests(localfunctions);
end

function testPlausibleNumberNotTooLow(testCase)
    
    stop_words = define_stopwords();
        
    % The plus converts logical to double
    actSolution = +( length(stop_words) > 5 );
    expSolution = 1;    
    verifyEqual(testCase, actSolution, expSolution)
end

function testPlausibleNumberNotTooHigh(testCase)
    
    stop_words = define_stopwords();
        
    actSolution = +( length(stop_words) < 20000 );
    expSolution = 1;    
    verifyEqual(testCase, actSolution, expSolution)
end

function testIncludeKnownStopWord_And(testCase)
    
    stop_words = define_stopwords();
        
    actSolution = +any( strcmp(stop_words, 'and') );

    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testIncludeKnownStopWord_This(testCase)
    
    stop_words = define_stopwords();
        
    actSolution = +any( strcmp(stop_words, 'this') );
    expSolution = 1;    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNotIncludeNotStopWord(testCase)
    
    stop_words = define_stopwords();
        
    actSolution = +not( any( strcmp(stop_words, 'robot') ) );
    expSolution = 1;
    verifyEqual(testCase, actSolution, expSolution)
end

function testReturnsCellArray(testCase)
    
    stop_words = define_stopwords();
        
    actSolution = +iscell(stop_words);
    expSolution = 1;    
    verifyEqual(testCase, actSolution, expSolution)
end

function testAllCellArrayContentsAreStrings(testCase)
    
    stop_words = define_stopwords();
   
    for i=1:length(stop_words)
        extr_str = stop_words{i};
        check_allStr(i) = +ischar(extr_str);
    end
    
    actSolution = +all( check_allStr );
    expSolution = 1;    
    verifyEqual(testCase, actSolution, expSolution)
end
