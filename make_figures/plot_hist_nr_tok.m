function plot_hist_nr_tok(tok_stats)

%% Make histogram
figureHandle = figure;

plot_settings_global()
set(gca,'FontSize', 18) % change default font size of axis labels
set(gcf, 'Color', 'w');

subplot(3, 1, 1)
hist( tok_stats.nr_titleTok, length(1:max(tok_stats.nr_titleTok)) );
set(get(gca, 'child'), 'FaceColor', color2_pick, 'EdgeColor', color1_pick);
xlabel('Number of tokens in patent text title')
ylabel('Number of patents')
box off
set(gca,'TickDir','out')

up_str = ['Mean: ', num2str( round(100 * mean( tok_stats.nr_titleTok ) )/100 ), ...
    '     Number of all tokens: ', num2str(tok_stats.nr_allTok(1))];
bottom_str = ['Median: ', num2str( median( tok_stats.nr_titleTok ) ), ...
    '     Number unique tokens: ', num2str(tok_stats.nr_uniqueTok(1))];

annotation(figureHandle,'textbox',...
    [0.58 0.81 0.3 0.06],...
    'String', {up_str, bottom_str}, 'FitBoxToText', 'off');


subplot(3, 1, 2)
hist(tok_stats.nr_abstractTok, length(1:max(tok_stats.nr_abstractTok)))
set(get(gca, 'child'), 'FaceColor', color2_pick, 'EdgeColor', color1_pick);
xlabel('Number of tokens in patent text abstract')
ylabel('Number of patents')
box off
set(gca,'TickDir','out')

up_str = ['Mean: ', num2str( round(100 * mean( tok_stats.nr_abstractTok ) )/100 ), ...
    '     Number of all tokens: ', num2str(tok_stats.nr_allTok(2))];
bottom_str = ['Median: ', num2str( median( tok_stats.nr_abstractTok ) ), ...
    '     Number unique tokens: ', num2str(tok_stats.nr_uniqueTok(2))];

annotation(figureHandle,'textbox',...
    [0.58 0.5 0.3 0.06],...
    'String', {up_str, bottom_str}, 'FitBoxToText', 'off');


subplot(3, 1, 3)
hist(tok_stats.nr_bodyTok, length(1:max(tok_stats.nr_bodyTok)))
set(get(gca, 'child'), 'FaceColor', color2_pick, 'EdgeColor', color1_pick);
xlabel('Number of tokens in patent text body')
ylabel('Number of patents')
box off
set(gca,'TickDir','out')

up_str = ['Mean: ', num2str( round(100 * mean( tok_stats.nr_bodyTok ) )/100 ), ...
    '     Number of all tokens: ', num2str(tok_stats.nr_allTok(3))];
bottom_str = ['Median: ', num2str( median( tok_stats.nr_bodyTok ) ), ...
    '     Number unique tokens: ', num2str(tok_stats.nr_uniqueTok(3))];

annotation(figureHandle,'textbox',...
    [0.58 0.2 0.3 0.06],...
    'String', {up_str, bottom_str}, 'FitBoxToText', 'off');


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 1000 700]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print(figureHandle, 'output/hist_nr_tok', '-dpdf', '-r0')

