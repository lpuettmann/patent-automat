function PLOT_STACKOVERFLOW(patextr)

plot_settings_global

set(0, 'DefaultTextFontName', 'Helvetica')
set(0, 'DefaultAxesFontName', 'Helvetica')

color4_pick = [228,26,28] ./ 255;
color5_pick = [55,126,184] ./ 255;

figureHandle = figure;

% T = length(patextr.title_cond_prob_no); % number of tokens
T = 500;

subplot(1, 2, 1)
plot(patextr.body_cond_prob_yes(1:T), 'Color', color4_pick)
hold on
plot(patextr.body_cond_prob_no(1:T), 'Color', color5_pick)
box off
xlim([0, T])
ylim([0, 1])
ylabel('Cond. prob.')
xlabel('Tokens')
set(gca, 'TickDir', 'out')

subplot(1, 2, 2)
scatter(patextr.body_cond_prob_yes(1:T), patextr.body_cond_prob_no(1:T), ...
    'MarkerEdgeColor', color3_pick)
xlim([0, 1])
ylim([0, 1])
xlabel('Class 1', 'Color', color4_pick)
ylabel('Class 2', 'Color', color5_pick)
set(gca, 'TickDir', 'out')

annotation(figureHandle,'textbox',...
    [0.315944881889764 0.900970873786407 0.25 0.0515810207578111],...
    'String',{'Class 1'},...
    'FitBoxToText','off',...
    'EdgeColor', 'none',...
    'Color', color4_pick);

annotation(figureHandle,'textbox',...
    [0.319408659161158 0.854368932038835 0.25 0.0535227683306251],...
    'String',{'Class 2'},...
    'FitBoxToText','off',...
    'EdgeColor', 'none',...
    'Color', color5_pick);



% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 800 400]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

% Export to pdf
print(figureHandle, 'output/example_CondProb.pdf', '-dpdf', '-r0')
