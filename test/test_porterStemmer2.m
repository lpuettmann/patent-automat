function tests = test_porterStemmer2
    tests = functiontests(localfunctions);
end


function testNormalCase1(testCase)

    inString = 'consign'; 
    word_stem = porterStemmer2(inString);
    
    actSolution = +strcmp(word_stem, 'consign');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalCase2(testCase)

    inString = 'consigned'; 
    word_stem = porterStemmer2(inString);
    
    actSolution = +strcmp(word_stem, 'consign');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalCase3(testCase)

    inString = 'kneading'; 
    word_stem = porterStemmer2(inString);
    
    actSolution = +strcmp(word_stem, 'knead');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalCase4(testCase)

    inString = 'consolidating'; 
    word_stem = porterStemmer2(inString);
    
    actSolution = +strcmp(word_stem, 'consolid');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalCase5(testCase)

    inString = 'constant'; 
    word_stem = porterStemmer2(inString);
    
    actSolution = +strcmp(word_stem, 'constant');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormalCase6(testCase)

    inString = 'knavish'; 
    word_stem = porterStemmer2(inString);
    
    actSolution = +strcmp(word_stem, 'knavish');
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end

% function testLargeDictionary(testCase)
% 
%     % Load file with english words and the correct version stemmed with the
%     % Porter 2 (Snowball) stemmer.
%     % Source: http://snowball.tartarus.org/algorithms/english/diffs.txt
% 
%     % Get vocabulary of words
%     fileID = fopen('voc.txt');
%     voc = textscan(fileID, '%s', 'Delimiter', '\n');
%     voc = voc{1};
%     fclose(fileID);
% 
%     % Get the correct output from the stemmer
%     fileID = fopen('output.txt');
%     output = textscan(fileID, '%s', 'Delimiter', '\n');
%     output = output{1};
%     fclose(fileID);
% 
%     assert( length(voc) == length(output) )
% 
%     word_stem = repmat({''}, size(voc)); 
%     for i=1:length(voc)
%         inString = voc{i}; 
%         word_stem{i} = porterStemmer2(inString);
%         correct_output = output{i};
% 
%         % Check if the function returns the correct answer
%         checkVec(i,1) = +strcmp(word_stem{i}, correct_output);
%     end
% 
%     statswrong.ix_wrong = find(checkVec == 0);
%     statswrong.token = voc(statswrong.ix_wrong);
%     statswrong.expected_output = output(statswrong.ix_wrong);
%     statswrong.wrongly_stemmed = word_stem(statswrong.ix_wrong);
%     statswrong = struct2table(statswrong);
% 
%     nr_pat_wrongstem = height(statswrong);
%     
%     if nr_pat_wrongstem > 0
%         percent_pat_wrongstem = nr_pat_wrongstem / size(voc, 1);
%         fprintf('%d of %d (%3.2f percent) word stems wrongly stemmed by porterStemmer2.m.\n', ...
%             nr_pat_wrongstem, size(voc, 1), percent_pat_wrongstem*100)
%     end
%     
%     actSolution = min( checkVec );
%     expSolution = 1;
% 
%     verifyEqual(testCase, actSolution, expSolution)
% end

