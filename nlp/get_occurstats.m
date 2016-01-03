function occurstats = get_occurstats(incidMat, uniqueT, manAutomat)
    

    aPat = find( manAutomat ); % index of automation patents
    nPat = find( not( manAutomat ) ); % index of non-automation patents

    assert( length(aPat) + length(nPat) == length(manAutomat) )

    % All patents
    [occurstats.all_sortedT, occurstats.all_sortedOccur] = countDocTok(...
        incidMat, uniqueT);

    % Automation patents
    [occurstats.aPat_sortedT, occurstats.aPat_sortedOccur] = countDocTok(...
        incidMat(aPat, :), uniqueT);

    % Non-automation patents
    [occurstats.nPat_sortedT, occurstats.nPat_sortedOccur] = countDocTok(...
        incidMat(nPat, :), uniqueT);

    occurstats = struct2table(occurstats);
end


function [sortedT, sortedOccur] = countDocTok(incidMat, uniqueT)
    % Take incidence matrix and list of tokens and return a sorted list of
    % the tokens and their respective number of documents that contain that 
    % token.

    % Don't count frequencies, but just the occurences
    occurMat = +( incidMat > 0 );

    % Number of documents that contain a particular term at least once
    tfreq = sum(occurMat)';

    [sortedOccur, ixSort] = sort(tfreq, 'descend');

    % Get the list of tokens in their order of number of occurences
    sortedT = uniqueT(ixSort);
end
