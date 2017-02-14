% Load our patent and automation patenet indices for SIC industries and 
% compare them to the routine task indices (RTI).

clear all
close all

% Set paths to all underlying directories
setup_path()

% Load industry patent data
load('./output/sic_automix_allyears.mat')


%% Import Routine Task Index (RTI) by Autor, Levy and Murnane (2003)
rti_data = readtable('idata_rti.xlsx');
rti_data.rti60 = rti_data.rti60 / 100; % from percentage to share

[sic_list, ~, ix_map] = unique( sic_automix_allyears.sic );

sic_automix_allyears.rti60 = nan( size( sic_automix_allyears.sic ) );

for i=1:length(sic_list)
    sic_pick = sic_list(i);    
    ix_extr = find( sic_pick == rti_data.sic );    
    assert( length(ix_extr) <= 1)
    
    sic_summary(i, 2) = sic_pick;
    if isempty( ix_extr ) 
        sic_summary(i, 2) = NaN;
    else
        sic_summary(i, 2) = rti_data.rti60(ix_extr);
    end
    
    ix_insert = find( ix_map == i );
    
    for j=1:length(ix_insert)
        sic_automix_allyears.rti60(ix_insert(j)) = sic_summary(i, 2);
    end
end


%% Insert the relative automation index in the table
sic_automix_allyears.rel_automix = sic_automix_allyears.automix_use ./ ...
    sic_automix_allyears.patents_use;


%% Create CSV file with the full SIC industry year observations
% tic
%disp('Start writing SIC automation indices to .csv:')
% writetable(sic_automix_allyears, './output/sic_automix_allyears.csv')
% toc


%% Industries vs. RTI

plot_settings_global()

per = [1976, 2014;
       1976, 1985;
       1986, 1995;
       1996, 2005;
       2006, 2014];
   
