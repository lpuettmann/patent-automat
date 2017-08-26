function sic_automix = match_sic2ipc(ipc_concordance, ipc_short, ...
    frac_counts, automPat_flatten, ix_software_flatten, ...
            ix_robot_flatten, ix_pick, mfgfrq, usefrq)


%% Check inputs
assert( iscell( ipc_concordance ))
assert( iscell( ipc_short ))
assert( isnumeric( frac_counts ))
assert( isnumeric( mfgfrq ))
assert( isnumeric( usefrq ))

assert( length(frac_counts) == length(ipc_short) )
assert( length(ipc_concordance) == length(ix_pick) )
assert( length(automPat_flatten) == length(frac_counts) )

assert( length(mfgfrq) == length(usefrq) )


%% Match
for ix_ipc=1:length(ipc_concordance)
    pick_ipc = ipc_concordance{ix_ipc};

    % Find patents with the right IPCs
    % -------------------------------------------------------
    ix_ipc_match = strcmp(ipc_short, pick_ipc);

    % Number of patent IPCs that fit
    sic_automix.total_nr_matched(ix_ipc,1) = sum( ix_ipc_match );

    % Get fractional counts of those patents
    match_frac_counts = frac_counts(ix_ipc_match);

    % Get total fractional count of patents with the right IPC
    sic_automix.total_frac_counts(ix_ipc,1) = sum(match_frac_counts);

    % Automation
    % ~~~~~~~~~~~~~~~
    autompat_match = ix_ipc_match .* automPat_flatten;
    
    % Number of automation patents match from IPC to SIC
    sic_automix.autompat_nr_matched(ix_ipc,1) = sum( autompat_match ); 

    % Get fractional count of patents with the right IPC
    autompat_matched_frac_counts = frac_counts( find( autompat_match ) );

    % Get total count of fractional automation patents
    sic_automix.autompat_frac_counts(ix_ipc,1) = sum( ...
        autompat_matched_frac_counts );
    
    % Software
    % ~~~~~~~~~~~~~~~
    software_match = ix_ipc_match .* ix_software_flatten;
    
    % Number of automation patents match from IPC to SIC
    sic_automix.software_nr_matched(ix_ipc,1) = sum( software_match ); 

    % Get fractional count of patents with the right IPC
    software_matched_frac_counts = frac_counts( find( software_match ) );

    % Get total count of fractional automation patents
    sic_automix.software_frac_counts(ix_ipc,1) = sum( ...
        software_matched_frac_counts );
    
    % Robots
    % ~~~~~~~~~~~~~~~
    robot_match = ix_ipc_match .* ix_robot_flatten;
    
    % Number of automation patents match from IPC to SIC
    sic_automix.robot_nr_matched(ix_ipc,1) = sum( robot_match ); 

    % Get fractional count of patents with the right IPC
    robot_matched_frac_counts = frac_counts( find( robot_match ) );

    % Get total count of fractional automation patents
    sic_automix.robot_frac_counts(ix_ipc,1) = sum( ...
        robot_matched_frac_counts );
    

    % Extract empirical frequencies for this IPC
    % -------------------------------------------------------

    % All patents
    % ~~~~~~~~~~~~~~~
    
    % Industries of manufacture
    sic_automix.patents_mfg(ix_ipc,1) = mfgfrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.total_frac_counts( ix_ipc, 1 );

    % Sector of use
    sic_automix.patents_use(ix_ipc,1) = usefrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.total_frac_counts( ix_ipc, 1 );
    
    % Automation
    % ~~~~~~~~~~~~~~~
    
    % Industries of manufacture
    sic_automix.automix_mfg(ix_ipc,1) = mfgfrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.autompat_frac_counts( ix_ipc, 1 );

    % Sector of use
    sic_automix.automix_use(ix_ipc,1) = usefrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.autompat_frac_counts( ix_ipc, 1 ); 
    
    % Software
    % ~~~~~~~~~~~~~~~

    % Industries of manufacture
    sic_automix.software_mfg(ix_ipc,1) = mfgfrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.software_frac_counts( ix_ipc, 1 );

    % Sector of use
    sic_automix.software_use(ix_ipc,1) = usefrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.software_frac_counts( ix_ipc, 1 ); 
    
    % Robots
    % ~~~~~~~~~~~~~~~
    
    % Industries of manufacture
    sic_automix.robot_mfg(ix_ipc,1) = mfgfrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.robot_frac_counts( ix_ipc, 1 );

    % Sector of use
    sic_automix.robot_use(ix_ipc,1) = usefrq( ix_pick( ix_ipc ) ) * ...
        sic_automix.robot_frac_counts( ix_ipc, 1 ); 
end


%% Check output
assert( isstruct(sic_automix) )
