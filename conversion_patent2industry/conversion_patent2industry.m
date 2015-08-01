function pat2ind = conversion_patent2industry()

fname = 'Naics_co13.csv';
lnumber = 203074;
pick_k = 1;
fullyear_start = 1976;
fullyear_end = 2014;

% -------------------------------------------------------------------------
tic

disp('Start preparing conversion table:')
conversion_table = prepare_conversion_table(fname, lnumber);

disp('Finished preparing conversion table.')
fprintf('Finished, time = %dm.\n', round(toc/60))


% -------------------------------------------------------------------------    
[~, ind_code_table] = xlsread('industry_names.xlsx'); % load industry names

[industry_list, linked_pat_ix, industry_sumstats] = match_pat2industry( ...
    pick_k, fullyear_start, fullyear_end, ind_code_table, conversion_table);

disp('Finished matching patents with industries.')

 
% -------------------------------------------------------------------------
[nr_appear_allyear, share_patents_linked] = analyze_pat2indlink( ...
    fullyear_start, fullyear_end, industry_list, linked_pat_ix);

disp('Finished analyzing the patent-industry link.')


% Save results in a structure
pat2ind.conversion_table = conversion_table;
pat2ind.ind_code_table = ind_code_table;
pat2ind.industry_list = industry_list;
pat2ind.linked_pat_ix = linked_pat_ix;
pat2ind.industry_sumstats = industry_sumstats;
pat2ind.nr_appear_allyear = nr_appear_allyear;
pat2ind.share_patents_linked = share_patents_linked;
