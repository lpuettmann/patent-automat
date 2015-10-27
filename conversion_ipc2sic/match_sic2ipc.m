function sic_automix = match_sic2ipc(ipc_concordance, ipc_short, ...
    frac_counts, alg1_flatten, ix_pick, mfgfrq, usefrq)   


%% Check inputs
assert( iscell( ipc_concordance ))
assert( iscell( ipc_short ))
assert( isnumeric( frac_counts ))
assert( isnumeric( mfgfrq ))
assert( isnumeric( usefrq ))

assert( length(frac_counts) == length(ipc_short) )
assert( length(ipc_concordance) == length(ix_pick) )
assert( length(alg1_flatten) == length(frac_counts) )

assert( length(mfgfrq) == length(usefrq) )


%% Match
for ix_ipc=1:length(ipc_concordance)
    pick_ipc = ipc_concordance{ix_ipc};

    % Find patents with the right IPCs
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ix_ipc_match = strcmp(ipc_short, pick_ipc);

    % Number of patent IPCs that fit
    sic_automix.total_nr_matched(ix_ipc,1) = sum( ix_ipc_match );

    % Get fractional counts of those patents
    match_frac_counts = frac_counts(ix_ipc_match);

    % Get total fractional count of patents with the right IPC
    sic_automix.total_frac_counts(ix_ipc,1) = sum( ...
        match_frac_counts );

    % Only count automation patents
    autompat_match = ix_ipc_match .* alg1_flatten;

    % Number of automation patents match from IPC to SIC
    sic_automix.autompat_nr_matched(ix_ipc,1) = sum( autompat_match ); 

    % Get fractional count of patents with the right IPC
    autompat_matched_frac_counts = frac_counts( find( autompat_match ) );

    % Get total count of fractional automation patents
    sic_automix.autompat_frac_counts(ix_ipc,1) = sum( ...
        autompat_matched_frac_counts );

    % Extract empirical frequencies for this IPC
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Industries of manufacture (all patents)
    sic_automix.patents_mfg(ix_ipc,1) = mfgfrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.total_frac_counts( ix_ipc, 1 );

    % Sector of use (all patents)
    sic_automix.patents_use(ix_ipc,1) = usefrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.total_frac_counts( ix_ipc, 1 );
    
    
    % Industries of manufacture (automation patents)
    sic_automix.automix_mfg(ix_ipc,1) = mfgfrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.autompat_frac_counts( ix_ipc, 1 );

    % Sector of use (automation patents)
    sic_automix.automix_use(ix_ipc,1) = usefrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.autompat_frac_counts( ix_ipc, 1 ); 
end


%% Check output
assert( isstruct(sic_automix) )
