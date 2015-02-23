% Take matches of keywords in patents and delete those with patent numbers
% starting with 

clc
clear all
close all

tic

addpath('matches');
addpath('functions');

%%
year_start = 1976;
year_end = 2015;


%%

for ix_year = year_start:year_end

    % Load matches
    disp('Start loading file...')
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)

    fprintf('Loaded file: %s\n', load_file_name)


    %% Find numbers starting with a letter
    % Number of patents per ix_year
    nr_patents_yr = size(patent_keyword_appear, 1);

    % Extract keyword matches per patent
    nr_keyword_per_patent = cell2mat(patent_keyword_appear(:, 2));
    cleaned_nr_keyword = nr_keyword_per_patent;

    patent_numbers = patent_keyword_appear(:, 1);

    cleaned_full_info = patent_numbers;


    ix_save = 1; % initalize saving index

    for ix_patent = 1:nr_patents_yr

        extract_row = patent_numbers{ix_patent};

        if strcmp(extract_row(1), 'D') ... % design patents
                | strcmp(extract_row(1), 'P') ... % PP: plant patents
                | strcmp(extract_row(1), 'R') ... % reissue patents
                | strcmp(extract_row(1), 'T') ... % defensive publications
                | strcmp(extract_row(1), 'H') ... % SIR (statutory invention registration)
                | strcmp(extract_row(1), 'X') % early X-patents
           save_row_delete(ix_save) = ix_patent;
           ix_save = ix_save + 1;
        end   
    end

    save_row_delete = save_row_delete';


    %%
    cleaned_full_info(save_row_delete) = [];
    cleaned_nr_keyword(save_row_delete) = [];

    if nr_patents_yr - length(save_row_delete) ~= length(cleaned_full_info)
        warning('They should be the same')
    end


    patent_nr_letter(ix_year-year_start+1) = length(save_row_delete);
    share_w_letter(ix_year-year_start+1) = length(save_row_delete)/nr_patents_yr;
    

    %%
    fprintf('Patent numbers that start with a letter: %d/%d = %s percent.\n', ...
        length(save_row_delete), nr_patents_yr, ...
        num2str(length(save_row_delete)/nr_patents_yr*100))


    %% Delete first and last letter
    patent_number_cleaned =  repmat({''}, length(cleaned_full_info), 1);
    for ix_patent = 1:length(cleaned_full_info)

        extract_row = cleaned_full_info{ix_patent};

        trunc_row = extract_row(2:end-1);
        patent_number_cleaned{ix_patent} = trunc_row;
    end

    if length(cleaned_nr_keyword) ~= length(patent_number_cleaned)
        warning('They should be the same')
    end


    %% Write to csv file
    save_name = horzcat('cleaned_patentnr_4transfer_', num2str(ix_year), '.csv');
    csvwrite(save_name, patent_number_cleaned);
    save_name = horzcat('cleaned_matches_4transfer_', num2str(ix_year), '.csv');
    csvwrite(save_name, cleaned_nr_keyword);
    disp('Finished saving csv files.')



    %%
    toc
    fprintf('Finished year %d\n', ix_year)
    disp('------------------------------------------------------------------')


    %% Clear variables from memory that could cause problems
    keep year_start year_end patent_nr_letter share_w_letter
end

disp('FINISH LOOP')
disp('==================================================================')


%% Save info on named patent numbers
save('named_patents_stats.mat', 'patent_nr_letter', 'share_w_letter')
