% Take matches of keywords in patents and delete those with patent numbers
% starting with a letter. Clean patent numbers.

clc
clear all
close all

tic

addpath('matches');
addpath('functions');

%%
year_start = 2012;
year_end = 2012;


%%

for ix_year = year_start:year_end

    % Load matches
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)


    %% Find numbers starting with a letter
    % Number of patents per ix_year
    nr_patents_yr = size(patent_keyword_appear, 1);

    patent_numbers = patent_keyword_appear(:, 1);

    ix_save = 1; % initalize saving index

    for ix_patent = 1:nr_patents_yr
        extract_row = patent_numbers{ix_patent};

        if strcmp(extract_row(1), 'D') ... % design patents
                || strcmp(extract_row(1), 'P') ... % PP: plant patents
                || strcmp(extract_row(1), 'R') ... % reissue patents
                || strcmp(extract_row(1), 'T') ... % defensive publications
                || strcmp(extract_row(1), 'H') ... % SIR (statutory invention registration)
                || strcmp(extract_row(1), 'X') % early X-patents
           save_row_delete(ix_save) = ix_patent;
           ix_save = ix_save + 1;
        end   
    end

    save_row_delete = save_row_delete';
    
    
    %% Delete patents that start with letter
    patsearch_results = patent_keyword_appear;  % Patent search result table
    patsearch_results(save_row_delete, :) = [];
    
    if nr_patents_yr - length(save_row_delete) ~= size(patsearch_results, 1)
        warning('They should be the same')
    end


    % Save some information on the deleted named patents
    patent_nr_letter(ix_year-year_start+1) = length(save_row_delete);
    share_w_letter(ix_year-year_start+1) = length(save_row_delete)/nr_patents_yr;
    

    %%
    fprintf('Patent numbers that start with a letter: %d/%d = %s percent.\n', ...
        length(save_row_delete), nr_patents_yr, ...
        num2str(length(save_row_delete)/nr_patents_yr*100))

  
    
    %% Delete first (and last [for some]) letter of patent numbers
    patent_number_cleaned =  repmat({''}, size(patsearch_results, 1), 1);
    for ix_patent = 1:size(patsearch_results, 1)

        extract_row = patsearch_results{ix_patent, 1};

        if ix_year >= 2002 % after (not incl.) 2001: delete first letter only
            trunc_row = extract_row(2:end);
        else % before 2001: delete first and last letter
            trunc_row = extract_row(2:end-1);
        end
        
        patent_number_cleaned{ix_patent} = trunc_row;
    end

    % Insert truncated patent numbers back into patent result table
    patsearch_results(:, 1) = patent_number_cleaned;

    % Save
    save_name = horzcat('patsearch_results_', num2str(ix_year), '.mat');
    matfile_path_save = fullfile('cleaned_matches', save_name);
    save(matfile_path_save, 'patsearch_results');    
    fprintf('Saved: %s.\n', save_name)
    disp('----------')

    %% Clear variables from memory that could cause problems
    keep year_start year_end patent_nr_letter share_w_letter
end

disp('Finished.')
