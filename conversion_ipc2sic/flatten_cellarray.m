function out_cellarray_flat = flatten_cellarray(in_cellarray)
% Flatten out a nested cell array.

%% Check input format
% ----------------------------------------------------------------------
% Check that input variable is a cell array.
assert( iscell( in_cellarray ), 'Must be cell array.' )

assert( min( size( in_cellarray ) ) == 1, ...
    'Can only take one-dimensional cell arrays.')

for i=1:length(in_cellarray)
    assert( iscell(in_cellarray{i}), 'Can only take cell array of cells.')
end


%% Flatten
% ----------------------------------------------------------------------
out_cellarray_flat = vertcat( in_cellarray{:} );


%% Check output format
% ----------------------------------------------------------------------
% The flattened cell array must be at least as long the nested cell array.
assert( length(out_cellarray_flat) >= length(in_cellarray) )

% Check that flattened cell array has the right length.
for i=1:length(in_cellarray)
    count_element_depth(i,1) = length(in_cellarray{i});
end    
    
assert( sum(count_element_depth) == length(out_cellarray_flat) )
