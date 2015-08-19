function tests = test_get_ix_cellarray_str
    tests = functiontests(localfunctions);
end

function testNormalCase(testCase)

    file_str = {'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus this, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elemeFindMentum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};    
            
    find_str = 'FindMe';
    actSolution = get_ix_cellarray_str(file_str, find_str);

    expSolution = 4;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testSeveralPhraseOnOneLine(testCase)

    file_str = {'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus this, convallis dui et, vestibulum purus.'; 
            'SuspendissFindMee urna orci, elemeFindMentum vitae, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};    
            
    find_str = 'FindMe';
    actSolution = get_ix_cellarray_str(file_str, find_str);

    expSolution = 4;
    
    verifyEqual(testCase, actSolution, expSolution);
end


function testNoMatches(testCase)

    file_str = {'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus this, convallis dui et, vestibulum purus.'; 
            'Suspendissee urna orci, elementum vitae, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};    
            
    find_str = 'FindMe';
    ix_find = get_ix_cellarray_str(file_str, find_str);
    actSolution = length(ix_find);
    
    expSolution = 0;
    
    verifyEqual(testCase, actSolution, expSolution);
end