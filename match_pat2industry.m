close all
clear all
clc

addpath('conversion_patent2industry')
addpath('matches')

% Load industry names
[~, ind_code_table] = xlsread('industry_names.xlsx');


load('conversion_table.mat')
industry_list = unique(naics_class_list);


year_start = 1976;
year_end = 2014;

% Initialize
linked_pat_ix = repmat({''}, length(year_start:year_end), ...
    length(industry_list));

for ix_year = year_start:year_end
    
    ix_iter = ix_year - year_start + 1;
    
    load(horzcat('patent_keyword_appear_', num2str(ix_year), '.mat'))  

    % Count how many patents map into the industry
    classification_nr = patent_keyword_appear(:, 3);

    
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
        tc2ind = unique(tc2ind);


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
        nr_keyword_appear = cell2mat(patent_keyword_appear(:, 2));
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


%%
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


    load(horzcat('patent_keyword_appear_', num2str(ix_year), '.mat'))
    nr_patents = size(patent_keyword_appear, 1);

    % Check which patents are linked
    patents_linked = unique(allind_patix2ind);
    patents_not_linked = setdiff(1:nr_patents, patents_linked);

    if ~((length(patents_not_linked) + length(patents_linked)) == nr_patents)
        warning('Should be equal.')
    end

    share_patents_linked(ix_iter,1) = length(patents_linked)/nr_patents;

    fprintf('[Year %d] -- # linked patents: %d (%3.2f), # not linked patents: %d (%3.2f).\n', ...
        ix_year, length(patents_linked), share_patents_linked(ix_iter,1), ...
        length(patents_not_linked), 1-share_patents_linked(ix_iter,1))
end

% Count patents that map to more than one industry
% [n, bin] = histc(allind_patix2ind, unique(allind_patix2ind));
% multiple = find(n > 1);
% index    = find(ismember(bin, multiple));
% length(index)


fprintf('Average share of patents linked to industry per year: %3.2f', mean(share_patents_linked))


%% Make figure: share of patents linked to industries over time

set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

color1_pick = [49, 130, 189] ./ 255;
my_gray = [0.8, 0.8, 0.8];

yax_limit = [0, 1];
plottime = year_start:year_end;

figureHandle = figure;
set(gcf, 'Color', 'w');
plot(plottime, share_patents_linked, 'Color', color1_pick, 'Marker', 'o', ...
    'MarkerEdgeColor', color1_pick, 'MarkerFaceColor', color1_pick, ...
    'MarkerSize', 2.1)
title('Share of Patents linked to Manufacturing Industries')
box off
set(gca,'TickDir','out') 
ylim(yax_limit)

% Change position and size
set(gcf, 'Position', [100 100 800 500]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
print_pdf_name = horzcat('share_pat_link2ind.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')




