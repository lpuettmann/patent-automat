function check_cleanedmatches_plausability(year_start, year_end)

% Set path to the cleaned matches (which we want to check)
build_data_path = [pwd, '/cleaned_matches'];


% Get names of files
% -------------------------------------------------------------------
liststruct = dir(build_data_path);
filenames = {liststruct.name};
filenames = filenames(3:end)'; % truncate first elements . and ..
filenames = ifmac_truncate_more(filenames);


indic_gitignore = strcmp(filenames, '.gitignore');

if any( indic_gitignore )
    filenames(indic_gitignore) = [];
end

% Check that no files starts with a dot '.' (or '..' or '.DS_Store' or 
% '.gitignore'
check_filestart_dot(filenames)

% Check that all formats are .mat
fileend = cellfun(@(x) x(end-3:end), filenames, 'UniformOutput', false);

if any ( not ( strcmp(fileend, '.mat') ) )
    warning('Files should all be ''.mat'' format.')
end

for ix_year=year_start:year_end

    % Define year settings
    if ix_year == 1976;
        % Example patent numbers that should show up in our matches
        yset.pnumber = {'3980627', '3980901', '3981025', '3963412', ...
            '3931155', '3931341'};
        % These should NOT show up in our patent numbers
        yset.pnumberNotShow = {'ABCD', '-15', '3981025', '3963412', ...
            'RE0288551', '4002274', '4002698', '4003093'};
        yset.PatentNumber_matchesCheck = {'3931155', '3931341'};
        yset.title_matchesCheck = ...
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        yset.abstract_matchesCheck = ...
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        yset.body_matchesCheck = ...
            [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    elseif ix_year == 1977;
        yset.pnumber = {'4002274', '4002698', '4003093', '4002754', ...
            '4042420', '4042593', '4042642', '4042696', '4002358', '4002405'};
        yset.pnumberNotShow = {'ABCD', '-15', 'D02429616', '3980627', ...
            '3980901'};
        yset.PatentNumber_matchesCheck = {'4002358', '4002405'};
        yset.title_matchesCheck = ...
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        yset.abstract_matchesCheck = ...
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        yset.body_matchesCheck = ...
            [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 53, 0, 1, 0, 0, 0, 0, 19, 7, 0, 0, 0];

    else
        yset.pnumber = {};
        yset.pnumberNotShow = {};
        yset.PatentNumber_matchesCheck = {};
    end


    filepart1 = 'patsearch_results_';
    filepart3 = '.mat';
    yearfname = [filepart1, num2str(ix_year), filepart3];


    if any( strcmp(filenames, yearfname) ) % check if file exists
        load(yearfname)

        % Check that dimensions are right with respect to number of patents
        check_rightheight = [size( patsearch_results.patentnr, 1);
                            size( patsearch_results.classnr, 1);
                            size( patsearch_results.week, 1);    
                            size( patsearch_results.title_matches, 1);    
                            size( patsearch_results.abstract_matches, 1);    
                            size( patsearch_results.body_matches, 1);    
                            size( patsearch_results.length_pattext, 1)];    

        if any( check_rightheight ~= check_rightheight(1) )
            warning('The "height" of data (number patents) in %s are not equal.', ...
                yearfname)
        end

        % Check that dictionary and the title, abstract and body matches all
        % have the right dimension
        check_rightwidth = [length( patsearch_results.dictionary );
                            size( patsearch_results.title_matches, 2);    
                            size( patsearch_results.abstract_matches, 2);    
                            size( patsearch_results.body_matches, 2)];    

        if any( check_rightwidth ~= check_rightwidth(1) )
            warning('The "width" of data (number words) in %s are not equal.', ...
                yearfname)
        end


        % Check that the weeks are numbers between 1 and 53
        weeks = cell2mat( patsearch_results.week );

        if any( not( ismember( weeks, 1:53 ) ) )
            warning('The weeks in %s should be numbers between 1 and 52 or 53.', ...
                yearfname)
        end

        nr_patents = size(patsearch_results.patentnr, 1);

        for i=1:nr_patents
            extract_pnumber = patsearch_results.patentnr{i};
            extract_pnumber = char ( extract_pnumber );
            % Check if contains any alphabetic letters (it shouldn't)
            if any( isstrprop(extract_pnumber, 'alpha') )
                warning('There should be not letters in patent %s (%d).', ...
                    patsearch_results.patentnr{i}, ix_year)
            end        
        end


        % Check specified patents that should show up in patent numbers
        for i=1:length(yset.pnumber)
            pick_pnumber = yset.pnumber{i};
            if not( any( strcmp(patsearch_results.patentnr, pick_pnumber) ) )
                warning('Patent %s not found in %s.', pick_pnumber, yearfname)
            end
        end

        % Check specified patents that should NOT show up in patent numbers
        for i=1:length(yset.pnumber)
            pick_pnumber = yset.pnumber{i};
            if not( any( strcmp(patsearch_results.patentnr, pick_pnumber) ) )
                warning('Patent %s not found in %s.', pick_pnumber, yearfname)
            end
        end

        % Check specified matches
        for i=1:length(yset.PatentNumber_matchesCheck)
            pick_pnumber = yset.PatentNumber_matchesCheck{i};
            ix_pick = find( +strcmp( patsearch_results.patentnr, ...
                pick_pnumber) );    

           if isempty( ix_pick )
               warning('Patent number not found.')
           end

           if any( not ( patsearch_results.title_matches(ix_pick, :) == ...
                   yset.title_matchesCheck(i, :) ) )
               warning('Title matches in patent %s not correct.', pick_pnumber)
           end

           if any( not ( patsearch_results.abstract_matches(ix_pick, :) == ...
                   yset.abstract_matchesCheck(i, :) ) )
               warning('Abstract matches in patent %s not correct.', ...
                   pick_pnumber)
           end

           if any( not ( patsearch_results.body_matches(ix_pick, :) == ...
                   yset.body_matchesCheck(i, :) ) )
               warning('Matches in patent body in patent %s not correct.', ...
                   pick_pnumber)
           end       
        end
    end
    
    clear yset
    fprintf('Finished checking cleaned matches of year: %d.\n', ix_year)
end
