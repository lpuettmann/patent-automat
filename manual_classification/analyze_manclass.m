close all
clear all
clc


% Parameters
year_start = 1976;
year_end = 1990;



% Iterate through classification algorithm set-ups
% ========================================================================

conttab.nr_alg = 3; % number of algorithms to compare

for i=1:conttab.nr_alg

    % Load previously extracted data
    load('manclassData.mat')
    
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

        technr = manclassData.classnr;
        delete_pat_pos = find(ismember(technr, delete_technr));

        del_pat_manual1 = manclassData.patentnr(delete_pat_pos(find(...
            manclassData.manClass(delete_pat_pos))));
        
        del_pat_automatic1 = manclassData.patentnr(delete_pat_pos(find(...
            manclassData.matches(delete_pat_pos) > 0)));
       
        del_pat_manual1_automatic1 = intersect(del_pat_manual1, del_pat_automatic1);
        del_pat_manual1_automatic0 = setdiff(del_pat_manual1, del_pat_automatic1);
        del_pat_automatic1_manual0 = setdiff(del_pat_automatic1, del_pat_manual1);

        fprintf('___________________________________________________________\n');
        fprintf('<strong>Discarded technologies</strong>\n');
        fprintf(' \n')
        fprintf('Delete %d/%d (%3.2f) patents.\n', length(delete_pat_pos), ...
            size(manclassData.patentnr, 1), length(delete_pat_pos)/...
            size(manclassData.patentnr, 1))
        fprintf('Of those: \n')
        fprintf('\t %d = manual: 1, automatic: 1.\n', length(del_pat_manual1_automatic1))
        fprintf('\t %d = manual: 1, automatic: 0.\n', length(del_pat_manual1_automatic0))
        fprintf('\t %d = automatic: 1, manual: 0.\n', length(del_pat_automatic1_manual0))
        disp(' ')

        % Delete entries for patents with those technologies
        manclassData.indic_automat(delete_pat_pos) = [];
        manclassData.patentnr(delete_pat_pos) = [];
        manclassData.classnr(delete_pat_pos) = [];
        manclassData.year(delete_pat_pos) = [];
        manclassData.coderID(delete_pat_pos) = [];
        manclassData.coderDate(delete_pat_pos) = [];
        manclassData.matches(delete_pat_pos) = [];
        manclassData.manClass(delete_pat_pos) = [];
        manclassData.manCognitive(delete_pat_pos) = [];
        manclassData.manManual(delete_pat_pos) = [];
    end

    
    % Transform variables
    classifstat.nr_codpt = length(manclassData.indic_automat);
    classifstat.sum_automat = sum(manclassData.indic_automat);
    share_automat = classifstat.sum_automat / classifstat.nr_codpt;


    % Compare manual classification with automated keyword search
    if i==3
        % Find patents with at least 2 matches
        classifstat.pat_1match = (manclassData.matches > 1);
    else
        % Find patents with at least 1 match
        classifstat.pat_1match = (manclassData.matches > 0);
    end
    
    pos_manclass_automat = find(manclassData.indic_automat);
    pos_pat_1match = find(classifstat.pat_1match);


    % Calculate area under curve (AUROC)
    % -------------------------------------------------------------------
    classifstat.auc = calculate_auc(manclassData.indic_automat, ...
        classifstat.pat_1match);


    % Calculate the overall agreement rate

    % For  definitions of evaluation measures (accuracy, precision, recall,
    % fmeasure...), see:
    %   Manning, Raghavan, Sch�tze "Introduction to Information Retrieval",
    %   first edition (2008), section "8. Evaluation in information retrieval"

    classifstat.accuracy = sum(manclassData.manClass == classifstat.pat_1match) / classifstat.nr_codpt;
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


    % Analyze those patents that were manually classified as automation patents
    matches_manclasspt = manclassData.matches(pos_manclass_automat);
    matches_rest = manclassData.matches(not(manclassData.indic_automat));



    % Errors over time
    % -------------------------------------------------------------------

    % Extract
    for ix_year=year_start:year_end
        t = ix_year - year_start + 1;

        yr_pos = find(ix_year == manclassData.year);

        yr_indic_automat = manclassData.manClass(yr_pos);
        yr_pat_1match = manclassData.matches(yr_pos)>0;

        classifstat.number(t) = length(yr_pos);
        classifstat.summanclass(t) = sum(yr_indic_automat);
        classifstat.sumpat1match(t) = sum(yr_pat_1match);
        classifstat.agreerate(t) = sum(yr_indic_automat==yr_pat_1match) / ...
            length(yr_pos);
        classifstat.manautom(t) = sum(yr_indic_automat) / length(yr_pos);
        classifstat.compautom(t) = sum(yr_pat_1match) / length(yr_pos);
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

    fprintf('Finished algorithm: %d.\n', i)
    disp('.............................................................')
end

% Save to .mat file
% -------------------------------------------------------------------
save_name = 'conttab.mat';
save(save_name, 'conttab');    
fprintf('Saved: %s.\n', save_name)
