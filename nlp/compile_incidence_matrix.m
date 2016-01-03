function incidMat = compile_incidence_matrix(tokenList, docTokens)
% Check which tokens appear in which documents and return a matrix.

% TO DO:
% Transform loops into vectors. Make a long list with all the tokens in the
% documents (use the de-nesting function I just wrote) and also keep a vector with what token belongs to which
% document. And then just compare the long list of tokens with the one
% string (still have to do that many times). This would get rid of two of
% the loops, so we would only have to iterate once through the list of
% unique tokens.

%% Check function inputs
% -------------------------------------------------------------------
assert( not( isempty( docTokens ) ) )
assert( not( isempty( tokenList ) ) )

%% Compile incidence matrix
% -------------------------------------------------------------------
incidMat = zeros(length(docTokens), length(tokenList)); % initialize

for k=1:length(tokenList)
    compareStr = tokenList{k};

    for i=1:length(docTokens)
        single_docTokens = docTokens{i};
        
        occurences = zeros(length(single_docTokens), 1); % initialize
        
        % The plus ("+") converts logical to double
        occurences = +strcmp(compareStr, single_docTokens);

        incidMat(i, k) = sum( occurences );
        clear occurences
    end
    
    % Write a status message
    if (mod(k, 100) == 0) || (k == length(tokenList))
        fprintf('Finished token %d/%d.\n', k, length(tokenList))
    end
end

%% Check outputs
% -------------------------------------------------------------------
% Check that all columns contain at least one nonzero value (otherwise,
% these tokens should not be in the list of unique tokens anyway).
assert( not( any( sum(incidMat) == 0 ) ), ...
    'Incidence matrix should not have empty columns.')
assert( isnumeric(incidMat) )
assert( not( isempty( incidMat ) ) )

