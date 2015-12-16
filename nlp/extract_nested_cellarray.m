function allCells = extract_nested_cellarray(inNestedCellArray)
% Extracted cells that nested one level below. 
%   IN:
%       - inNestedCellArray: [N x 1] cell array of cells of varying 
%        length M_i, i = 1, ..., N.
% 
%   OUT:
%       - allCells: All cells are concatend below each other. Size is:
%              sum_{i=1}^N M_i 
%

%% Check for correct input
assert( iscell( inNestedCellArray ), 'Must be cell array.' )

for i=1:length(inNestedCellArray)
    assert( iscell( inNestedCellArray{i} ), 'Cells must be cells.' )
end

assert( size(inNestedCellArray, 2) <= 1, 'Input must be column only.')
assert( size(inNestedCellArray, 1) >= 1, 'You probably don''t want to use this function.')


%% Concatenate
allCells = [];

for k=1:length(inNestedCellArray)
    allCells = [allCells;
               inNestedCellArray{k}];
end
