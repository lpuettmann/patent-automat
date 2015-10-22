function [frac_counts, alg1_flatten] = make_frac_count(ipc_list, alg1)

ix_save = 1;
for i=1:length(ipc_short)
    % Count number of IPCs per patent
    nr_ipc = length( ipc_short{i} );

    for j=1:nr_ipc
        % Get fractional counts
        frac_counts(ix_save,1) = 1 / nr_ipc ;

        % Save for every entry if it belongs to an automation patent
        alg1_flatten(ix_save,1) = alg1(i);
        ix_save = ix_save + 1;
    end
end

assert( length(frac_counts) == length(ipc_flat) )
assert( length(frac_counts) == length(alg1_flatten)  )
