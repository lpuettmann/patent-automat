function pat2ind = conversion_patent2industry(fullyear_start, fullyear_end)

fname = 'Naics_co13.csv';
lnumber = 203074; % unfortunately hard-code line number


% -------------------------------------------------------------------------
tic

disp('Start preparing conversion table:')
conversion_table = prepare_conversion_table(fname, lnumber);

fprintf('Finished preparing conversion table, time = %d minutes.\n', ...
    round(toc/60))


% -------------------------------------------------------------------------    
[~, ind_code_table] = xlsread('industry_names.xlsx'); % load industry names

ind_corresp = get_ind_corresp(conversion_table.naics_class_list, ...
    ind_code_table);


% -------------------------------------------------------------------------   
linked_pat_ix = match_pat2industry(fullyear_start, ...
    fullyear_end, conversion_table, ind_corresp);

disp('Finished matching patents with industries.')


% -------------------------------------------------------------------------
industry_sumstats = get_industry_sumstats(fullyear_start, fullyear_end, ...
    linked_pat_ix);

disp('Finished calculating summary statistics for industries.')
 

% -------------------------------------------------------------------------
[nr_appear_allyear, share_patents_linked] = analyze_pat2indlink( ...
    fullyear_start, fullyear_end, linked_pat_ix);

disp('Finished analyzing the patent-industry link.')


% Save results in a structure
pat2ind.conversion_table = conversion_table;
pat2ind.ind_corresp = ind_corresp;
pat2ind.linked_pat_ix = linked_pat_ix;
pat2ind.industry_sumstats = industry_sumstats;
pat2ind.nr_appear_allyear = nr_appear_allyear;
pat2ind.share_patents_linked = share_patents_linked;
