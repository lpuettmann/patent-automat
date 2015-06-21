function tests = test_delete_empty_cells
    tests = functiontests(localfunctions);
end

function testNoEmptyCellStrings(testCase)

    cellarray_in = {'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus porttitor, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};    
    
    actSolution = delete_empty_cells(cellarray_in);
    expSolution = cellarray_in;
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testStandardEmptyCellStrings(testCase)

    cellarray_in = {'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            ''; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            ''; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};    
    
    actSolution = delete_empty_cells(cellarray_in);
    expSolution = {'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};  
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testStandardEmptyCellMixed(testCase)

    cellarray_in = {'123'; 
            '6123';
            ''; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            '';
            ''; 
            '16548463513516384684684..----86841'};    
    
    actSolution = delete_empty_cells(cellarray_in);
    expSolution = {'123'; 
            '6123';
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            '16548463513516384684684..----86841'};  
    
    verifyEqual(testCase, actSolution, expSolution)
end


function testTransposed(testCase)

    cellarray_in = {'123', '6123', '', ...
        'Suspendisse urna orci, elementum vitae justo quis, eleifend', ...
        '', '', '16548463513516384684684..----86841'};    
    
    actSolution = delete_empty_cells(cellarray_in);
    expSolution = {'123', '6123', ...
        'Suspendisse urna orci, elementum vitae justo quis, eleifend', ...
         '16548463513516384684684..----86841'};
    
    verifyEqual(testCase, actSolution, expSolution)
end







