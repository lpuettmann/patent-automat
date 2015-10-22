function out_cellarray_short = shorten_cellarray(in_cellarray, nr_char)

%% Check input format
% ----------------------------------------------------------------------
% Check that input variable is a cell array.
assert( iscell( in_cellarray ), 'Must be cell array.' )

assert( min( size( in_cellarray ) ) == 1, ...
    'Can only take one-dimensional cell arrays.')

assert( all( cellfun(@(x) isstr(x), in_cellarray) ), ...
    'Can only take cell array of strings.')

assert( nr_char >= 0)


%% Shorten
% ----------------------------------------------------------------------
for i=1:length(in_cellarray)
    
    extr_str = in_cellarray{i};
    
    if numel(extr_str) >=nr_char
        short_str = extr_str(1:nr_char);
    else
        short_str = extr_str(1:end);
    end
    
    out_cellarray_short{i, 1} = short_str;
end    


% While the output is a cell array, the individual elements should not be
% cells themselves.
assert( not( any( cellfun(@(x) iscell(x), out_cellarray_short) ) ) )
