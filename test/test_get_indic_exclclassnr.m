function tests = test_get_indic_exclclassnr
    tests = functiontests(localfunctions);
end

function testNormal1(testCase)
    uspc_nr = {'123'};
    actSolution = get_indic_exclclassnr(uspc_nr);
    
    % We need to check if the proposed USPC technology number is actually
    % in the list of excluded numbers. We don't specify this exluded list
    % here or pass it in, but instead it is called from inside the
    % function. Therefore we need to make the following function call.
    uspc_nr_numeric = str2num(uspc_nr{1});
    expSolution = check_classnr_uspc( uspc_nr_numeric );
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormal2(testCase)
    uspc_nr = {'00'};
    actSolution = get_indic_exclclassnr(uspc_nr);
    
    uspc_nr_numeric = str2num(uspc_nr{1});
    expSolution = check_classnr_uspc( uspc_nr_numeric );
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormal3(testCase)
    uspc_nr = {'531'};
    actSolution = get_indic_exclclassnr(uspc_nr);
    
    uspc_nr_numeric = str2num(uspc_nr{1});
    expSolution = check_classnr_uspc( uspc_nr_numeric );
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormal4(testCase)
    uspc_nr = {'693'};
    actSolution = get_indic_exclclassnr(uspc_nr);
    
    uspc_nr_numeric = str2num(uspc_nr{1});
    expSolution = check_classnr_uspc( uspc_nr_numeric );
    
    verifyEqual(testCase, actSolution, expSolution)
end
