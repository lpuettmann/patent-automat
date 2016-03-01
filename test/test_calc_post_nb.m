function tests = test_calc_post_nb
    tests = functiontests(localfunctions);
end

function testKnownExample_China(testCase)
    % See Manning, Raghavan, Schuetze (2008) chapter 13, p.264.
    % Check posterior prob. for document to belong to class "china"
    prior = 3/4;
    cond_prob = [4/5; % Chinese
                 1/5; % Japan
                 1/5; % Tokyo
                 2/5; % Beijing
                 2/5; % Macao
                 2/5]; % Shanghai
    indic_appear = logical([1;
                            1;
                            1;
                            0;
                            0;
                            0]);
    post = calc_post_nb(prior, cond_prob, indic_appear);
    actSolution = exp(post);
    expSolution = 3/4 * 4/5 * 1/5 * 1/5 * (1-2/5) * (1-2/5) * (1-2/5);
    
    diffSolutions = (actSolution - expSolution) / actSolution;
    verifyLessThan(testCase, diffSolutions, 10^-5)
end

function testKnownExample_NotClass(testCase)
    % Check posterior prob. for document to belong to class "NOT china"
    prior = 1/4;
    cond_prob = [2/3; % Chinese
                 2/3; % Japan
                 2/3; % Tokyo
                 1/3; % Beijing
                 1/3; % Macao
                 1/3]; % Shanghai
    indic_appear = logical([1;
                            1;
                            1;
                            0;
                            0;
                            0]);
    post = calc_post_nb(prior, cond_prob, indic_appear);
    actSolution = exp(post);
    expSolution = 1/4 * 2/3 * 2/3 * 2/3 * (1-1/3) * (1-1/3) * (1-1/3);
    
    diffSolutions = (actSolution - expSolution) / actSolution;
    verifyLessThan(testCase, diffSolutions, 10^-5)
end
