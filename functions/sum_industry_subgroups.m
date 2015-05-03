function employment_pick = sum_industry_subgroups(year_start, year_end, ...
    subgroup_list, naics_otaf, industry_employment)

employment_pick = zeros(length(year_start:year_end), 1);

for ix_subgroups=1:length(subgroup_list)
    pos_industry_sub = find(naics_otaf==subgroup_list(ix_subgroups));
    employment_pick_sub = industry_employment(pos_industry_sub);   
    employment_pick = employment_pick + employment_pick_sub;
end
