close all
clear all
clc



addpath('functions');
addpath('patent_index');
addpath('matches');
addpath('cleaned_matches');

% Correct files of patent index
% for ix_year = 1977:1977
%     
%     build_load_filename = horzcat('patent_index_', num2str(ix_year), ...
%         '.mat');
% 
%     load(build_load_filename)
% 
%     for ix_week=1:size(pat_ix, 1)
%         class_number = pat_ix{ix_week, 3};
% 
%         % Keep only the first 3 digits
%         class_number = cellfun(@(s) s(1:3), class_number, 'uni', ...
%             false);
% 
%         pat_ix{ix_week, 3} = class_number;
%     end
%     
%     
%     % Save to .mat file
%     % -------------------------------------------------------------------
%     save_name = horzcat('patent_index_', num2str(ix_year), '.mat');
%     matfile_path_save = fullfile('patent_index', save_name);
%     save(matfile_path_save, 'pat_ix');    
%     fprintf('Saved: %s.\n', save_name)
%     
%     fprintf('Year %d finished.\n', ix_year)
%     disp('---------------------------------------------------------------')
% end


% % Correct files of keyword matches
% for ix_year = 1978:2014
%     
%     build_load_filename = horzcat('patent_keyword_appear_', num2str(ix_year), ...
%         '.mat');
% 
%     load(build_load_filename)
% 
%     class_number = patent_keyword_appear(:, 3);
% 
%     cleaned_patent_tech_class = strtrim(class_number);
%     
%     trunc_tech_class = repmat({''}, length(cleaned_patent_tech_class), 1);
%     
%     % Keep only the first 3 digits
%     for i=1:length(cleaned_patent_tech_class)
%         pick = cleaned_patent_tech_class{i};
%         
%         if numel(pick)>=3
%             trunc_tech_class{i} = pick(1:3);
%         else % in this case, something is strange
%             trunc_tech_class{i} = pick;
%             warning('Patent in year %d with index %d has too short tech class: %s.\n', ix_year, i, pick)
%         end
%     end
%    
%     patent_keyword_appear(:, 3) = trunc_tech_class;
% 
%     % Save to .mat file
%     % -------------------------------------------------------------------
%     save_name = horzcat('patent_keyword_appear_', num2str(ix_year), '.mat');
%     matfile_path_save = fullfile('matches', save_name);
%     save(matfile_path_save, 'patent_keyword_appear');    
%     fprintf('Saved: %s.\n', save_name)
% end


% % Delete year column from (UNcleaned) matches
% for ix_year = 2005:2015
%     
%     build_load_filename = horzcat('patent_keyword_appear_', num2str(ix_year), ...
%         '.mat');
% 
%     load(build_load_filename)
%     
%     if ~(size(patent_keyword_appear, 2) == 5)
%         warning('Year column in file for year %d already deleted? Continue in next year iteration.', ix_year)
%         continue
%     end
% 
%     aux_part1 = patent_keyword_appear(:, 1:3);
%     aux_part2 = patent_keyword_appear(:, 5);
%     patent_keyword_appear = [aux_part1 aux_part2];
% 
% 
%     % Save to .mat file
%     % -------------------------------------------------------------------
%     save_name = horzcat('patent_keyword_appear_', num2str(ix_year), '.mat');
%     matfile_path_save = fullfile('matches', save_name);
%     save(matfile_path_save, 'patent_keyword_appear');    
%     fprintf('Saved: %s.\n', save_name)
% end


% Delete year column from (CLEANED) matches
for ix_year = 1976:2015
    
    build_load_filename = horzcat('patsearch_results_', num2str(ix_year), ...
        '.mat');

    load(build_load_filename)
    
    if ~(size(patsearch_results, 2) == 5)
        warning('Year column in file for year %d already deleted? Continue in next year iteration.', ix_year)
        continue
    end
    aux_part1 = patsearch_results(:, 1:3);
    aux_part2 = patsearch_results(:, 5);
    patsearch_results = [aux_part1 aux_part2];


    % Save to .mat file
    % -------------------------------------------------------------------
    save_name = horzcat('patsearch_results_', num2str(ix_year), '.mat');
    matfile_path_save = fullfile('cleaned_matches', save_name);
    save(matfile_path_save, 'patsearch_results');    
    fprintf('Saved: %s.\n', save_name)
end