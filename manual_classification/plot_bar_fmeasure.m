function plot_bar_fmeasure(fmeasure, algorithm_name)

fmeasure(isnan(fmeasure)) = 0;
[fmeasure_sorted, ix_sort] = sort(fmeasure, 'descend');

word_dict = algorithm_name(ix_sort);

figureHandle = figure;

set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

my_dark_gray = [99, 99, 99] ./ 255; % dark gray
my_medium_gray = [189, 189, 189] ./ 255; % medium gray
my_gridmedium_gray = [0.806, 0.806, 0.806];
my_light_gray = [240, 240, 240] ./ 255; 

nr_words = length(word_dict);

color1_pick = my_dark_gray;
bar(fmeasure_sorted, 0.7, 'FaceColor', color1_pick, 'EdgeColor', color1_pick, ... 
    'LineWidth', 1.5)


set(gca, 'TickLength', [0 0]) % turn tick marks off

box off
set(gcf, 'Color', 'white');

xlim([0.5, nr_words + 0.5])
ylim([0 1])


set(gca,'Xtick', 1:nr_words, 'XtickLabel', word_dict, 'FontSize', 10);

ylabel('F1-measure')

gridlines = 0.1:0.1:0.9;
gridxy([], gridlines, 'Color', my_gridmedium_gray)

% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 900 500]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

rotateXLabels( gca(), 45 )

% Export to pdf
% -----------------------------------------------------------------------
print(figureHandle, 'output/fmeasure_classalg_comp.pdf', '-dpdf', '-r0')
