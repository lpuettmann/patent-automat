function tests = test_extract_patent_number
    tests = functiontests(localfunctions);
end

function testPart1Standard(testCase)

    ftset.indic_filetype = 1;
    
    search_corpus = {'Lorem ipsum dolor sit amet, justo adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'PATN';
            'WKU  RE0286770'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'PATN';
            'WKU  039324109';
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};   
    
    nr_patents = 2;
    ix_pnr = [5;
              22];
        
    patent_number = extract_patent_number(nr_patents, search_corpus, ...
        ix_pnr, ftset);
    
    actSolution = patent_number;
    expSolution = {'RE0286770'; '039324109'};
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testPart1SkipEmptyLine(testCase)

    ftset.indic_filetype = 1;
    
    search_corpus = {'Lorem ipsum dolor sit amet, justo adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'PATN';
            '';
            'WKU  RE0286770'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'PATN';
            'WKU  039324109';
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};   
    
    nr_patents = 2;
    ix_pnr = [5;
              23];
        
    patent_number = extract_patent_number(nr_patents, search_corpus, ...
        ix_pnr, ftset);
    
    actSolution = patent_number;
    expSolution = {'RE0286770'; '039324109'};
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testPart1NoPats(testCase)

    ftset.indic_filetype = 1;
    
    search_corpus = {'Lorem ipsum dolor sit amet, justo adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};   
    
    nr_patents = 0;
    ix_pnr = [];
        
    patent_number = extract_patent_number(nr_patents, search_corpus, ...
        ix_pnr, ftset);
    
    actSolution = isempty(patent_number);
    expSolution = true;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testPart2Standard2pats(testCase)

    ftset.indic_filetype = 2;
    
    search_corpus = {'Lorem ipsum dolor sit amet, justo adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            '<B110><DNUM><PDAT>06359582</PDAT></DNUM></B110>'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            '<B110><DNUM><PDAT>06359883</PDAT></DNUM></B110>';
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};   
    
    nr_patents = 2;
    ix_pnr = [4;
              20];
        
    patent_number = extract_patent_number(nr_patents, search_corpus, ...
        ix_pnr, ftset);
    
    actSolution = patent_number;
    expSolution = {'06359582'; '06359883'};
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testPart2NoPats(testCase)

    ftset.indic_filetype = 2;
    
    search_corpus = {'Lorem ipsum dolor sit amet, justo adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};   
    
    nr_patents = 0;
    ix_pnr = [];
        
    patent_number = extract_patent_number(nr_patents, search_corpus, ...
        ix_pnr, ftset);
    
    actSolution = isempty(patent_number);
    expSolution = true;
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testPart3Standard(testCase)

    ftset.indic_filetype = 3;
    
    search_corpus = {'Lorem ipsum dolor sit amet, justo adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            '<us-patent-grant lang="EN" dtd-version="v4.2 2006-08-23" file="USD0652607-20120124.XML" status="PRODUCTION" id="us-patent-grant" country="US" date-produced="20120109" date-publ="20120124">';
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.';
            '<us-patent-grant lang="EN" dtd-version="v4.2 2006-08-23" file="US08101350-20120124.XML" status="PRODUCTION" id="us-patent-grant" country="US" date-produced="20120109" date-publ="20120124">'};   
    
    nr_patents = 2;
    ix_pnr = [4;
              26];
        
    patent_number = extract_patent_number(nr_patents, search_corpus, ...
        ix_pnr, ftset);
    
    actSolution = patent_number;
    expSolution = {'D0652607'; '08101350'};
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testPart3EmptyNoPat(testCase)

    ftset.indic_filetype = 3;
    
    search_corpus = {'Lorem ipsum dolor sit amet, justo adipiscing elit.'; 
            'Quisque ac nulla diam. Ut maximus rhoncus aliquet.';
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'tincidunt ante. Nunc sagittis mauris ut tempus pellentesque.'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Donec in risus ulla diam, convallis dui et, vestibulum purus.'; 
            'Suspendisse urna orci, elementum vitae justo quis, eleifend'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'Suspendisse ligula risus, ornare quis efficitur sit amet,'; 
            'dictum a libero. Pellentesque condimentum orci et massa'; 
            'tempor, in lacinia velit viverra. Phasellus iaculis mauris'; 
            'nulla, sit amet egestas dolor tempor nec.'};

    nr_patents = 0;
    ix_pnr = [];
        
    patent_number = extract_patent_number(nr_patents, search_corpus, ...
        ix_pnr, ftset);
    
    actSolution = isempty(patent_number);
    expSolution = true;
    
    verifyEqual(testCase, actSolution, expSolution)
end