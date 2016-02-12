function tests = test_tokenize_string
    tests = functiontests(localfunctions);
end

function test_normalSnowballCase1(testCase)

    inStr = 'automatically';
    stop_words = define_stopwords();
    tokens = tokenize_string(inStr, 'snowball', stop_words);
    
    expected_out = 'automat';
    
    % + converts logical to double
    actSolution = +strcmp(tokens, expected_out); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_normalSnowballCase2(testCase)

    inStr = 'robotically';
    stop_words = define_stopwords();
    tokens = tokenize_string(inStr, 'snowball', stop_words);
    
    expected_out = 'robot';
    
    actSolution = +strcmp(tokens, expected_out); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_normalSnowballCase3(testCase)

    inStr = 'grandeur';
    stop_words = define_stopwords();
    tokens = tokenize_string(inStr, 'snowball', stop_words);
    
    expected_out = 'grandeur';
    
    actSolution = +strcmp(tokens, expected_out); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_normalSnowballCase4(testCase)

    inStr = 'switzerland';
    stop_words = define_stopwords();
    tokens = tokenize_string(inStr, 'snowball', stop_words);
    
    expected_out = 'switzerland';
    
    actSolution = +strcmp(tokens, expected_out); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_SnowballSplitStr1(testCase)

    inStr = 'Hi there, how are you today. All ok on the moon?';
    stop_words = define_stopwords();
    tokens = tokenize_string(inStr, 'snowball', stop_words);
    
    expected_out = {'today', 'moon'};
    
    for i=1:length(expected_out)
        checkequal(i) = max( strcmp(tokens, expected_out{i}) ); 
    end

    actSolution = +min(checkequal);
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_SnowballSplitStr2(testCase)

    inStr = 'Hi there, how automatically/are you today. All ok on the moon?';
    stop_words = define_stopwords();
    tokens = tokenize_string(inStr, 'snowball', stop_words);
    
    expected_out = {'automat', 'today', 'moon'};
    
    for i=1:length(tokens)
        checkequal(i) = max( strcmp(expected_out, tokens{i}) ); 
    end

    actSolution = +min(checkequal);
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_SnowballSplitStr3(testCase)

    inStr = 'Hi there, how automatically/are --he---lo--- you today. All ok on the moon?';
    stop_words = define_stopwords();
    tokens = tokenize_string(inStr, 'snowball', stop_words);
    
    expected_out = {'automat', 'he---lo', 'today', 'moon'};
    
    for i=1:length(tokens)
        checkequal(i) = max( strcmp(expected_out, tokens{i}) ); 
    end

    actSolution = +min(checkequal);
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_DifferentStopwords(testCase)

    inStr = 'This is and full of stop_words in yes great, moonlanding.';
    my_stop_words = {'moonlanding', 'the martian'};
    tokens = tokenize_string(inStr, 'snowball', my_stop_words);
    
    expected_out = {'this'; 'and'; 'full'; 'stop_word'; 'yes'; 'great'};
    actSolution = +min(strcmp(tokens, expected_out));
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_EmptyStopWordsCheckError(testCase)

    inStr = 'This is and full of stop_words in yes great, moonlanding.';
    my_stop_words = {};
    
    % This should throw an error, as my_stop_words is not a string.
    actSolution = 0;
    try
        tokens = tokenize_string(inStr, 'snowball', my_stop_words);
    catch
        actSolution = 1;
    end

    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end
