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


load('conversion_patent2industry/linked_pat_ix.mat', ...
    'linked_pat_ix');



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
