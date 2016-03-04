function PLOT_STACKOVERFLOW(patextr)

plot_settings_global

set(0, 'DefaultTextFontName', 'Helvetica')
set(0, 'DefaultAxesFontName', 'Helvetica')

figureHandle = figure;

T = length(patextr.title_cond_prob_no); % number of tokens

subplot(3, 2, 1)
plot(patextr.title_cond_prob_yes, 'Color', color4_pick)
hold on
plot(patextr.title_cond_prob_no, 'Color', color5_pick)
box off
xlim([0, T])
ylim([0, 1])
ylabel('Cond. prob.')
xlabel('Tokens')
set(gca, 'TickDir', 'out')

subplot(3, 2, 2)
scatter(patextr.title_cond_prob_yes, patextr.title_cond_prob_no, ...
    'MarkerEdgeColor', color3_pick)
xlim([0, 1])
ylim([0, 1])
xlabel('Automation patent', 'Color', color4_pick)
ylabel('Not autom. pat.', 'Color', color5_pick)
set(gca, 'TickDir', 'out')

subplot(3, 2, 3)
plot(patextr.abstract_cond_prob_yes, 'Color', color4_pick)
hold on
plot(patextr.abstract_cond_prob_no, 'Color', color5_pick)
box off
xlim([0, T])
ylim([0, 1])
ylabel('Cond. prob.')
xlabel('Tokens')
set(gca, 'TickDir', 'out')

subplot(3, 2, 4)
scatter(patextr.abstract_cond_prob_yes, patextr.abstract_cond_prob_no, ...
    'MarkerEdgeColor', color3_pick)
xlim([0, 1])
ylim([0, 1])
xlabel('Automation patent', 'Color', color4_pick)
ylabel('Not autom. pat.', 'Color', color5_pick)
set(gca, 'TickDir', 'out')

subplot(3, 2, 5)
plot(patextr.body_cond_prob_yes, 'Color', color4_pick)
hold on
plot(patextr.body_cond_prob_no, 'Color', color5_pick)
box off
xlim([0, T])
ylim([0, 1])
ylabel('Cond. prob.')
xlabel('Tokens')
set(gca, 'TickDir', 'out')

subplot(3, 2, 6)
scatter(patextr.body_cond_prob_yes, patextr.body_cond_prob_no, ...
    'MarkerEdgeColor', color3_pick)
xlim([0, 1])
ylim([0, 1])
xlabel('Automation patent', 'Color', color4_pick)
ylabel('Not autom. pat.', 'Color', color5_pick)
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
set(gcf, 'Position', [100 200 800 600]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

% Export to pdf
print(figureHandle, 'output/example_CondProb.pdf', '-dpdf', '-r0')
