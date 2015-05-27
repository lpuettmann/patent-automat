close all
clear all
clc



% Load excel file
[manclass_data, txt, ~] = xlsread('manclass_consolidated.xlsx');


% Figure out how many patents have been classified yet
indic_automat = manclass_data(:, 3);


if any(not((indic_automat == 1) | (indic_automat == 0)))
    warning('There should be only 0 and 1 here.')
end


last_codpt = find(isnan(indic_automat), 1) - 1;

if not(isempty(last_codpt))
    % Truncate until last coded patent
    indic_automat = indic_automat(1:last_codpt);
    manclass_data = manclass_data(1:last_codpt, :);
    
    warning('TRUNCATING SAMPLE.')
end


% Check if there any NaN's left in the vector of classifications
if any(isnan(indic_automat))
    fprintf('Some patents not classified (NaN): %d.\n', ...
        find(isnan(indic_automat)))
end


nr_codpt = length(indic_automat);
sum_automat = sum(indic_automat);
share_automat = sum_automat / nr_codpt;


% Compare manual classification with automated keyword search
nr_keyword_find = manclass_data(:, 7); % extract number of keyword matches
% Find patents with at least 1 match
pat_1match = (nr_keyword_find > 0); % the plus converts logical to double 

pos_manclass_automat = find(indic_automat);
pos_pat_1match = find(pat_1match);

% Calculate the overall agreement rate
agree_rate = sum(indic_automat == pat_1match) / nr_codpt;

complete_class = union(pos_pat_1match, pos_manclass_automat);
overlap_class = intersect(pos_pat_1match, pos_manclass_automat);
differ_class = setdiff(complete_class, overlap_class);

manual1_automatic0 = setdiff(pos_manclass_automat, pos_pat_1match);
automatic1_manual0 = setdiff(pos_pat_1match, pos_manclass_automat);


fprintf('___________________________________________________________\n');
fprintf('<strong>Comparison of manual and automatical patent classification</strong>\n');
fprintf('  \n')

fprintf('Number patents manually coded: %d.\n', ...
    nr_codpt)
fprintf('Of those manually classified as automation patents: %d (%3.2f).\n', ...
   sum_automat, share_automat)
fprintf('Of those automatically classified as automation patents: %d (%3.2f).\n', ...
   sum(pat_1match), sum(pat_1match) / nr_codpt)

fprintf('Overall agreement: %d/%d (%3.2f).\n', ...
    sum(indic_automat == pat_1match), nr_codpt, agree_rate)
fprintf('Same classifications: %d/%d (%3.2f).\n', length(overlap_class), ...
    length(complete_class), length(overlap_class) / length(complete_class))
fprintf('manual1_automatic0: %d.\n', length(manual1_automatic0))
fprintf('automatic1_manual0: %d.\n', length(automatic1_manual0))


fprintf('Differing classifications: %d/%d (%3.2f).\n', length(differ_class), ...
    length(complete_class), length(differ_class) / length(complete_class))



% Analyze those patents that were manually classified as automation patents
matches_manclasspt = nr_keyword_find(pos_manclass_automat);
matches_rest = nr_keyword_find(not(indic_automat));


%% Save contingency table to .tex

% Print to .txt file in Latex format
printname = 'table_contingency_classfc.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Manual vs. computerized classification}}\n');
fprintf(FID,'\\begin{tabular}{ll|ll|l}\n');

fprintf(FID, '& \\multicolumn{4}{c}{Computerized} \\tabularnewline[0.1cm]\n');
fprintf(FID, '& & No & Yes &   \\tabularnewline\n');
fprintf(FID, '\\cline{2-5}\n');
fprintf(FID, '\\parbox[t]{2mm}{\\multirow{2}{*}{\\rotatebox[origin=c]{90}{Manual}}} & No & %d & %d & %d \\tabularnewline\n', nr_codpt - sum_automat - length(automatic1_manual0), length(automatic1_manual0), nr_codpt - sum_automat);
fprintf(FID, '& Yes & %d & %d & %d \\tabularnewline\n', length(manual1_automatic0), sum_automat - length(manual1_automatic0), sum_automat);
fprintf(FID, '\\cline{2-5}\n');
fprintf(FID, '&  & %d & %d & %d \\tabularnewline\n', nr_codpt - sum(pat_1match), sum(pat_1match), nr_codpt);


fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 

fprintf('___________________________________________________________\n');
fprintf('Saved: %s.\n', printname)



%% Errors over time
year_start = 1976;
year_end = 2015;


% Extract
for ix_year=year_start:year_end
    t = ix_year - year_start + 1;
    
    yr_pos = find(ix_year == manclass_data(:, 2));
    
    yr_indic_automat = manclass_data(yr_pos, 3);
    yr_pat_1match = manclass_data(yr_pos, end)>0;
    
    classifstat.number(t) = length(yr_pos);
    classifstat.summanclass(t) = sum(yr_indic_automat);
    classifstat.sumpat1match(t) = sum(yr_pat_1match);
    classifstat.agreerate(t) = sum(yr_indic_automat==yr_pat_1match) / ...
        length(yr_pos);
    classifstat.manautom(t) = sum(yr_indic_automat) / length(yr_pos);
    classifstat.compautom(t) = sum(yr_pat_1match) / length(yr_pos);
end


%% Plausibility checks
if abs(mean(classifstat.manautom) - share_automat) > 0.1 * mean(classifstat.manautom)
    warning('Quite different.')
end

if abs(mean(classifstat.compautom) - (sum(pat_1match) / nr_codpt)) > 0.1 * mean(classifstat.compautom)
    warning('Quite different.')
end



%% Make plot

% Define some plot settings
plottime = year_start:year_end;
my_gray = [0.806, 0.806, 0.806];
my_dark_gray = [0.3, 0.3, 0.3];


figHandle = figure;
set(gcf,'color','w');

subplot(3,1,1)
plot(plottime, classifstat.number)
box off
hold on
plot(plottime, classifstat.summanclass, 'Color', 'red')
hold on
plot(plottime, classifstat.sumpat1match, 'Color', 'green')
box off
legend('Total number', 'Manually classified as automation', ...
    'Computer classified as automation')
set(gca, 'TickDir', 'out')

subplot(3,1,2)
plot(plottime, classifstat.manautom, 'Color', 'red')
hold on
plot(plottime, classifstat.compautom, 'Color', 'green')
box off
legend('Share manually classified as automation', ...
    'Share computer classified as automation')
ylim([0, 1])
put_in_title = horzcat('Correlation: ', num2str(round(corr(...
    classifstat.manautom', classifstat.compautom')*100)/100));
title(put_in_title)
set(gca, 'TickDir', 'out')


subplot(3,1,3)
h_gline = plot(plottime, repmat(0.8, ...
    length(plottime), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on

h_gline = plot(plottime, repmat(0.6, ...
    length(plottime), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on

h_gline = plot(plottime, repmat(0.4, ...
    length(plottime), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on

h_gline = plot(plottime, repmat(0.2, ...
    length(plottime), 1), 'Color', my_gray , ...
    'linewidth', 0.5);
uistack(h_gline, 'bottom');
hold on

scatter(plottime, classifstat.agreerate, 3, ...
    'Marker', 'o', 'MarkerEdgeColor', my_dark_gray, ...
    'MarkerFaceColor', my_dark_gray)
hold on
plot(plottime, hpfilter(classifstat.agreerate, 5), 'Color', my_dark_gray)
title('Agreement rate')
box off
ylim([0, 1])
set(gca, 'TickDir', 'out')
xlim([year_start, year_end])











