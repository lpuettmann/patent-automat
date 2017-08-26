function [frac_counts, automPat_flatten, ix_software_flatten, ...
    ix_robot_flatten] = make_frac_count(in_cellarray, automPat, ix_software, ix_robot)


%% Check input format
assert( all( cellfun(@(x) iscell(x), in_cellarray) ), ...
    'Can only take cell array of cells.')

assert( isnumeric(automPat) )

assert( length(automPat) == length(in_cellarray) )


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
        automPat_flatten(ix_save,1) = automPat(i);
        
        % Software, robots
        ix_software_flatten(ix_save,1) = ix_software(i);
        ix_robot_flatten(ix_save,1) = ix_robot(i);
        
        ix_save = ix_save + 1;
    end
end

%% Check output format.
assert( length(frac_counts) == length(automPat_flatten)  )
assert( isnumeric(automPat_flatten) )
