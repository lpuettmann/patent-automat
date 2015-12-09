function tests = test_match_sic2ipc
    tests = functiontests(localfunctions);
end

function testNormalLargeExample(testCase)

    ipc_concordance = {'a'; 'z'};
    ipc_short = {'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j'; 'k'};
    frac_counts = [1/4; 1; 1; 1; 1; 1/5; 1; 1; 1; 1; 1];
    alg1_flatten = [1; 0; 0; 0; 1; 1; 0; 0; 0; 0; 0];
    ix_pick = [2; 9];
    mfgfrq = [0.4; 0.01; 0; 0.1 ; 0.1; 0.1 ; 0; 0.6; 0.1 ; 0.1; 0.1];
    usefrq = [0; 0.1; 0.1; 0.1 ; 0.3; 0.1 ; 0.1; 0.1; 0.1 ; 0.05; 0.1];
    
    sic_automix = match_sic2ipc(ipc_concordance, ipc_short, frac_counts, ...
        alg1_flatten, ix_pick, mfgfrq, usefrq);

    actSolution = isequal( sic_automix.total_nr_matched, [1; 0]) & ...
        isequal( sic_automix.total_frac_counts, [0.25; 0]) & ...
        isequal( sic_automix.autompat_nr_matched, [1; 0]) & ...
        isequal( sic_automix.total_frac_counts, [0.25; 0]) & ...
        isequal( sic_automix.automix_mfg, [0.01*0.25; 0]) & ...
        isequal( sic_automix.automix_use, [0.1*0.25; 0]);
    
    actSolution = +actSolution; % logical to double
    
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testNormal(testCase)

    ipc_concordance = {'f'};
    ipc_short = {'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j'; 'k'};
    frac_counts = [1/4; 1; 1; 1; 1; 1/5; 1; 1; 1; 1; 1];
    alg1_flatten = [1; 0; 0; 0; 1; 1; 0; 0; 0; 0; 0];
    ix_pick = 3;
    mfgfrq = [0.4; 0.1; 0.1];
    usefrq = [0; 0.05; 0.1];
    
    sic_automix = match_sic2ipc(ipc_concordance, ipc_short, frac_counts, ...
        alg1_flatten, ix_pick, mfgfrq, usefrq);

    numDiff = sic_automix.automix_use - 0.02;
    
    actSolution = +(numDiff < 0.000001);
    expSolution = 1;
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testNoAutomationPatent(testCase)

    ipc_concordance = {'b'};
    ipc_short = {'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j'; 'k'};
    frac_counts = [1/4; 1; 1; 1; 1; 1/5; 1; 1; 1; 1; 1];
    alg1_flatten = [1; 0; 0; 0; 1; 1; 0; 0; 0; 0; 0];
    ix_pick = 3;
    mfgfrq = [0.4; 0.1; 0.1];
    usefrq = [0; 0.05; 0.1];
    
    sic_automix = match_sic2ipc(ipc_concordance, ipc_short, frac_counts, ...
        alg1_flatten, ix_pick, mfgfrq, usefrq);
    
    actSolution = sic_automix.automix_use;
    expSolution = 0;
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testNoAutomationPatentAndCrazyAlg1Num(testCase)

    ipc_concordance = {'i', 'Zuckerbrot', '3'};
    ipc_short = {'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j'; 'k'};
    frac_counts = [1/4; 1; 1; 1; 1; 1/5; 1; 1; 1; 1; 1];
    alg1_flatten = [1; 0; 0; 0; 1; 1; 0; 0; 99; 0; 0]; % check out the 99
    ix_pick = [1, 2, 3];
    mfgfrq = [0.4; 0.1; 0.1];
    usefrq = [0; 0.05; 0.1];
    
    sic_automix = match_sic2ipc(ipc_concordance, ipc_short, frac_counts, ...
        alg1_flatten, ix_pick, mfgfrq, usefrq);
    
    actSolution = sic_automix.automix_mfg(1);
    expSolution = 0.4;
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testStrNumbers(testCase)

    ipc_concordance = {'i', 'Zuckerbrot', '3'};
    ipc_short = {'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j'; 'k'};
    frac_counts = [1/4; 1; 1; 1; 1; 1/5; 1; 99; -3; 1; 1]; 
    alg1_flatten = [1; 0; 0; 0; 1; 1; 0; 1; 1; 0; 0];
    ix_pick = [1, 2, 3];
    mfgfrq = [0.4; 0.1; 0.1];
    usefrq = [6258; 0.05; 0.1];
    
    sic_automix = match_sic2ipc(ipc_concordance, ipc_short, frac_counts, ...
        alg1_flatten, ix_pick, mfgfrq, usefrq);
    
    actSolution = sic_automix.automix_use(1);
    expSolution = -18774;
    
    verifyEqual(testCase, actSolution, expSolution)
end
