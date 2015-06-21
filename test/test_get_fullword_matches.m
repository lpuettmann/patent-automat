function tests = test_get_fullword_matches
    tests = functiontests(localfunctions);
end

function testReturnSurroundingWord(testCase)

    patent_text_corpus = {'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus helloKeywordhello, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};    
    
    nr_keyword_find = 1;
    check_keyword_find = {[]; []; [21]; []; []; []; []; []; []};
    line_hit_keyword_find = {21};
        
    actSolution = get_fullword_matches(nr_keyword_find, ...
    check_keyword_find, patent_text_corpus, line_hit_keyword_find);

    expSolution = {'helloKeywordhello,'};
    
    verifyEqual(testCase, actSolution, expSolution)
end