for t = 1:size(per, 1)
    year_start = per(t, 1);
    year_end = per(t, 2);

    ixYears = (sic_automix_allyears.year >= year_start) & ...
        (sic_automix_allyears.year <= year_end);

    sicTab = sic_automix_allyears(ixYears, :);


    %% Get summary statistics for all years
    rti_sub = rti_data;
    
    for i=1:length(rti_sub.sic)

        ix_pick = ( sicTab.sic == rti_sub.sic(i) );

        % All years
        % -------------------------------------------------------------
        rti_sub.automix_use_sum(i) = sum( ...
            sicTab.automix_use(ix_pick) );  

        rti_sub.automix_use_log_sum(i) = log( 1 + sum( ...
            sicTab.automix_use(ix_pick) ) );   

        rti_sub.rel_automix_mean(i, 1) = mean( ...
            sicTab.rel_automix(ix_pick) );     

        % Save an indicator of whether this SIC is in manufacturing
        pick_overcat = sicTab.overcat( ix_pick );
        rti_sub.ix_manufact(i, 1) = +strcmp( pick_overcat{1}, 'D');
    end

    if sum(rti_sub.ix_manufact) ~= 454
        assert('Not correct number of manufacturing industries.')
    end
    
    if (year_start == 1976) && (year_end == 2014)
        rti_data.automix_use_log_sum_7614 = rti_sub.automix_use_log_sum;
    elseif (year_start == 1976) && (year_end == 1985)
        rti_data.automix_use_log_sum_7685 = rti_sub.automix_use_log_sum;
    elseif (year_start == 1986) && (year_end == 1995)
        rti_data.automix_use_log_sum_8695 = rti_sub.automix_use_log_sum;
    elseif (year_start == 1996) && (year_end == 2005)
        rti_data.automix_use_log_sum_9605 = rti_sub.automix_use_log_sum;
    elseif (year_start == 2006) && (year_end == 2014)
        rti_data.automix_use_log_sum_0614 = rti_sub.automix_use_log_sum;
    end
    

    %% Analyze
    pos_manufact = find( rti_sub.ix_manufact );
    pos_other_ind = find( not( rti_sub.ix_manufact ) );

    % Correlations
    fprintf('Corr. number automation patents with RTI: %3.3f.\n', ...
        corr(rti_sub.automix_use_sum, rti_sub.rti60, 'rows', 'complete'))
    fprintf('Corr. log(automation patents) with RTI: %3.2f.\n', ...
        corr(rti_sub.automix_use_log_sum, rti_sub.rti60, 'rows', 'complete'))
    fprintf('Corr. relative automation index with RTI: %3.2f.\n', ...
        corr(rti_sub.rel_automix_mean, rti_sub.rti60, 'rows', 'complete'))

    figure1 = figure;

    subplot(2, 2, 1)
    scatter(rti_sub.automix_use_sum, rti_sub.rti60, ...
        'Marker', '.', 'MarkerEdgeColor', color3_pick)
    ylabel('Share of routine labor 1960')
    xlabel('Number automation patents')
    ylim([0, 1])

    subplot(2, 2, 2)
    scatter(rti_sub.automix_use_log_sum(pos_manufact), ...
        rti_sub.rti60(pos_manufact), 'Marker', '.', 'MarkerEdgeColor', ...
        color5_pick)
    hold on
    xpush = [min(rti_sub.automix_use_log_sum(pos_manufact)), ...
        max(rti_sub.automix_use_log_sum(pos_manufact))];
    mdl = fitlm(rti_sub.automix_use_log_sum(pos_manufact), rti_sub.rti60(pos_manufact));
    plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
        'LineWidth', 1, 'Color', color5_pick);
    hold on
    scatter(rti_sub.automix_use_log_sum(pos_other_ind), ...
        rti_sub.rti60(pos_other_ind), 'Marker', '.', 'MarkerEdgeColor', ...
        color4_pick)
    hold on
    xpush = [min(rti_sub.automix_use_log_sum(pos_other_ind)), ...
        max(rti_sub.automix_use_log_sum(pos_other_ind))];
    mdl = fitlm(rti_sub.automix_use_log_sum(pos_other_ind), rti_sub.rti60(pos_other_ind));
    plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
        'LineWidth', 1, 'Color', color4_pick);
    ylabel('Share of routine labor 1960')
    xlabel('log(automation patents)')
    ylim([0, 1])

    subplot(2, 2, 3)
    scatter(rti_sub.rel_automix_mean, rti_sub.rti60, ...
        'Marker', '.', 'MarkerEdgeColor', color3_pick)
    hold on
    xpush = [min(rti_sub.rel_automix_mean), max(rti_sub.rel_automix_mean)];
    mdl = fitlm(rti_sub.rel_automix_mean, rti_sub.rti60);
    plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
        'LineWidth', 1, 'Color', color1_pick);
    ylabel('Share of routine labor 1960')
    xlabel('Mean relative automation index')
    ylim([0, 1])

    subplot(2, 2, 4)
    scatter(rti_sub.rel_automix_mean(pos_manufact), rti_sub.rti60(pos_manufact), ...
        'Marker', '.', 'MarkerEdgeColor', color5_pick)
    hold on
    xpush = [min(rti_sub.rel_automix_mean(pos_manufact)), max(rti_sub.rel_automix_mean(pos_manufact))];
    mdl = fitlm(rti_sub.rel_automix_mean(pos_manufact), rti_sub.rti60(pos_manufact));
    plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
        'LineWidth', 1, 'Color', color5_pick);
    hold on
    scatter(rti_sub.rel_automix_mean(pos_other_ind), rti_sub.rti60(pos_other_ind), ...
        'Marker', '.', 'MarkerEdgeColor', color4_pick)
    hold on
    xpush = [min(rti_sub.rel_automix_mean(pos_other_ind)), max(rti_sub.rel_automix_mean(pos_other_ind))];
    mdl = fitlm(rti_sub.rel_automix_mean(pos_other_ind), rti_sub.rti60(pos_other_ind));
    plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
        'LineWidth', 1, 'Color', color4_pick);

    ylabel('Share of routine labor 1960')
    xlabel('Mean relative automation index')
    ylim([0, 1])


    % Reposition the figure and export to pdf
    set(gcf, 'Position', [100 200 800 500]) % in vector: left bottom width height
    set(figure1, 'Units', 'Inches');
    pos = get(figure1, 'Position');
    set(figure1, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
        'Inches', 'PaperSize', [pos(3), pos(4)])

    print_pdf_name = horzcat('output/automix_vs_rti60_comb_', ...
        num2str(year_start), '-', num2str(year_end), '.pdf');
    print(figure1, print_pdf_name, '-dpdf', '-r0')
    fprintf('Saved: %s.\n', print_pdf_name)
    fprintf('\n')
