function plotmatrix_tokstats(Xmat)

plot_settings_global;

figureHandle = figure;

subplot(4, 3, 1)
scatter(Xmat(:, 2), Xmat(:, 1), 'MarkerEdgeColor', color1_pick)
ylim([0, 1])
ylabel('Cond. prob. "Yes"')
xlabel('Cond. prob. "No"')
set(gca,'xaxisLocation','top')
annotation(figureHandle,'textbox',...
    [0.273206303724928 0.780048076923077 0.1 0.0348557692307694],...
    'String',{'Corr: 0.88'},...
    'FitBoxToText','off',...
    'EdgeColor','none');

subplot(4, 3, 2)
scatter(Xmat(:, 3), Xmat(:, 1), 'MarkerEdgeColor', color1_pick)
ylim([0, 1])
xlabel('Mutual information')
set(gca,'xaxisLocation','top')
set(gca,'ytick',[])
annotation(figureHandle,'textbox',...
    [0.53 0.78448275862069 0.1 0.0482758620689654],...
    'String',{'Corr: 0.19'},...
    'FitBoxToText','off',...
    'EdgeColor','none');

subplot(4, 3, 3)
scatter(Xmat(:, 4), Xmat(:, 1), 'MarkerEdgeColor', color1_pick)
ylim([0, 1])
xlabel('#doc with token')
set(gca,'xaxisLocation','top')
set(gca,'ytick',[])
annotation(figureHandle,'textbox',...
    [0.818897637795276 0.786206896551724 0.0679133858267717 0.0413793103448276],...
    'String',{'Corr: 0.95'},...
    'FitBoxToText','off',...
    'EdgeColor','none');


% subplot(4, 3, 4) is empty

subplot(4, 3, 5)
scatter(Xmat(:, 3), Xmat(:, 2), 'MarkerEdgeColor', color1_pick)
ylabel('Cond. prob. "No"')
set(gca,'xtick',[])
annotation(figureHandle,'textbox',...
    [0.53348031496063 0.636206896551724 0.0777401574803151 0.0448275862068965],...
    'String',{'Corr: -0.086'},...
    'FitBoxToText','off',...
    'EdgeColor','none');

subplot(4, 3, 6)
scatter(Xmat(:, 4), Xmat(:, 2), 'MarkerEdgeColor', color1_pick)
set(gca,'ytick',[])
set(gca,'xtick',[])
annotation(figureHandle,'textbox',...
    [0.74 0.644827586206896 0.0856141732283465 0.0431034482758618],...
    'String',{'Corr: 0.99'},...
    'FitBoxToText','off',...
    'EdgeColor','none');


% subplot(4, 3, 7) is empty

% subplot(4, 3, 8) is empty

subplot(4, 3, 9)
scatter(Xmat(:, 4), Xmat(:, 3), 'MarkerEdgeColor', color1_pick)
ylabel('Mutual information')
set(gca,'xtick',[])
annotation(figureHandle,'textbox',...
    [0.812023622047244 0.413793103448276 0.0738031496062994 0.0448275862068964],...
    'String',{'Corr: 0.0056'},...
    'FitBoxToText','off',...
    'EdgeColor','none');


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 1200 900]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

% Export to pdf
print(figureHandle, 'output/plotmatrix_tokstats.pdf', '-dpdf', '-r0')