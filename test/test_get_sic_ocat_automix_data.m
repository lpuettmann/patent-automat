function tests = test_get_sic_ocat_automix_data
    tests = functiontests(localfunctions);
end

function testNormal1(testCase)
    
    % Create dataset and run it through the function
    year_start = 1;
    year_end = 2;
    art_dataset = [];
    art_dataset.sic = repmat( (1:10)', 2, 1);
    art_dataset.year = [ones(10, 1); repmat(2, 10, 1)];
    list = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'}';
    art_dataset.overcat = repmat(list, 2, 1);
    art_dataset.automix_use = (1:20)' ./ 10;
    art_dataset.patents_use = [1, 2, 3, 5, 4, 6, 9, 10, 13, 11, 0, 3, ... 
        4, 2, 6, 4, 7, 8, 11, 8]';
    art_dataset = struct2table(art_dataset);
    art_overcategories.letter = {'B', 'F', 'G', 'H', 'I'};
    [art_automix, art_automix_share] = get_sic_ocat_automix_data(...
        year_start, year_end, art_dataset, art_overcategories);

    % Check automation patents in industry 'B' in year '1'
    actSolution = 0.2;
    expSolution = art_automix(1, 1); 
    
    verifyEqual(testCase, actSolution, expSolution)
end

function testNormal2(testCase)
    
    % Create dataset and run it through the function
    year_start = 1;
    year_end = 2;
    art_dataset = [];
    art_dataset.sic = repmat( (1:10)', 2, 1);
    art_dataset.year = [ones(10, 1); repmat(2, 10, 1)];
    list = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'}';
    art_dataset.overcat = repmat(list, 2, 1);
    art_dataset.automix_use = (1:20)' ./ 10;
    art_dataset.patents_use = [1, 2, 3, 5, 4, 6, 9, 10, 13, 11, 0, 3, ... 
        4, 2, 6, 4, 7, 8, 11, 8]';
    art_dataset = struct2table(art_dataset);
    art_overcategories.letter = {'B', 'F', 'G', 'H', 'I'};
    [art_automix, art_automix_share] = get_sic_ocat_automix_data(...
        year_start, year_end, art_dataset, art_overcategories);

    % Check share of automation patents in industry 'F' in year '2'
    actSolution = 0.4;
    expSolution = art_automix_share(2, 2); 
    
    verifyEqual(testCase, actSolution, expSolution)
end
