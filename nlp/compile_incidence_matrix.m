function incidMat = compile_incidence_matrix(tokenList, docTokens, ...
    indicVerbosity)
% Check which tokens appear in which documents and return a matrix.
% 
%   IN:
%       - indicVerbosity: if equal to "silent" to not print progress
%       message and if equal "verbose" then print progress message. If only
%       two arguemnts are specified then it defaults to "silent".

%% Check function inputs
% -------------------------------------------------------------------
assert( not( isempty( docTokens ) ) )
assert( not( isempty( tokenList ) ) )

if nargin == 3
    assert( isstr( indicVerbosity ) );
    assert( strcmp(indicVerbosity, 'verbose') | strcmp(indicVerbosity, ...
        'silent') )
elseif nargin == 2
    indicVerbosity = 'silent';
else
    error('Implausible number of function arguments.')
end


%% Compile incidence matrix
% -------------------------------------------------------------------
incidMat = sparse( zeros(length(docTokens), length(tokenList)) ); % initialize

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
    
    if strcmp(indicVerbosity, 'verbose')
        % Write a status message
        if (mod(k, 100) == 0) || (k == length(tokenList))
            fprintf('Finished token %d/%d.\n', k, length(tokenList))
        end
    end
end

%% Check outputs
% -------------------------------------------------------------------
% Check that all columns contain at least one nonzero value (otherwise,
% these tokens should not be in the list of unique tokens anyway).
assert( not( any( sum(incidMat) == 0 ) ), ...
    'Incidence matrix should not have empty columns.')
assert( isnumeric(incidMat) )
assert( nnz(incidMat) > 0 )
