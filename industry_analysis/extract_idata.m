function idata = extract_idata(fyr_start, fyr_end, industry_list, industry_name)

if fyr_end == 2015
    warning('Are you sure about fyr_end = 2015? Should probably be 2014')
end


% Load excel file
[industry_data_raw, txt, ~] = xlsread('industrial_dataset.xlsx');
var_list = txt(4, :);
var_list = var_list'; % row to column cell array

% Delete year and naics_otaf series
var_list = var_list(3:end); 
industry_data = industry_data_raw(:, 3:end);

% Get industry data
naics_otaf = industry_data_raw(:, 2);
naics_list = unique(naics_otaf);



% Extract series
for ix_labormvar=1:length(var_list)
    
    laborm_mat = []; % initialize empty matrix
    
    industry_laborm = industry_data(:, ix_labormvar);

    % Iterate through manufacturing industries
    for ix_industry=1:length(industry_list)

        % Extract labor market data for industry
        industry_nr = industry_list{ix_industry};

        % Check if industry number is pure numeric or mixed with plus or minus
        if str2num(industry_nr) > 0 % All good, continue.
            industry_nr = str2num(industry_nr);
            pos_industry = find(naics_otaf==industry_nr);
            laborm_pick = industry_laborm(pos_industry);

        elseif strcmp('313+', industry_nr)
            subgroup_list = [313:316];
            laborm_pick = sum_industry_subgroups(fyr_start, fyr_end, ...
                subgroup_list, naics_otaf, industry_laborm);

        elseif strcmp('322+', industry_nr)
            subgroup_list = [322, 323];
            laborm_pick = sum_industry_subgroups(fyr_start, fyr_end, ...
                subgroup_list, naics_otaf, industry_laborm);   

        elseif strcmp('325-', industry_nr)
            subgroup_list = [3253, 3255, 3256, 3259];
            laborm_pick = sum_industry_subgroups(fyr_start, fyr_end, ...
                subgroup_list, naics_otaf, industry_laborm); 

        elseif strcmp('334-', industry_nr)
            subgroup_list = [3343, 3346];
            laborm_pick = sum_industry_subgroups(fyr_start, fyr_end, ...
                subgroup_list, naics_otaf, industry_laborm); 

        elseif strcmp('336-', industry_nr) % MISSING: 3366 (apparently together with 3365)
            subgroup_list = [3365, 3369];
            laborm_pick = sum_industry_subgroups(fyr_start, fyr_end, ...
                subgroup_list, naics_otaf, industry_laborm); 

        elseif strcmp('3361+', industry_nr)
            subgroup_list = [3361:3363];
            laborm_pick = sum_industry_subgroups(fyr_start, fyr_end, ...
                subgroup_list, naics_otaf, industry_laborm); 

        elseif strcmp('339-', industry_nr) % 339- = 339 (except 3391)
            subgroup_list = [339];
            laborm_pick = sum_industry_subgroups(fyr_start, fyr_end, ...
                subgroup_list, naics_otaf, industry_laborm); 

        else
            warning('Problem: undefined industry class.')

        end
       
        % Save series for specific labor market series for different 
        % industries in matrix
        laborm_mat(:, ix_industry) = laborm_pick;       
    end
    
        labormvar = var_list{ix_labormvar};
        eval( horzcat('idata.', labormvar, ' = laborm_mat;') );
end
