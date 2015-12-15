function tests = test_tokenize_string
    tests = functiontests(localfunctions);
end

function test_normalSnowballCase1(testCase)

    inStr = 'automatically';
    english_stop_words = define_english_stopwords();
    tokens = tokenize_string(inStr, 'snowball', english_stop_words);
    
    expected_out = 'automat';
    
    % + converts logical to double
    actSolution = +strcmp(tokens, expected_out); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_normalSnowballCase2(testCase)

    inStr = 'robotically';
    english_stop_words = define_english_stopwords();
    tokens = tokenize_string(inStr, 'snowball', english_stop_words);
    
    expected_out = 'robot';
    
    actSolution = +strcmp(tokens, expected_out); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_normalSnowballCase3(testCase)

    inStr = 'grandeur';
    english_stop_words = define_english_stopwords();
    tokens = tokenize_string(inStr, 'snowball', english_stop_words);
    
    expected_out = 'grandeur';
    
    actSolution = +strcmp(tokens, expected_out); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_normalSnowballCase3(testCase)

    inStr = 'switzerland';
    english_stop_words = define_english_stopwords();
    tokens = tokenize_string(inStr, 'snowball', english_stop_words);
    
    expected_out = 'switzerland';
    
    actSolution = +strcmp(tokens, expected_out); 
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_SnowballSplitStr1(testCase)

    inStr = 'Hi there, how are you today. All ok on the moon?';
    english_stop_words = define_english_stopwords();
    tokens = tokenize_string(inStr, 'snowball', english_stop_words);
    
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
    english_stop_words = define_english_stopwords();
    tokens = tokenize_string(inStr, 'snowball', english_stop_words);
    
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
    english_stop_words = define_english_stopwords();
    tokens = tokenize_string(inStr, 'snowball', english_stop_words);
    
    expected_out = {'automat', '--he---lo---', 'today', 'moon'};
    
    for i=1:length(tokens)
        checkequal(i) = max( strcmp(expected_out, tokens{i}) ); 
    end

    actSolution = +min(checkequal);
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_DifferentStopwords(testCase)

    inStr = 'This is and full of stopwords in yes great, moonlanding.';
    my_stop_words = {'moonlanding', 'the martian'};
    tokens = tokenize_string(inStr, 'snowball', my_stop_words);
    
    expected_out = {'this', 'and', 'full', 'stopword', 'yes', 'great'};
    
    for i=1:length(tokens)
        checkequal(i) = max( strcmp(expected_out, tokens{i}) ); 
    end

    actSolution = +min(checkequal);
    expSolution = 1; 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_EmptyStopWordsCheckError(testCase)

    inStr = 'This is and full of stopwords in yes great, moonlanding.';
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
