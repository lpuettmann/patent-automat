clc
clear all
close all

tic

addpath('matches');
addpath('functions');


year = 2001;


% Load matches
load_file_name = horzcat('patent_keyword_appear_', num2str(year));
load(load_file_name)



%% Find numbers starting with D (design patents)
% Number of patents per year
nr_patents_yr = size(patent_keyword_appear, 1);


% Extract keyword matches per patent
nr_keyword_per_patent = cell2mat(patent_keyword_appear(:, 2));
cleaned_nr_keyword = nr_keyword_per_patent;

patent_numbers = patent_keyword_appear(:, 1);

cleaned_full_info = patent_numbers;

    
ix_save = 1; % initalize saving index

for ix_patent = 1:nr_patents_yr

    extract_row = patent_numbers{ix_patent};

    if strcmp(extract_row(1), 'D') | strcmp(extract_row(1), 'P') ...
            | strcmp(extract_row(1), 'R') | strcmp(extract_row(1), 'H')
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
csvwrite('cleaned_patentnr_4transfer.csv', patent_number_cleaned);
csvwrite('cleaned_matches_4transfer.csv', cleaned_nr_keyword);
    
    

%%
toc








