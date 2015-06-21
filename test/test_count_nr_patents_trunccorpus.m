function tests = test_count_nr_patents_trunccorpus
    tests = functiontests(localfunctions);
end

function test_1(testCase)

    search_corpus = {'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus porttitor, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'}; 
        
    find_str = 'nulla';
    
    nr_trunc = 5;
    
    [actSolution, ~, ~] = ...
    count_nr_patents_trunccorpus(search_corpus, find_str, nr_trunc);
   
    expSolution = [0; 0; 0; 0; 0; 0; 0; 0; 1];    
    
    verifyEqual(testCase, actSolution, expSolution)
end

% [indic_find, nr_patents, ix_find]

function test_2(testCase)

    search_corpus = {'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'; 
            'PATN ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus porttitor, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'PATN ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'PATN, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'}; 
        
    find_str = 'PATN';
    
    nr_trunc = 4;
    
    [~, actSolution, ~] = ...
    count_nr_patents_trunccorpus(search_corpus, find_str, nr_trunc);
    
    expSolution = 3;    
    
    verifyEqual(testCase, actSolution, expSolution)
end

function test_3(testCase)

    search_corpus = {'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus porttitor, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'PATN a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'}; 
        
    find_str = 'PATN';
    
    nr_trunc = 4;
    
    [~, ~, actSolution] = ...
    count_nr_patents_trunccorpus(search_corpus, find_str, nr_trunc);
    
    expSolution = 7;    
    
    verifyEqual(testCase, actSolution, expSolution)
end
