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


%% Get summary statistics for all years
for i=1:length(rti_data.sic)
    
    ix_pick = ( sic_automix_allyears.sic == rti_data.sic(i) );
    
    % All years
    % -------------------------------------------------------------
    rti_data.automix_use_sum(i) = sum( ...
        sic_automix_allyears.automix_use(ix_pick) );  
    
    rti_data.automix_use_log_sum(i) = log( sum( ...
        sic_automix_allyears.automix_use(ix_pick) ) );   
       
    rti_data.rel_automix_mean(i, 1) = mean( ...
        sic_automix_allyears.rel_automix(ix_pick) );   
    
    % Subperiods
    % -------------------------------------------------------------
    ix_year = ( sic_automix_allyears.year <= 1998 ); 
    
    ix_pre1998 = ( ix_pick & ix_year );
    ix_post1998 = ( ix_pick & not(ix_year) );
    
    assert(isequal(ix_pre1998 + ix_post1998, ix_pick), 'Should be equal.')
    
    % Totals
    rti_data.automix_use_sum_pre1998(i) = sum( ...
        sic_automix_allyears.automix_use(ix_pre1998) );   
    
    rti_data.automix_use_sum_post1998(i) = sum( ...
        sic_automix_allyears.automix_use(ix_post1998)); 
    
    % Absolute log
    rti_data.automix_use_log_sum_pre1998(i) = log( sum( ...
        sic_automix_allyears.automix_use(ix_pre1998) ) );   
    
    rti_data.automix_use_log_sum_post1998(i) = log( sum( ...
        sic_automix_allyears.automix_use(ix_post1998) ) ); 
    
    % Relative mean    
    rti_data.rel_automix_mean_pre1998(i, 1) = mean( ...
        sic_automix_allyears.rel_automix(ix_pre1998) );   
    
    rti_data.rel_automix_mean_post1998(i, 1) = mean( ...
        sic_automix_allyears.rel_automix(ix_post1998) );   
    
    % Save an indicator of whether this SIC is in manufacturing
    pick_overcat = sic_automix_allyears.overcat( ix_pick );
    rti_data.ix_manufact(i, 1) = +strcmp( pick_overcat{1}, 'D');
    
    clear ix_year ix_pre1998 ix_post1998
    
    fprintf('[%d/%d] Finished SIC: %d.\n', i, length(rti_data.sic), ...
        rti_data.sic(i))
end


if sum(rti_data.ix_manufact) ~= 454
    warning('Not correct number of manufacturing industries.')
end

%% Analyze
pos_manufact = find( rti_data.ix_manufact );
pos_other_ind = find( not( rti_data.ix_manufact ) );


% Correlations
fprintf('Corr. number automation patents with RTI: %3.3f.\n', ...
    corr(rti_data.automix_use_sum, rti_data.rti60, 'rows', 'complete'))
fprintf('Corr. log(automation patents) with RTI: %3.2f.\n', ...
    corr(rti_data.automix_use_log_sum, rti_data.rti60, 'rows', 'complete'))
fprintf('Corr. relative automation index with RTI: %3.2f.\n', ...
    corr(rti_data.rel_automix_mean, rti_data.rti60, 'rows', 'complete'))

% Make scatter plots
close all

plot_settings_global()

figure1 = figure;

subplot(2, 2, 1)
scatter(rti_data.automix_use_sum, rti_data.rti60, ...
    'Marker', '.', 'MarkerEdgeColor', color3_pick)
ylabel('Share of routine labor 1960')
xlabel('Number automation patents')
ylim([0, 1])

subplot(2, 2, 2)
scatter(rti_data.automix_use_log_sum(pos_manufact), ...
    rti_data.rti60(pos_manufact), 'Marker', '.', 'MarkerEdgeColor', ...
    color5_pick)
hold on
xpush = [min(rti_data.automix_use_log_sum(pos_manufact)), ...
    max(rti_data.automix_use_log_sum(pos_manufact))];
mdl = fitlm(rti_data.automix_use_log_sum(pos_manufact), rti_data.rti60(pos_manufact));
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color5_pick);
hold on
scatter(rti_data.automix_use_log_sum(pos_other_ind), ...
    rti_data.rti60(pos_other_ind), 'Marker', '.', 'MarkerEdgeColor', ...
    color4_pick)
hold on
xpush = [min(rti_data.automix_use_log_sum(pos_other_ind)), ...
    max(rti_data.automix_use_log_sum(pos_other_ind))];
mdl = fitlm(rti_data.automix_use_log_sum(pos_other_ind), rti_data.rti60(pos_other_ind));
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color4_pick);
ylabel('Share of routine labor 1960')
xlabel('log(automation patents)')
ylim([0, 1])

subplot(2, 2, 3)
scatter(rti_data.rel_automix_mean, rti_data.rti60, ...
    'Marker', '.', 'MarkerEdgeColor', color3_pick)
hold on
xpush = [min(rti_data.rel_automix_mean), max(rti_data.rel_automix_mean)];
mdl = fitlm(rti_data.rel_automix_mean, rti_data.rti60);
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color1_pick);
ylabel('Share of routine labor 1960')
xlabel('Mean relative automation index')
ylim([0, 1])

subplot(2, 2, 4)
scatter(rti_data.rel_automix_mean(pos_manufact), rti_data.rti60(pos_manufact), ...
    'Marker', '.', 'MarkerEdgeColor', color5_pick)
hold on
xpush = [min(rti_data.rel_automix_mean(pos_manufact)), max(rti_data.rel_automix_mean(pos_manufact))];
mdl = fitlm(rti_data.rel_automix_mean(pos_manufact), rti_data.rti60(pos_manufact));
plot(xpush, mdl.Coefficients{1,1} + xpush * mdl.Coefficients{2,1}, ...
    'LineWidth', 1, 'Color', color5_pick);
hold on
scatter(rti_data.rel_automix_mean(pos_other_ind), rti_data.rti60(pos_other_ind), ...
    'Marker', '.', 'MarkerEdgeColor', color4_pick)
hold on
xpush = [min(rti_data.rel_automix_mean(pos_other_ind)), max(rti_data.rel_automix_mean(pos_other_ind))];
mdl = fitlm(rti_data.rel_automix_mean(pos_other_ind), rti_data.rti60(pos_other_ind));
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
print_pdf_name = horzcat('output/automix_vs_rti60_comb.pdf');
print(figure1, 'output/automix_vs_rti60_comb.pdf', '-dpdf', '-r0')



