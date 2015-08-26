function make_bivariate_plot(fyr_start, fyr_end, industry_sumstats, ...
    laborm_series, industry_list, igroups)

% Sort industries according to the assigned industry groups
[sortList, ix_sort] = sort( cell2mat(igroups) );

indic_sortchange = [1; diff(sortList)];

% Sort labor market series and industry list
laborm_series_sorted = laborm_series(:, ix_sort);
industry_list_sorted = industry_list(ix_sort);


% Calculate five-year averages
nr_fullyears = length(fyr_start:fyr_end);

interv_length = 5;
laborm_mean = get_interv_means(interv_length, laborm_series_sorted);

manuf_employment = sum(laborm_mean, 2);


% Set font
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

colors = [141,211,199;
        255,255,179;
        190,186,218;
        251,128,114;
        128,177,211;
        253,180,98;
        179,222,105;
        252,205,229;
        217,217,217;
        188,128,189] ./ 255;

nr_colors = size(colors, 1);

% Use this to leave the first marker unfilled (where does times series start)
indic_dot = 4; 

% Choose some more settings
marker_size = 5;
line_width = 1.5;
font_size = 16;

marker_list = {'s', 'o', 'd', '^', '>', 'x'};

figureHandle = figure;

ix_color = 1; % initialize color for first industry group

for ix_industry = 1:size(laborm_series, 2)
    single_laborm_series = laborm_mean(:, ix_industry);
    
    % Divide by total number of employees in manufacturing sector
    ishare_manuf = single_laborm_series ./ manuf_employment;


    automat_ishare = nan(nr_fullyears, 1);
    for i=1:nr_fullyears       
        automat_ishare(i) = industry_sumstats(ix_industry, 2, i) ./ ...
            industry_sumstats(ix_industry, 1, i);
    end
    
    automat_ishare_mean = get_interv_means(interv_length, automat_ishare);

    % Determine which industry group the industry belongs to
    color1_pick = colors(sortList(ix_industry), :);
    
    if indic_sortchange(ix_industry) == 1  
        ix_samecol = 1;        
        
    elseif indic_sortchange(ix_industry) == 0
        ix_samecol = ix_samecol + 1;
    else 
        warning('There should only be 0 and 1 here.')
    end
    
    marker_pick = marker_list{ix_samecol};
    
%     if ix_industry <= nr_colors
%         marker_pick = 's';
%     elseif (ix_industry > nr_colors) && (ix_industry <= 2*nr_colors)
%         marker_pick = 'o';
%     else
%         marker_pick = 'd';
%     end
        
    plot(automat_ishare_mean(indic_dot:end), ishare_manuf(indic_dot:end), ...
        'Color', color1_pick, 'Marker', marker_pick, ...
        'MarkerFaceColor', color1_pick, 'MarkerSize', marker_size, 'LineWidth', line_width)
    hold on
    hStartDot = plot(automat_ishare_mean(1:indic_dot), ishare_manuf(1:indic_dot), 'Color', color1_pick, ...
        'Marker', marker_pick, 'MarkerSize', marker_size, 'LineWidth', line_width);
    hold on
    
    hAnnotation = get(hStartDot, 'Annotation');
    hLegendEntry = get(hAnnotation', 'LegendInformation');
    set(hLegendEntry, 'IconDisplayStyle', 'off')
    
    ylabel('Share of employees in manufacturing sector employed in industry', ...
        'FontSize', font_size)
    xlabel('Share of automation patents', 'FontSize', font_size)
    xlim([0, 1])
end
hold off

box off
set(gcf, 'Color', 'w');
set(gca,'FontSize', 16)
set(gca, 'TickDir', 'out')


legend1 = legend(industry_list_sorted, 'Fontsize', 9, 'Location', 'NorthEast');
legend boxoff
set(legend1,...
    'Position', [0.612598393330502 0.229465274481886 0.387402933563417 0.636627906976745])


% Change position and size
set(gcf, 'Position', [100 200 1500 800]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

% Export to pdf
print(figureHandle, 'output/bivariate_autompat_vs_laborm.pdf', '-dpdf', '-r0')

end

function interv_mean = get_interv_means(interv_length, inseries)
    
    nr_interv = ceil( size(inseries, 1) ./ interv_length );
    
    for j=1:nr_interv

        if j==nr_interv
            extract_series = inseries(1 + interv_length*(j-1) : end, :);
        else
            extract_series = inseries(1 + interv_length*(j-1) : interv_length*j, :);
        end

        interv_mean(j, :) = nanmean(extract_series, 1);
    end
end

