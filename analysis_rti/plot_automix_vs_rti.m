function plot_automix_vs_rti(automix_use_log_sum, ...
    rel_automix_mean, rti60, ix_manufact, save_str)

%%
pos_manufact = find( ix_manufact );
pos_other_ind = find( not( ix_manufact ) );

frame_size = [100 200 500 380];
set_font_size = 18;


%%
figure1 = figure;

plot_settings_global()
set(gca,'FontSize', set_font_size) % change default font size of axis labels
set(gcf, 'Color', 'w');
box off

scatter(automix_use_log_sum, rti60, ...
    'Marker', '.', 'MarkerEdgeColor', color3_pick)

hold on
xpush = [min(automix_use_log_sum), max(automix_use_log_sum)];
mdl = fitlm(automix_use_log_sum, rti60);
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color1_pick);

ylabel('Share of routine labor 1960')
xlabel('log( total automation index )')
set(gca,'TickDir','out')
ylim([0, 1])


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', frame_size) % in vector: left bottom width height

set(figure1, 'Units', 'Inches');
pos = get(figure1, 'Position');

set(figure1, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/lautomix_vs_rti60_', save_str, '.pdf');
print(figure1, print_pdf_name, '-dpdf', '-r0')



%%
close all
figure2 = figure;

plot_settings_global()
set(gca,'FontSize', set_font_size) % change default font size of axis labels
set(gcf, 'Color', 'w');
box off

scatter(rel_automix_mean, rti60, ...
    'Marker', '.', 'MarkerEdgeColor', color3_pick)

hold on
xpush = [min(rel_automix_mean), max(rel_automix_mean)];
mdl = fitlm(rel_automix_mean, rti60);
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color1_pick);

ylabel('Share of routine labor 1960')
xlabel('Relative automation index')
set(gca,'TickDir','out')
xlim([0, 1])
ylim([0, 1])


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', frame_size) % in vector: left bottom width height

set(figure2, 'Units', 'Inches');
pos = get(figure2, 'Position');

set(figure2, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/rel_automix_vs_rti60_', save_str, '.pdf');
print(figure2, print_pdf_name, '-dpdf', '-r0')


%%
close all
figure3 = figure;

plot_settings_global()
set(gca,'FontSize', set_font_size) % change default font size of axis labels
set(gcf, 'Color', 'w');
box off

scatter(rel_automix_mean( pos_other_ind ), ...
    rti60( pos_other_ind ), ...
    'Marker', '.', 'MarkerEdgeColor', color3_pick)

hold on
xpush = [min(rel_automix_mean( pos_other_ind )), max(rel_automix_mean( pos_other_ind ))];
mdl = fitlm(rel_automix_mean( pos_other_ind ), rti60( pos_other_ind ));
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color1_pick);

ylabel('Share of routine labor 1960')
xlabel('Relative automation index')
set(gca,'TickDir','out')
ylim([0, 1])
xlim([0, 1])


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', frame_size) % in vector: left bottom width height

set(figure3, 'Units', 'Inches');
pos = get(figure3, 'Position');

set(figure3, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/rel_automix_vs_rti60_notManuf_', ...
    save_str, '.pdf');
print(figure3, print_pdf_name, '-dpdf', '-r0')



%%
close all
figure4 = figure;

plot_settings_global()
set(gca,'FontSize', set_font_size) % change default font size of axis labels
set(gcf, 'Color', 'w');
box off

scatter(rel_automix_mean(pos_manufact), rti60(pos_manufact), ...
    'Marker', '.', 'MarkerEdgeColor', color3_pick)

hold on
xpush = [min(rel_automix_mean(pos_manufact)), max(rel_automix_mean(pos_manufact))];
mdl = fitlm(rel_automix_mean(pos_manufact), rti60(pos_manufact));
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color1_pick);

ylabel('Share of routine labor 1960')
xlabel('Relative automation index')
set(gca,'TickDir','out')
ylim([0, 1])
xlim([0, 1])


% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', frame_size) % in vector: left bottom width height

set(figure4, 'Units', 'Inches');
pos = get(figure4, 'Position');

set(figure4, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('output/rel_automix_vs_rti60_Manuf_', ...
    save_str, '.pdf');
print(figure4, print_pdf_name, '-dpdf', '-r0')
