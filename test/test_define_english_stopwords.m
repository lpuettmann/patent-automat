function tests = test_define_english_stopwords
    tests = functiontests(localfunctions);
end

function testPlausibleNumberNotTooLow(testCase)
    
    english_stop_words = define_english_stopwords();
        
    % The plus converts logical to double
    actSolution = +( length(english_stop_words) > 5 );
    expSolution = 1;    
    verifyEqual(testCase, actSolution, expSolution)
end

function testPlausibleNumberNotTooHigh(testCase)
    
    english_stop_words = define_english_stopwords();
        
    actSolution = +( length(english_stop_words) < 20000 );
    expSolution = 1;    
    verifyEqual(testCase, actSolution, expSolution)
end

function testIncludeKnownStopWord_And(testCase)
    
    english_stop_words = define_english_stopwords();
        
    actSolution = +any( strcmp(english_stop_words, 'and') );

    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testIncludeKnownStopWord_This(testCase)
    
    english_stop_words = define_english_stopwords();
        
    actSolution = +any( strcmp(english_stop_words, 'this') );
    expSolution = 1;    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNotIncludeNotStopWord(testCase)
    
    english_stop_words = define_english_stopwords();
        
    actSolution = +not( any( strcmp(english_stop_words, 'robot') ) );
    expSolution = 1;
    verifyEqual(testCase, actSolution, expSolution)
end

function testReturnsCellArray(testCase)
    
    english_stop_words = define_english_stopwords();
        
    actSolution = +iscell(english_stop_words);
    expSolution = 1;    
    verifyEqual(testCase, actSolution, expSolution)
end

function testAllCellArrayContentsAreStrings(testCase)
    
    english_stop_words = define_english_stopwords();
   
    for i=1:length(english_stop_words)
        extr_str = english_stop_words{i};
        check_allStr(i) = +ischar(extr_str);
    end
    
    actSolution = +all( check_allStr );
    expSolution = 1;    
    verifyEqual(testCase, actSolution, expSolution)
end
