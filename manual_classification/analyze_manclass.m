close all
clear all
clc

addpath('../functions')

% Parameters
year_start = 1976;
year_end = 2015;



% Iterate through classification algorithm set-ups
% ========================================================================

conttab.nr_alg = 3; % number of algorithms to compare

for i=1:conttab.nr_alg

    % Load previously extracted data
    load('manclass_data.mat')
    
    if i==2
        % Delete those patents with technology numbers some industries
        delete_technr = [430, % Radiation Imagery Chemistry
                         431, % Combustion
                         435, % Chemistry: Molecular Biology and Microbiology
                         514, % Drug, Bio-affecting and Body Treating Compositions
                         530, % Chemistry: Natural Resins or Derivatives; Peptides or Proteins; ...
                        % 600, % Surgery
                        % 606, % Surgery
                         800]; % Multicellar Living Organisms

        technr = manclass_data(:, 8);
        delete_pat_pos = find(ismember(technr, delete_technr));

        del_pat = manclass_data(delete_pat_pos, :);
        del_pat_manual1 = find(del_pat(:, 3));
        del_pat_automatic1 = find(del_pat(:, 7)>0);
        del_pat_manual1_automatic1 = intersect(del_pat_manual1, del_pat_automatic1);
        del_pat_manual1_automatic0 = setdiff(del_pat_manual1, del_pat_automatic1);
        del_pat_automatic1_manual0 = setdiff(del_pat_automatic1, del_pat_manual1);

        fprintf('___________________________________________________________\n');
        fprintf('<strong>Discarded technologies</strong>\n');
        fprintf(' \n')
        fprintf('Delete %d/%d (%3.2f) patents.\n', length(delete_pat_pos), ...
            size(manclass_data, 1), length(delete_pat_pos)/size(manclass_data, 1))
        fprintf('Of those: \n')
        fprintf('\t %d = manual: 1, automatic: 1.\n', length(del_pat_manual1_automatic1))
        fprintf('\t %d = manual: 1, automatic: 0.\n', length(del_pat_manual1_automatic0))
        fprintf('\t %d = automatic: 1, manual: 0.\n', length(del_pat_automatic1_manual0))
        fprintf(' ')

        manclass_data(delete_pat_pos, :) = [];
    else
        manclass_data = manclass_data;
    end

    % Transform variables

    % Figure out how many patents have been classified yet
    indic_automat = manclass_data(:, 3);

    classifstat.nr_codpt = length(indic_automat);
    classifstat.sum_automat = sum(indic_automat);
    share_automat = classifstat.sum_automat / classifstat.nr_codpt;


    % Compare manual classification with automated keyword search
    nr_keyword_find = manclass_data(:, 7); % extract number of keyword matches
    
    if i==3
        % Find patents with at least 2 matches
        classifstat.pat_1match = (nr_keyword_find > 1); % the plus converts logical to double 
    else
        % Find patents with at least 1 match
        classifstat.pat_1match = (nr_keyword_find > 0); % the plus converts logical to double 
    end
    
    pos_manclass_automat = find(indic_automat);
    pos_pat_1match = find(classifstat.pat_1match);


    % Calculate area under curve (AUROC)
    % -------------------------------------------------------------------
    classifstat.auc = calculate_auc(indic_automat, classifstat.pat_1match);


    % Calculate the overall agreement rate

    % For  definitions of evaluation measures (accuracy, precision, recall,
    % fmeasure...), see:
    %   Manning, Raghavan, Schütze "Introduction to Information Retrieval",
    %   first edition (2008), section "8. Evaluation in information retrieval"

    classifstat.accuracy = sum(indic_automat == classifstat.pat_1match) / classifstat.nr_codpt;
    complete_class = union(pos_pat_1match, pos_manclass_automat);
    classifstat.overlap_class = intersect(pos_pat_1match, pos_manclass_automat);
    differ_class = setdiff(complete_class, classifstat.overlap_class);

    classifstat.precision = length(classifstat.overlap_class) / sum(classifstat.pat_1match);
    classifstat.recall = length(classifstat.overlap_class) / classifstat.sum_automat;

    classifstat.evalalpha = 1/2; % alpha
    classifstat.evalbeta_squared = (1 - classifstat.evalalpha) / classifstat.evalalpha; % beta squared

    classifstat.fmeasure = ((classifstat.evalbeta_squared + 1) * classifstat.precision * ...
        classifstat.recall) / (classifstat.evalbeta_squared * classifstat.precision + ...
        classifstat.recall);


    classifstat.manual1_automatic0 = setdiff(pos_manclass_automat, pos_pat_1match);
    classifstat.automatic1_manual0 = setdiff(pos_pat_1match, pos_manclass_automat);


    classifstat.patents_automatic1_manual0 = manclass_data(...
        classifstat.automatic1_manual0, :);


    % Analyze those patents that were manually classified as automation patents
    matches_manclasspt = nr_keyword_find(pos_manclass_automat);
    matches_rest = nr_keyword_find(not(indic_automat));



    % Errors over time
    % -------------------------------------------------------------------

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


    % Plausibility checks
    % -------------------------------------------------------------------
    if abs(mean(classifstat.manautom) - share_automat) > 0.1 * mean(classifstat.manautom)
        warning('Quite different.')
    end

    if abs(mean(classifstat.compautom) - (sum(classifstat.pat_1match) / classifstat.nr_codpt)) > 0.1 * mean(classifstat.compautom)
        warning('Quite different.')
    end


    % Save to .mat file
    % -------------------------------------------------------------------
    save_name = 'classifstat.mat';
    save(save_name, 'classifstat');    
    fprintf('Saved: %s.\n', save_name)


    % Put into format to be put in contingency table
    % -------------------------------------------------------------------
    conttab.val(:,:,i) = [classifstat.nr_codpt - classifstat.sum_automat - length(classifstat.automatic1_manual0), length(classifstat.automatic1_manual0), classifstat.nr_codpt - classifstat.sum_automat;
        length(classifstat.manual1_automatic0), classifstat.sum_automat - length(classifstat.manual1_automatic0), classifstat.sum_automat;
        classifstat.nr_codpt - sum(classifstat.pat_1match), sum(classifstat.pat_1match), classifstat.nr_codpt];

    conttab.stats(:,:,i) = {[length(classifstat.overlap_class), classifstat.nr_codpt - classifstat.sum_automat - length(classifstat.automatic1_manual0), classifstat.nr_codpt, classifstat.accuracy];
        [length(classifstat.overlap_class), sum(classifstat.pat_1match), classifstat.precision];
        [length(classifstat.overlap_class),  classifstat.sum_automat, classifstat.recall];
        [sqrt(classifstat.evalbeta_squared), classifstat.fmeasure];
        classifstat.auc};
end

% Save to .mat file
% -------------------------------------------------------------------
save_name = 'conttab.mat';
save(save_name, 'conttab');    
fprintf('Saved: %s.\n', save_name)
