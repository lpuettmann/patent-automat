function [frac_counts, alg1_flatten] = make_frac_count(in_cellarray, alg1)

%%
assert( all( cellfun(@(x) iscell(x), in_cellarray) ), ...
    'Can only take cell array of cells.')

assert( isnumeric(alg1) )

assert( length(alg1) == length(in_cellarray) )


%% Get fractional counts for all IPCs for all patents and the 
% corresponding information if patent is automation patent according to
% algorithm 1.

ix_save = 1; % initalize vector for saving

for i=1:length(in_cellarray)
    
    % Count number of IPCs per patent
    nr_ipc = length( in_cellarray{i} );

    for j=1:nr_ipc
        % Get fractional counts
        frac_counts(ix_save,1) = 1 / nr_ipc;

        % Save for every entry if it belongs to an automation patent
        alg1_flatten(ix_save,1) = alg1(i);
        ix_save = ix_save + 1;
    end
end

%% Check that format is right.
assert( length(frac_counts) == length(alg1_flatten)  )
assert( isnumeric(alg1_flatten) )