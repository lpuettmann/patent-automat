function subplot_patentm_vs_laborm(year_start, year_end, ... 
    manufacturing_ind_data, pat2ind, ix_patentmetric, ix_labormvar)


%% Plot settings
dim_subplot = [7, 4];
color1_pick = [0.7900, 0.3800, 0.500];  % red-pink
color2_pick =  [0.000,0.639,0.561]; % greenish
my_light_gray = [0.5, 0.5, 0.5];
my_dark_gray = [0.3, 0.3, 0.3];

set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

plottime = year_start:year_end;
xax_limit = [year_start, year_end];
yax_limit = [0, 4];

figureHandle = figure;
set(gcf, 'Color', 'w');

pick_normalization_date = 2000;


%% Pick the labor market statistic to look at
choose_labormvar_list = {'production', 'output', 'capital', ...
    'capital_productivity', 'employment', 'labor_cost', ...
    'labor_productivity', 'capital_cost', 'output_deflator', ...
    'employment_share'}; % list to choose from

choose_labormvar = choose_labormvar_list{ix_labormvar};
fprintf('Chosen labor market variable: %s.\n', choose_labormvar)


%% Loop through subplots
for ix_industry=1:size(pat2ind.industry_sumstats, 1)

    eval(horzcat('laborm_pick = manufacturing_ind_data.idata.laborm.', ...
        choose_labormvar, '(:, ix_industry);'));
          
   % Extract patent match data for industry
    industry_name = pat2ind.industry_sumstats{ix_industry, 2, 1};
    sumstats = extract_sumstats(pat2ind.industry_sumstats, ix_industry);
    industry_nr_pat = sumstats(:, 1);
    industry_nr_alg1 = sumstats(:, 2);
    industry_nr_pat1m = sumstats(:, 3);

    % Share of patents classified as automation patents
    industry_nr_alg1_share = industry_nr_alg1 ./ industry_nr_pat;
    industry_nr_pat1m = industry_nr_pat1m ./ industry_nr_pat;
    
    patent_metrics = [industry_nr_alg1, industry_nr_pat1m, ...
        industry_nr_alg1_share, industry_nr_pat1m];
    patent_metric_pick = patent_metrics(:, ix_patentmetric);

    
    % Normalize for plot
%     pick_normalization_index = pick_normalization_date-year_start+1;
% 
%     laborm_pick = laborm_pick / laborm_pick(pick_normalization_index);
%     patent_metric_pick = patent_metric_pick / patent_metric_pick(pick_normalization_index);


    % Make a time series plot with both series
    subplot(7, 4, ix_industry)
    plot(plottime, laborm_pick, ...
        'LineWidth', 0.7, ...
        'Color', color1_pick, ...
        'Marker', 'diamond' , ...   
        'MarkerSize', 2, ...   
        'MarkerEdgeColor', color1_pick, ...
        'MarkerFaceColor', color1_pick);
    hold on
    plot(plottime, patent_metric_pick, ...
        'LineWidth', 0.7, ...
        'Color', color2_pick, ...
        'Marker', 'o', ...   
        'MarkerSize', 2, ...   
        'MarkerEdgeColor', color2_pick, ...
        'MarkerFaceColor', color2_pick);
    hold on
    xlim(xax_limit)
%     ylim(yax_limit)

    hx = graph2d.constantline(pick_normalization_date, 'LineStyle',':', ...
        'Color', my_dark_gray);
    changedependvar(hx,'x');


    % Calculate correlation where we have data (ignoring NaNs)
    correlation_plotseries = corrcoef(laborm_pick, ...
        patent_metric_pick, 'rows','complete');
    correlation_plotseries = correlation_plotseries(1,2);


    titlestring = sprintf('%s (%3.2f)', industry_name, correlation_plotseries);
    title(titlestring, 'FontSize', 8)
    box off
    set(gca,'TickDir','out') 
    leave_xaxis_bottomonly(ix_industry, dim_subplot, ...
        size(pat2ind.industry_sumstats, 1), 'labels')
end

legend(regexprep(choose_labormvar,'_',' '), 'Automation statistic', ...
    'Location', 'NorthEastOutside')
legend boxoff  

% Change position and size
set(gcf, 'Position', [100 100 1500 900]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
print_pdf_name = horzcat('output/subplot_patmatchindustry_vs_', ...
    choose_labormvar, '.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

