function outCellArray = strtrim_punctuation(inCellArray)
% Trim leading and trailing punctuation from strings in a cell array.
% Punctuation includes '.', ',', '-', '*' and potentially others.

% Check inputs
assert( iscell(inCellArray), 'Accepts only cell arrays.')

indicCellContainsPunct = isstrprop(inCellArray, 'punct');
changePattern = cellfun(@diff, indicCellContainsPunct, 'UniformOutput', ...
    false);

for j=1:length(inCellArray)

    changeIndic = changePattern{j};

    findStartPunct = find(changeIndic == -1);
    if isempty( findStartPunct ) | (indicCellContainsPunct{j}(1) == 0)
        findStartPunct = 0;
    else
        findStartPunct = findStartPunct(1);
    end

    findEndPunct = find(changeIndic == 1);
    if isempty( findEndPunct ) | (indicCellContainsPunct{j}(end) == 0)
        findEndPunct = length( indicCellContainsPunct{j} );
    else
        findEndPunct = findEndPunct(end);
    end

    extrStr = inCellArray{j};
    extrStr = extrStr(findStartPunct + 1 : findEndPunct);
    
    outCellArray{j, 1} = extrStr;
end

% Check outputs
assert( iscell(outCellArray), 'Output should be cell array.')
assert( length(inCellArray) == length(outCellArray), 'Should be equal.')
