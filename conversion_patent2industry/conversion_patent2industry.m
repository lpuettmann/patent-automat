function pat2ind = conversion_patent2industry(fullyear_start, fullyear_end)


% -------------------------------------------------------------------------    
[num, txt] = xlsread('industry_names.xlsx'); % load industry names
ind_code_table = [txt num2cell(num)];
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
pat2ind.ind_corresp = ind_corresp;
pat2ind.linked_pat_ix = linked_pat_ix;
pat2ind.industry_sumstats = industry_sumstats;
pat2ind.nr_appear_allyear = nr_appear_allyear;
pat2ind.share_patents_linked = share_patents_linked;
