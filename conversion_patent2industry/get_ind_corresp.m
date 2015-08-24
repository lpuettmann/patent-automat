function ind_corresp = get_ind_corresp(naics_class_list, ind_code_table)

industry_list = unique(naics_class_list);

for ix_industry=1:length(industry_list)
    industry_nr = industry_list{ix_industry};
    list_pos = find(strcmp(ind_code_table(:,1), industry_nr));
    industry_name{ix_industry} = ind_code_table{list_pos, 2};
end

ind_corresp = [industry_list, industry_name'];
