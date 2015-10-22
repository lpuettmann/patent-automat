function sic_automix = match_sic2ipc()   

for ix_ipc=1:length(ipc_concordance)
    pick_ipc = ipc_concordance{ix_ipc};

    % Find patents with the right IPCs
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ix_ipc_match = strcmp(ipc_flat, pick_ipc);

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

    % Industries of manufacture
    sic_automix.automix_mfg(ix_ipc,1) = ipcsicfinalv5.mfgfrq( ...
        ix_pick( ix_ipc ) ) * sic_automix.autompat_frac_counts( ...
        ix_ipc,1);

    % Sector of use
    sic_automix.automix_use(ix_ipc,1) = ipcsicfinalv5.usefrq( ...
        ix_pick( ix_ipc ) ) * sic_automix.autompat_frac_counts( ...
        ix_ipc,1); 
end
