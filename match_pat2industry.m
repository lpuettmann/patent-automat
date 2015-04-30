close all
clear all
clc

tic

addpath('conversion_patent2industry')
addpath('cleaned_matches')

% Load industry names
[~, ind_code_table] = xlsread('industry_names.xlsx');


load('conversion_table.mat')
industry_list = unique(naics_class_list);


year_start = 1976;
year_end = 2014;

% Initialize
linked_pat_ix = repmat({''}, length(year_start:year_end), ...
    length(industry_list));


% Iterate through yearly files and link the patent's technology
% classification to the industry.
for ix_year = year_start:year_end
    
    ix_iter = ix_year - year_start + 1;
    
    load(horzcat('patsearch_results_', num2str(ix_year), '.mat'))  

    % Count how many patents map into the industry
    classification_nr = patsearch_results(:, 3);

    
    for ix_industry=1:length(industry_list)
        industry_nr = industry_list{ix_industry};
        list_pos = find(strcmp(ind_code_table(:,1), industry_nr));
        industry_name = ind_code_table{list_pos, 2};
        industry_name = cellstr(industry_name);
        industry_name = industry_name{1};

        % Find industry number in the naics list
        positions_table = find(strcmp(naics_class_list, industry_nr));

        % Get the set of patent tech classifications that are matched into the
        % respective industry.
        tc2ind = tech_class_list(positions_table);
        tc2ind = unique(tc2ind); % delete duplicates (and sort)


        % Find patents that have the right tech classifications
        patix2ind = 0;

        for ix_set=1:length(tc2ind)
            pick_nr = num2str(tc2ind(ix_set));

            patix2ind = [patix2ind;
                        find(strcmp(classification_nr, pick_nr))];
        end

        patix2ind(1) = [];

        patix2ind = sort(patix2ind);

        if min(unique(patix2ind) == patix2ind) < 1
            warning('There should be no duplicates here.')
        end

        % Save which patents link to industries
        linked_pat_ix{ix_iter, ix_industry} = patix2ind;
        
        % Find keyword matches of the patents that map to the industry
        nr_keyword_appear = cell2mat(patsearch_results(:, 2));
        industry_keyword_matches = nr_keyword_appear(patix2ind);
        
        % Patents with at least one keyword match
        industry_distpatents_w_1m = (industry_keyword_matches>0);

        % Save yearly summary statistics for industries
        save_sumstats = [length(patix2ind), sum(industry_keyword_matches), ...
            sum(industry_distpatents_w_1m)];

        industry_sumstats(ix_industry, :, ix_iter) = ...
            {industry_name, save_sumstats};
    end
    
    fprintf('Finished year: %d.\n', ix_year)
end

save('conversion_patent2industry/linked_pat_ix.mat', ...
    'linked_pat_ix');
save('conversion_patent2industry/industry_sumstats.mat', ...
    'industry_sumstats');


%% Analyze how many patents were linked to how many industries 
nr_appear_allyear = 0;

for ix_year = year_start:year_end
    ix_iter = ix_year - year_start + 1;

    % Stack all patent links underneath in long vector
    allind_patix2ind = 0; % initialize
    for ix_industry=1:length(industry_list)
        patix2ind = linked_pat_ix{ix_iter, ix_industry};
        allind_patix2ind = [allind_patix2ind;
                            patix2ind];
    end
    allind_patix2ind(1) = [];
   
    % Import info about patents in that year
    load(horzcat('patsearch_results_', num2str(ix_year), '.mat'))
    nr_patents = size(patsearch_results, 1);
    
    
    % Check which patents are linked
    patents_linked = unique(allind_patix2ind);
    patents_not_linked = setdiff(1:nr_patents, patents_linked)';

    if ~((length(patents_not_linked) + length(patents_linked)) == nr_patents)
        warning('Should be equal.')
    end

    share_patents_linked(ix_iter,1) = length(patents_linked)/nr_patents;

    fprintf('[Year %d] -- # linked patents: %d (%3.2f), # not linked patents: %d (%3.2f).\n', ...
        ix_year, length(patents_linked), share_patents_linked(ix_iter,1), ...
        length(patents_not_linked), 1-share_patents_linked(ix_iter,1))
    
    
    % Count how many industries patents are linked to
    [nr_appear, ~] = histc(allind_patix2ind, 1:nr_patents);
    
    nr_appear_allyear = [nr_appear_allyear;
                        nr_appear];
end

nr_appear_allyear(1) = [];


save('conversion_patent2industry/share_patents_linked.mat', ...
    'share_patents_linked');


save('conversion_patent2industry/nr_appear_allyear.mat', ...
    'nr_appear_allyear');


length(nr_appear_allyear)


toc
