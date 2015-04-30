close all
clear all
clc


addpath('../functions')

%% Load summary data
load('../conversion_patent2industry/industry_sumstats.mat')


% Load excel file
[industry_data, txt, raw] = xlsread('industrial_dataset.xlsx');


% Get industry data
naics_otaf = industry_data(:,2);
naics_list = unique(naics_otaf);
industry_employment = industry_data(:, 8);



% Iterate through manufacturing industries
for ix_industry=1:size(industry_sumstats, 1)

    industry_nr = str2num(industry_sumstats{ix_industry, 1, 1});
    industry_name = industry_sumstats{ix_industry, 2, 1};

    sumstats = extract_sumstats(industry_sumstats, ix_industry);

    industry_nr_pat = sumstats(:, 1);
    industry_nr_matches = sumstats(:, 2);
    industry_pat_1match = sumstats(:, 3);

    industry_avg_matches = industry_nr_matches ./ industry_nr_pat;

    
    % Extract labor market data for specific industry
    pos_industry = find(naics_otaf==industry_nr);
    employment_pick = industry_employment(pos_industry);

    
end