close all
clear all
clc

addpath('../functions')

year_start = 1976;
year_end = 2014;


% Load summary data
load('../conversion_patent2industry/industry_sumstats.mat')


% Load excel file
[industry_data_raw, txt, ~] = xlsread('industrial_dataset.xlsx');
var_list = txt(4, :);

% Delete year and naics_otaf series
var_list = var_list(3:end); 
industry_data = industry_data_raw(:, 3:end);

% Get industry data
naics_otaf = industry_data_raw(:, 2);
naics_list = unique(naics_otaf);


%%  
for ix_labormvar=1:length(var_list)
    labormvar = var_list{ix_labormvar};
    fprintf('Chosen labor market variable: %s.\n', labormvar)
    industry_laborm = industry_data(:, ix_labormvar);


    % Iterate through manufacturing industries
    for ix_industry=1:size(industry_sumstats, 1)

        % Extract patent match data for industry
        industry_name = industry_sumstats{ix_industry, 2, 1};
        sumstats = extract_sumstats(industry_sumstats, ix_industry);
        industry_nr_pat = sumstats(:, 1);
        industry_nr_matches = sumstats(:, 2);
        industry_pat_1match = sumstats(:, 3);
        industry_automix = sumstats(:, 4);
        industry_avg_matches = industry_nr_matches ./ industry_nr_pat;
        
        % Share of patents classified as automation patents (> 1 keyword match)
        industry_pat1match_share = industry_pat_1match ./ industry_nr_pat;

        patent_metrics = [industry_pat_1match, industry_avg_matches, ...
            industry_pat1match_share, industry_automix];
        
        % Iterate through metric of the patent matches to compare to labor market
        % outcomes
        for ix_patentmetric=1:size(patent_metrics,2)
            patent_metric_pick = patent_metrics(:, ix_patentmetric);

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

            % Test if all data for this industry is NaN
            if isempty(notnanval)
                labormarket_change(ix_industry) = nan;
                patent_metric_change(ix_industry) = nan;
            else
                first_val = notnanval(1);
                last_val = notnanval(end);
                labormarket_change(ix_industry) = laborm_pick(last_val) / laborm_pick(first_val);
                patent_metric_change(ix_industry) = patent_metric_pick(last_val) / patent_metric_pick(first_val);
            end

            % Normalize for plot
            pick_normalization_date = 2000;
            pick_normalization_index = pick_normalization_date-year_start+1;

            laborm_pick = laborm_pick / laborm_pick(pick_normalization_index);
            patent_metric_pick = patent_metric_pick / patent_metric_pick(pick_normalization_index);

            % Calculate correlation where we have data (ignoring NaNs)
            correlation_plotseries = corrcoef(laborm_pick, ...
                patent_metric_pick, 'rows','complete');
            correlation_plotseries = correlation_plotseries(1,2);

            % Save the correlations between all variables for all industries
            corr_laborm_patentm(ix_patentmetric, ix_labormvar, ix_industry) = correlation_plotseries;
        end
    end
end


%% Make table of correlations

% Take mean of correlations
meancorr = nanmean(corr_laborm_patentm, 3);
meancorr = meancorr(:, [5, 4, 2, 8, 6, 9, 1, 3, 7])


stdcorr = nan(size(meancorr));

for ix_row=1:size(stdcorr,1)
    for ix_column=1:size(stdcorr,2)
        extractvec = squeeze(corr_laborm_patentm(ix_row, ix_column, :));
        stdcorr(ix_row, ix_column) = nanstd(extractvec);
    end
end


tablestr = repmat({''}, size(meancorr));

for ix_val=1:length(meancorr(:))
    if meancorr(ix_val) > 0
        tablestr{ix_val} = ['\cellcolor{mylightred}', num2str(round(100*meancorr(ix_val))/100)];
    elseif meancorr(ix_val) < 0
        tablestr{ix_val} = ['\cellcolor{mylightgreen}', num2str(round(100*meancorr(ix_val))/100)];
    else
        tablestr{ix_val} = num2str(round(100*meancorr(ix_val))/100);
    end
end

% Print to .txt file in Latex format
printname = 'table_meancorr_laborm_patentm.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Average correlations of labor market outcomes and automation across industries}}\n');
fprintf(FID,'\\label{tab:meancorr_laborm_patentm}\n');
fprintf(FID,'\\begin{tabular}{lrrrrrrrrr}\n');
fprintf(FID,'\\toprule \\addlinespace[0.5em]\n');
% fprintf(FID,' & Production & Output & Capital & Capital Productivity & Employment & Labor cost & Labor productivity & Capital cost & Output deflator  \\tabularnewline[0.05cm]\n');

fprintf(FID,' & \\rot{Employment} & \\rot{Capital Productivity} & \\rot{Output} & \\rot{Capital cost} &  \\rot{Labor cost} & \\rot{Output deflator} & \\rot{Production} & \\rot{Capital} & \\rot{Labor productivity} \\tabularnewline[0.05cm]\n');
fprintf(FID,'\\midrule \\addlinespace[0.5em]\n');


fprintf(FID,'\\# Automation patents$^1$ ');
for ix_element=1:size(tablestr,2)
    fprintf(FID,'& %s ', tablestr{1,ix_element});
end
fprintf(FID,' \\tabularnewline[0.0cm]\n');
fprintf(FID,' & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} \\tabularnewline[0.1cm]\n', stdcorr(1,:));


fprintf(FID,'Average match per patent ');
for ix_element=1:size(tablestr,2)
    fprintf(FID,'& %s ', tablestr{2,ix_element});
end
fprintf(FID,' \\tabularnewline[0.0cm]\n');
fprintf(FID,' & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} \\tabularnewline[0.1cm]\n', stdcorr(2,:));


fprintf(FID,'Share of automation patents ');
for ix_element=1:size(tablestr,2)
    fprintf(FID,'& %s ', tablestr{3,ix_element});
end
fprintf(FID,' \\tabularnewline[0.0cm]\n');
fprintf(FID,' & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} \\tabularnewline[0.1cm]\n', stdcorr(3,:));


fprintf(FID,'Automation index$^2$ ');
for ix_element=1:size(tablestr,2)
    fprintf(FID,'& %s ', tablestr{4,ix_element});
end
fprintf(FID,' \\tabularnewline[0.0cm]\n');
fprintf(FID,' & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} \\tabularnewline[0.1cm]\n', stdcorr(4,:));


% fprintf(FID,'\\# Automation patents & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f \\tabularnewline[0.1cm]\n', meancorr(1,:));
% fprintf(FID,'Average match per patent & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f \\tabularnewline[0.1cm]\n',  meancorr(2,:));
% fprintf(FID,'Share of automation patents & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f \\tabularnewline[0.1cm]\n',  meancorr(3,:));
% fprintf(FID,'Automation index & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f \\tabularnewline[0.1cm]\n',  meancorr(4,:));


fprintf(FID,'\\bottomrule\n');
fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\begin{tablenotes}\n');
fprintf(FID,'\\small\n');
fprintf(FID,'\\item \\textit{Note:} Correlations are calculated from the yearly time series 1987-2014 of the automation indicator and the labor market outcome series. The values are cross-sectional averages across the 26 manufacturing industries. Values in parentheses show standard deviations.\n');
fprintf(FID,'\\item $^1$: Automation patents are defined as patents with at least one keyword match.\n');
fprintf(FID,'\\item $^2$: $log(1 + \\text{number of matches per patent})$.\n');
fprintf(FID,'\\item \\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID,'\\end{tablenotes}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 


%%
fprintf('Saved: %s.\n', printname)





















