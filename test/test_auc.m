function tests = testAUC
    tests = functiontests(localfunctions);
end

function test1(testCase)
    actual = [1; 0; 1; 1];
    posterior = [0.32; 0.52; 0.26; 0.86];
    score = calculate_auc(actual, posterior);
    verifyLessThan(testCase, abs(1/3-score), eps)
end

function test2(testCase)
    actual = [1; 0; 1; 0; 1];
    posterior = [0.9 0.1 0.8 0.1 0.7]';
    score = calculate_auc(actual, posterior);
    verifyLessThan(testCase, abs(1-score), eps)
end

function test3(testCase)
    actual = [0 1 1 0]';
    posterior = [0.2 0.1 0.3 0.4];
    score = calculate_auc(actual, posterior);
    verifyLessThan(testCase, abs(1/4-score), eps)
end

function test4(testCase)
    actual = [1 1 1 1 0 0 0 0 0 0 0]';
    posterior = ones(size(actual));
    score = calculate_auc(actual, posterior);
    verifyLessThan(testCase, abs(1/2-score), eps)
end
