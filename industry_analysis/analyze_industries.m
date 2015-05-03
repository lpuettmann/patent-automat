close all
clear all
clc

addpath('../functions')

year_start = 1976;
year_end = 2014;


%% Load data
% Load summary data
load('../conversion_patent2industry/industry_sumstats.mat')


% Load excel file
[industry_data, txt, ~] = xlsread('industrial_dataset.xlsx');

var_list = txt(4,:);
pick_var = 3;
fprintf('Chosen labor market variable: %s.\n', var_list{pick_var})

% Get industry data
naics_otaf = industry_data(:, 2);
naics_list = unique(naics_otaf);
industry_laborm = industry_data(:, pick_var);


% industry_nr_list = industry_sumstats(:, 1, 1)
% industry_name_list = industry_sumstats(:, 2, 1)

% Plot settings
dim_subplot = [7, 4];
color1_pick = [49, 130, 189] ./ 255;
my_light_gray = [0.5, 0.5, 0.5];
my_dark_gray = [0.3, 0.3, 0.3];

set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

plottime = year_start:year_end;
xax_limit = [year_start, year_end];
yax_limit = [0, 2];

figureHandle = figure;
set(gcf, 'Color', 'w');


%% Iterate through manufacturing industries
for ix_industry=1:size(industry_sumstats, 1)
    
    % Extract patent match data for industry
    industry_name = industry_sumstats{ix_industry, 2, 1};
    sumstats = extract_sumstats(industry_sumstats, ix_industry);
    industry_nr_pat = sumstats(:, 1);
    industry_nr_matches = sumstats(:, 2);
    industry_pat_1match = sumstats(:, 3);
    industry_avg_matches = industry_nr_matches ./ industry_nr_pat;
    % Share of patents classified as automation patents (> 1 keyword match)
    industry_pat1match_share = industry_pat_1match ./ industry_nr_pat;
    
    % Pick a metric of the patent matches to compare to labor market
    % outcomes
    patent_metric_pick = industry_pat1match_share;
        
    % Extract labor market data for industry
    industry_nr = industry_sumstats{ix_industry, 1, 1};
     
    % Check if industry number is pure numeric or mixed with plus or minus
    if str2num(industry_nr) > 0 % All good, continue.
        industry_nr = str2num(industry_nr);
        pos_industry = find(naics_otaf==industry_nr);
        laborm_pick = industry_laborm(pos_industry);
        
    elseif strcmp('313+', industry_nr)
        subgroup_list = [313:316];
        laborm_pick = sum_industry_subgroups(year_start, year_end, ...
            subgroup_list, naics_otaf, industry_laborm);
        
    elseif strcmp('322+', industry_nr)
        subgroup_list = [322, 323];
        laborm_pick = sum_industry_subgroups(year_start, year_end, ...
            subgroup_list, naics_otaf, industry_laborm);   
        
    elseif strcmp('325-', industry_nr)
        subgroup_list = [3253, 3255, 3256, 3259];
        laborm_pick = sum_industry_subgroups(year_start, year_end, ...
            subgroup_list, naics_otaf, industry_laborm); 
        
    elseif strcmp('334-', industry_nr)
        subgroup_list = [3343, 3346];
        laborm_pick = sum_industry_subgroups(year_start, year_end, ...
            subgroup_list, naics_otaf, industry_laborm); 
        
    elseif strcmp('336-', industry_nr) % MISSING: 3366 (apparently together with 3365)
        subgroup_list = [3365, 3369];
        laborm_pick = sum_industry_subgroups(year_start, year_end, ...
            subgroup_list, naics_otaf, industry_laborm); 
        
    elseif strcmp('3361+', industry_nr)
        subgroup_list = [3361:3363];
        laborm_pick = sum_industry_subgroups(year_start, year_end, ...
            subgroup_list, naics_otaf, industry_laborm); 
        
    elseif strcmp('339-', industry_nr) % 339- = 339 (except 3391)
        subgroup_list = [339];
        laborm_pick = sum_industry_subgroups(year_start, year_end, ...
            subgroup_list, naics_otaf, industry_laborm); 
        
    else
        warning('Problem: undefined industry class.')
        
    end
    
    
    % Save changes in series for scatterplot
    notnanval = find(not(isnan(laborm_pick)));
    first_val = notnanval(1);
    last_val = notnanval(end);
    labormarket_change(ix_industry) = laborm_pick(last_val) / laborm_pick(first_val);
    patent_metric_change(ix_industry) = patent_metric_pick(last_val) / patent_metric_pick(first_val);
    
    % Normalize for plot
    pick_normalization_date = 2000;
    pick_normalization_index = pick_normalization_date-year_start+1;
    
    laborm_pick = laborm_pick / laborm_pick(pick_normalization_index);
    patent_metric_pick = patent_metric_pick / patent_metric_pick(pick_normalization_index);
    
    % Make a time series plot with both series
    subplot(7, 4, ix_industry)
    plot(plottime, laborm_pick, plottime, patent_metric_pick)
    hold on
    xlim(xax_limit)
    ylim(yax_limit)
    
    hx = graph2d.constantline(pick_normalization_date, 'LineStyle',':', ...
        'Color', my_dark_gray);
    changedependvar(hx,'x');

    % Calculate correlation where we have data
    correlation_plotseries = corrcoef(laborm_pick, ...
        patent_metric_pick, 'rows','complete');

    titlestring = sprintf('%s (%3.2f)', industry_name, correlation_plotseries(1,2));
    title(titlestring)
    box off
    set(gca,'TickDir','out') 
    leave_xaxis_bottomonly(ix_industry, dim_subplot, ...
        size(industry_sumstats, 1), 'labels')
    
end

legend('Labor market statistic', 'Automation statistic', 'Location', 'NorthEastOutside')


% Change position and size
set(gcf, 'Position', [100 100 1500 900]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
print_pdf_name = horzcat('subplot_industry_vs_labormarket.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')



%% Scatterplot
% ========================================================================
close all

figureHandle = figure;
scatter(patent_metric_change, labormarket_change, ...
    'Marker', 'o', 'MarkerEdgeColor', my_dark_gray, 'MarkerFaceColor', ...
    my_dark_gray)
box off
set(gca,'TickDir','out') 
set(gcf, 'Color', 'w');
ylabel('Change in labor market')
xlabel('Change in patent match metric')
hl = lsline;
xlim([0, 3])
ylim([0, 3])
set(hl, 'Color', my_light_gray);
uistack(hl, 'bottom')
titlephrase = sprintf('Correlation: %3.2f', corr(labormarket_change', patent_metric_change'));
title(titlephrase)

% Add a 45 degree line
h_45line = refline([1 0]);
set(h_45line, 'Color', 'black', 'Linestyle', '--');
uistack(h_45line, 'bottom')


% Change position and size
set(gcf, 'Position', [100 100 900 500]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
print_pdf_name = horzcat('scatter_labormarket_vs_patentmatches.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')



%% Make table of correlations of labor market statistics vs. patent match 
% summary statistics
% ========================================================================

