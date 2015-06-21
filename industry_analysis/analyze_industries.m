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



%% Make new labor market series: share of employees of total manufacturing 
% industry employment in one industry
employment = industry_data(:, 5); % extract employment series

yearlength = length(year_start:year_end);
industrylength = length(naics_list);

manufact_employment = zeros(yearlength, 1); % initialize

for t=1:yearlength

    employment_sum = 0;
    
    for j=1:industrylength
        add_number = employment(t + (yearlength)*(j-1));
        employment_sum = employment_sum + add_number;
    end
    
    % Total manufacturing employment
    manufact_employment(t) = employment_sum;
    
end

employment_share = employment ./ repmat(manufact_employment, ...
    industrylength, 1); % new series manufacturing employment share

% Add series to previous dataset
industry_data = [industry_data, employment_share];
var_list = [var_list, 'employment_share'];


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

            laborm_pick_norm = laborm_pick / laborm_pick(pick_normalization_index);
            patent_metric_pick_norm = patent_metric_pick / patent_metric_pick(pick_normalization_index);

            % Calculate correlation where we have data (ignoring NaNs)
            correlation_plotseries = corrcoef(laborm_pick_norm, ...
                patent_metric_pick_norm, 'rows','complete');
            correlation_plotseries = correlation_plotseries(1,2);

            % Save the correlations between all variables for all industries
            corr_laborm_patentm(ix_patentmetric, ix_labormvar, ix_industry) = correlation_plotseries;
            
            if ix_patentmetric==1
                % Initialize matrix on first iteration
                patent_metric_pickmat = zeros(size(patent_metric_pick)); 
            end
            patent_metric_pickmat = [patent_metric_pickmat, patent_metric_pick];
            if ix_patentmetric==size(patent_metrics,2)
                % Delete first column in last iteration
                patent_metric_pickmat = patent_metric_pickmat(:, 2:end); 
            end
        end
        
        
        % Save industry labor market series in a structure
        savename = regexprep(industry_name,' ','_');
        savename = regexprep(savename,',','');
        if numel(savename)>50
            savename = savename(1:50);
        end
        eval(horzcat('idata.patent_metric.', savename, ' = patent_metric_pickmat;'));
                
        % Save all industry series for the labor market variable in a
        % matrix
        if ix_industry==1
            % Initialize matrix on first iteration
            laborm_pickmat = zeros(size(laborm_pick)); 
        end
        laborm_pickmat = [laborm_pickmat, laborm_pick];
        if ix_industry==size(industry_sumstats, 1)
            % Delete first column in last iteration
            laborm_pickmat = laborm_pickmat(:, 2:end); 
        end
    end
    
    % Save industry labor market series in a structure
    eval(horzcat('idata.laborm.', labormvar, ' = laborm_pickmat;'));

end


save('manufacturing_ind_data.mat', 'idata', ...
    'corr_laborm_patentm', 'labormarket_change', 'patent_metric_change');

