function sumstats = extract_sumstats(industry_sumstats, ix_industry)

for ix_period=1:size(industry_sumstats, 3)
    sumstats(ix_period, :) = industry_sumstats{ix_industry, 3, ix_period};
end