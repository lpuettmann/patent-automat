close all
clear all
clc


% Parameters
year_start = 1976;
year_end = 2001;


% Load previously extracted data
load('manclassData.mat')

% % Delete patents from some years 
% ixDelete = 252;
% 
% % Delete entries for patents with those technologies
% manclassData.manAutomat(ixDelete:end) = [];
% manclassData.patentnr(ixDelete:end) = [];
% manclassData.classnr(ixDelete:end) = [];
% manclassData.year(ixDelete:end) = [];
% manclassData.coderID(ixDelete:end) = [];
% manclassData.coderDate(ixDelete:end) = [];
% manclassData.matches(ixDelete:end, :) = []; % this is a matrix
% manclassData.manCognitive(ixDelete:end) = [];
% manclassData.manManual(ixDelete:end) = [];



% Iterate through classification algorithm set-ups
% ========================================================================
ix_keyword = 1;
fprintf('Chosen keyword: <strong>%s</strong>.\n', manclassData.dictionary{ix_keyword})

conttab.nr_alg = 3; % number of algorithms to compare


for i=1:conttab.nr_alg
   
    if i==2
        % Delete those patents with technology numbers some industries
        delete_technr = [423,
                        424,
                        430, % Radiation Imagery Chemistry
                         431, % Combustion
                         435, % Chemistry: Molecular Biology and Microbiology
                         514, % Drug, Bio-affecting and Body Treating Compositions
                         530, % Chemistry: Natural Resins or Derivatives; Peptides or Proteins; ...
                        % 600, % Surgery
                        % 606, % Surgery
                         800]; % Multicellar Living Organisms
                         % also exlude all 530-588

        technr = manclassData.classnr;
        delete_pat_pos = find(ismember(technr, delete_technr));

        del_pat_manual1 = manclassData.patentnr(delete_pat_pos(find(...
            manclassData.manAutomat(delete_pat_pos))));
        
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
        manclassData.manAutomat(delete_pat_pos) = [];
        manclassData.patentnr(delete_pat_pos) = [];
        manclassData.classnr(delete_pat_pos) = [];
        manclassData.year(delete_pat_pos) = [];
        manclassData.coderID(delete_pat_pos) = [];
        manclassData.coderDate(delete_pat_pos) = [];
        manclassData.matches(delete_pat_pos, :) = [];
        manclassData.manCognitive(delete_pat_pos) = [];
        manclassData.manManual(delete_pat_pos) = [];
    end

    
    
    % Compare manual classification with automated keyword search
    if i==3
        % Find patents with at least 2 matches
        computerClass = (manclassData.matches(:, ix_keyword) > 1);
    else
        % Find patents with at least 1 match
        computerClass = (manclassData.matches(:, ix_keyword) > 0);
    end
    

    % Calculate metrics that evaluate the precision of the classification
    % algorithm
    classifstat = calculate_manclass_stats(manclassData.manAutomat, ...
        computerClass, 0.5);
    

    % Errors over time
    for ix_year=year_start:year_end
        t = ix_year - year_start + 1;

        yr_pos = find(ix_year == manclassData.year);

        yr_indic_automat = computerClass(yr_pos);
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
        classifstat.nr_codpt - sum(computerClass), sum(computerClass), classifstat.nr_codpt];

    conttab.stats(:,:,i) = {[length(classifstat.overlap_class), classifstat.nr_codpt - classifstat.sum_automat - length(classifstat.automatic1_manual0), classifstat.nr_codpt, classifstat.accuracy];
        [length(classifstat.overlap_class), sum(computerClass), classifstat.precision];
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
