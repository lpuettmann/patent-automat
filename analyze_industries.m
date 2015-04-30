close all
clear all
clc



% Add path to industry level data
addpath('industry_data');


% Load excel file
[industry_data, txt, raw] = xlsread('industrial_dataset.xlsx')


industry_naics_pick = 311;

naics_otaf = industry_data(:,2):

naics_list = unique(naics_otaf):

industry_employment = industry_data(:, 8);

pos_industry = find(naics_otaf==industry_naics_pick);


employment_pick = industry_employment(pos_industry)