end


%% One figure across decades
corr(rti_data.automix_use_log_sum_7685, rti_data.rti60, 'rows', 'complete')
corr(rti_data.automix_use_log_sum_8695, rti_data.rti60, 'rows', 'complete')
corr(rti_data.automix_use_log_sum_9605, rti_data.rti60, 'rows', 'complete')
corr(rti_data.automix_use_log_sum_0614, rti_data.rti60, 'rows', 'complete')

figure2 = figure;

subplot(2, 2, 1)
scatter(rti_data.automix_use_log_sum_7685, ...
    rti_data.rti60, 'Marker', '.', 'MarkerEdgeColor', ...
    color3_pick)
hold on
xpush = [min(rti_data.automix_use_log_sum_7685), ...
    max(rti_data.automix_use_log_sum_7685)];
mdl = fitlm(rti_data.automix_use_log_sum_7685, rti_data.rti60);
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color3_pick);
ylabel('Share of routine labor 1960')
xlabel('log(automation patents)')
ylim([0, 1])

subplot(2, 2, 2)
scatter(rti_data.automix_use_log_sum_8695, ...
    rti_data.rti60, 'Marker', '.', 'MarkerEdgeColor', ...
    color3_pick)
hold on
xpush = [min(rti_data.automix_use_log_sum_8695), ...
    max(rti_data.automix_use_log_sum_8695)];
mdl = fitlm(rti_data.automix_use_log_sum_8695, rti_data.rti60);
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color3_pick);
ylabel('Share of routine labor 1960')
xlabel('log(automation patents)')
ylim([0, 1])

subplot(2, 2, 3)
scatter(rti_data.automix_use_log_sum_9605, ...
    rti_data.rti60, 'Marker', '.', 'MarkerEdgeColor', ...
    color3_pick)
hold on
xpush = [min(rti_data.automix_use_log_sum_9605), ...
    max(rti_data.automix_use_log_sum_9605)];
mdl = fitlm(rti_data.automix_use_log_sum_9605, rti_data.rti60);
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color3_pick);
ylabel('Share of routine labor 1960')
xlabel('log(automation patents)')
ylim([0, 1])

subplot(2, 2, 4)
scatter(rti_data.automix_use_log_sum_0614, ...
    rti_data.rti60, 'Marker', '.', 'MarkerEdgeColor', ...
    color3_pick)
hold on
xpush = [min(rti_data.automix_use_log_sum_0614), ...
    max(rti_data.automix_use_log_sum_0614)];
mdl = fitlm(rti_data.automix_use_log_sum_0614, rti_data.rti60);
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color3_pick);
ylabel('Share of routine labor 1960')
xlabel('log(automation patents)')
ylim([0, 1])
hold off


% Reposition the figure and export to pdf
set(gcf, 'Position', [100 200 800 500]) % in vector: left bottom width height
set(figure2, 'Units', 'Inches');
pos = get(figure2, 'Position');
set(figure2, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

print_pdf_name = horzcat('output/automix_vs_rti60_decades.pdf');
print(figure2, print_pdf_name, '-dpdf', '-r0')
fprintf('Saved: %s.\n', print_pdf_name)


%%
figure3 = figure;
scatter(rti_data.automix_use_log_sum_7614, ...
    rti_data.rti60, 'Marker', '.', 'MarkerEdgeColor', ...
    color3_pick)
hold on
xpush = [min(rti_data.automix_use_log_sum_7614), ...
    max(rti_data.automix_use_log_sum_7614)];
mdl = fitlm(rti_data.automix_use_log_sum_7614, rti_data.rti60);
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color1_pick);
ylabel('Share of routine labor 1960')
xlabel('log(automation patents)')
ylim([0, 1])
set(gca,'TickDir','out'); 

% Reposition the figure and export to pdf
set(gcf, 'Position', [100 200 350 250]) % in vector: left bottom width height
set(figure3, 'Units', 'Inches');
pos = get(figure3, 'Position');
set(figure3, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])

print_pdf_name = horzcat('output/lautopats_rti60_7614.pdf');
print(figure3, print_pdf_name, '-dpdf', '-r0')
fprintf('Saved: %s.\n', print_pdf_name)

