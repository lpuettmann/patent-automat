function construct_sic_automix(year_start, year_end, ipcsicfinalv5)


sic_silverman = cell2mat( cellfun(@str2num, ipcsicfinalv5.sic, ...
    'UniformOutput', false) );
sic_silverman = unique(sic_silverman);

exclude_techclass = choose_exclude_techclass();

% Get list of IPCs of automation patents for year
disp('Link patents to sectors of use:')
for t=1:length(year_start:year_end)
    
    ix_year = year_start + t - 1;
    
    fprintf('Year: %d\n', ix_year)
     
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)

    % Indicators for patents showing if they are classified as automation
    % patents.
    automPat = patsearch_results.is_nbAutomat;

    % List with IPC technology classification numbers
    ipc_list = patsearch_results.classnr_ipc;
    [frac_counts, automPat_flatten] = make_frac_count(ipc_list, automPat);
    
    ipc_flat = flatten_cellarray(ipc_list);    
    
    assert( length(frac_counts) == length(ipc_flat) )
    
    % Only keep first 4 characters of IPC number
    ipc_short = shorten_cellarray(ipc_flat, 4);

    for ix_sic=1:length(sic_silverman)

        sic_pick = num2str( sic_silverman(ix_sic) );    
        ix_pick = find( strcmp(ipcsicfinalv5.sic, sic_pick) );
        ipc_concordance = ipcsicfinalv5.ipc(ix_pick);
        
        mfgfrq = ipcsicfinalv5.mfgfrq;
        usefrq = ipcsicfinalv5.usefrq;
        
        sic_automix = match_sic2ipc(ipc_concordance, ipc_short, ...
            frac_counts, automPat_flatten, ix_pick, mfgfrq, usefrq);
               
        
        % Get summary for all IPCs mapping into SICs
        sic_automix_yres.sic(ix_sic, 1) = str2num( sic_pick );
        
        sic_automix_yres.nr_pat(ix_sic, 1) = ...
            sum( sic_automix.total_nr_matched );
        
        sic_automix_yres.nr_fracpat(ix_sic, 1) = ...
            sum( sic_automix.total_frac_counts );
        
        sic_automix_yres.nr_autompat(ix_sic, 1) = ...
            sum( sic_automix.autompat_nr_matched );
        
        sic_automix_yres.nr_fracautompat(ix_sic, 1) = ...
            sum( sic_automix.autompat_frac_counts );  
        
        sic_automix_yres.patents_mfg(ix_sic, 1) = ...
            sum( sic_automix.patents_mfg );  
        
        sic_automix_yres.patents_use(ix_sic, 1) = ...
            sum( sic_automix.patents_use );  
        
        sic_automix_yres.automix_mfgt(ix_sic, 1) = ...
            sum( sic_automix.automix_mfg );  
        
        sic_automix_yres.automix_use(ix_sic, 1) = ...
            sum( sic_automix.automix_use );  

        % Print a progress message for every 100th industry and the last
        % one.
        if (mod(ix_sic, 50) == 0) | (ix_sic == length(sic_silverman))
            fprintf('[%d] Finished SIC: %d/%d.\n', ix_year, ix_sic, ...
                length(sic_silverman))
        end
        
        clear sic_automix
    end
    
    sic_automix_yres = struct2table(sic_automix_yres);

    savename = horzcat('sic_automix/sic_automix_yres_', ...
        num2str(ix_year), '.mat');
%     save(savename, 'sic_automix_yres'); 
%     fprintf('Saved: %s.\n', savename)
    fprintf('Finished (not saved): %s.\n', savename)
    
    clear sic_automix_yres
end
