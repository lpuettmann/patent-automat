function tests = test_count_occurences
    tests = functiontests(localfunctions);
end

function testIndicatorFind(testCase)

    file_str = {'Hi this computer is my new test string that I';
                'testKeyword';
                'will parse for some self-defined keywords';
                'that I choose myself.computer'};     
    find_str = 'testKeyword';
    
    [indic_find, ~, ~] = test_count_occurences(file_str, find_str);
    actSolution = indic_find;
    expSolution = logical([0; 1; 0; 0]);    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testNrFind(testCase)

    file_str = {'Hi this computer is my new test string that I';
                'testKeyword';
                'will parse for some self-defined keywords';
                'testKeyword';
                'that I choose myself.computer';
                'testKeyword';};     
    find_str = 'testKeyword';
    
    [~, nr_find, ~] = test_count_occurences(file_str, find_str);
    actSolution = nr_find;
    expSolution = 3;    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testIxFind(testCase)

    file_str = {'Hi this computer is my new test string that I';
                'testKeyword';
                'will parse for some self-defined keywords';
                'testKeyword';
                'that I choose myself.computer';
                'testKeyword';};     
    find_str = 'testKeyword';
    
    [~, ~, ix_find] = test_count_occurences(file_str, find_str);
    actSolution = ix_find;
    expSolution = [2; 4; 6];    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testZeroMatches(testCase)

    file_str = {'Hi this computer is my new test string that I';
                'will parse for some self-defined keywords';
                'that I choose myself.computer'};
    find_str = 'testKeyword';
    
    [indic_find, ~, ~] = test_count_occurences(file_str, find_str);
    actSolution = indic_find;
    expSolution = logical([0; 0; 0]);    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testAllMatches(testCase)

    file_str = {'testKeyword';
                'testKeyword';
                'testKeyword';
                'testKeyword';
                'testKeyword'};
    find_str = 'testKeyword';
    
    [~, nr_find, ~] = test_count_occurences(file_str, find_str);
    actSolution = nr_find;
    expSolution = 5;    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testEmptyCorpusstring(testCase)

    file_str = {''};
    find_str = 'testKeyword';
    
    [~, nr_find, ~] = test_count_occurences(file_str, find_str);
    actSolution = nr_find;
    expSolution = 0;    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testEmptySearchstring(testCase)

    file_str = {'Hi this computer is my new test string that I';
                'testKeyword';
                'will parse for some self-defined keywords';
                'testKeyword';
                'that I choose myself.computer';
                'testKeyword';}; 
    find_str = '';
    
    % The file test_count_occurences will issue a warning for such a short
    % string. Turn this off temporarily.
    warning('off', 'all')
    [~, nr_find, ~] = test_count_occurences(file_str, find_str);
   warning('on', 'all')
    
    actSolution = nr_find;
    expSolution = 0;    
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testLongString(testCase)

    file_str = {'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus porttitor, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'}; 
    find_str = 'AllThingsNotHere';
    
    [~, nr_find, ~] = test_count_occurences(file_str, find_str);
    
    actSolution = nr_find;
    expSolution = 0;    
    
    verifyEqual(testCase, actSolution, expSolution)
end

