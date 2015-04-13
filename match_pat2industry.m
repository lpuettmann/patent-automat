close all
clear all
clc

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


%%
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



%% Make histogram: patents linked to how many industries
[hist_counts, ~] = hist(nr_appear_allyear, ...
    length(0:max(nr_appear_allyear)));

hist_counts = hist_counts ./ sum(hist_counts);

disp('---------------------------------------------------------------')
fprintf('Share of patents linked to at least one industry: %3.2f.\n', ...
    1-hist_counts(1))

hist_centers = 0:max(nr_appear_allyear);


set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

color1_pick = [49, 130, 189] ./ 255;
my_gray = [0.8, 0.8, 0.8];

figureHandle = figure;
set(gcf, 'Color', 'w');
bar(hist_centers, hist_counts, 'FaceColor', color1_pick, 'EdgeColor', 'k')
box off
set(gca,'TickDir','out') 
set(gca,'FontSize',11) % change default font size of axis labels
xlabel('Number of industries that patent is linked to')
ylabel('Share of patents')
xlim([-0.5, 18.5])

set(gca, 'YTick', [], 'YColor', 'white') % turn y-axis off

% Change position and size
set(gcf, 'Position', [100 100 800 500]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


annotation(figureHandle,'textarrow',[0.138849929873773 0.144460028050491],...
    [0.485714285714286 0.454761904761907],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'FontSize',12,...
    'String','9.8%',...
    'HeadStyle','none');

annotation(figureHandle,'textarrow',[0.193548387096773 0.192145862552595],...
    [0.885714285714289 0.873809523809524],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'FontSize',12,...
    'String','22%',...
    'HeadStyle','none');

annotation(figureHandle,'textarrow',[0.239831697054698 0.23562412342216],...
    [0.811904761904763 0.800000000000001],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'FontSize',12,...
    'String','20%',...
    'HeadStyle','none');

annotation(figureHandle,'textarrow',[0.282272089761571 0.272089761570827],...
    [0.601428571428576 0.583333333333334],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'FontSize',12,...
    'String','14%',...
    'HeadStyle','none');

annotation(figureHandle,'textarrow',[0.879382889200561 0.884992987377279],...
    [0.204761904761905 0.185714285714287],'TextEdgeColor','none',...
    'HorizontalAlignment','left',...
    'FontSize',12,...
    'String','1.6%',...
    'HeadStyle','none');


% Export to pdf
print_pdf_name = horzcat('histogram_nr_ind_linked2.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')



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
box off
set(gca,'TickDir','out') 
ylim(yax_limit)
set(gca,'FontSize',11) % change default font size of axis labels
yLimits = get(gca,'YLim');
ygrid_lines = [yLimits(1):0.2:yLimits(end)];

addpath('make_figures\') % change later
handle_ygrid = gridxy([], ygrid_lines, 'Color', my_gray , 'linewidth', 0.9);

ax2 = axes('Position', get(gca, 'Position'),'Color','none');
set(ax2,'XTick',[], 'YTick',[], 'YColor','w')

% Change position and size
set(gcf, 'Position', [100 100 500 250]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
print_pdf_name = horzcat('share_pat_link2ind.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
