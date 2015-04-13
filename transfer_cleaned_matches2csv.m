close all
clear all
clc



%% Add path to functions
addpath('cleaned_matches');


%%
year_start = 1976;
year_end = 2015;



%%
patsearch_allyears = zeros(1, 5);

for ix_year = year_start:year_end
    % Load cleaned matches
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)


    % Extract columns and prepare them
    % ---------------------------------------------------------------------

    % Patent numbers
    patent_nr = patsearch_results(:, 1);
    patent_nr = str2double(patent_nr);

    % Keyword matches
    nr_keyword_matches = patsearch_results(:, 2);
    nr_keyword_matches = cell2mat(nr_keyword_matches);

    % Prepare tech class numbers
    tech_class_nr = patsearch_results(:, 3);
    tech_class_nr = strtrim(tech_class_nr); % remove leading and trailing whitespace
    tech_class_nr = strtok(tech_class_nr); % keep string until first whitespace

    % Test if there is whitespaces tech classification numbers
    test_contains_space = strfind(tech_class_nr, ' ');
    show_ix_contains_space = find(~cellfun(@isempty, test_contains_space));
    if not(isempty(show_ix_contains_space))
        warning('There is a space in the patent tech classification numbers')
        disp(tech_class_nr(show_ix_contains_space))
    end

    tech_class_nr = str2double(tech_class_nr);

    % Week patent was granted in
    patent_week = cell2mat(patsearch_results(:, 4));

    % Make new column of year patent was granted in
    % ---------------------------------------------------------------------
    patent_year = repmat(ix_year, size(patsearch_results(:, 1),1), 1);

    % Save individual year data
    % ---------------------------------------------------------------------
    patsearch_year = [patent_nr, nr_keyword_matches, tech_class_nr, ...
        patent_week, patent_year];
    
    % Save all years underneath
    % ---------------------------------------------------------------------
    patsearch_allyears = [patsearch_allyears;
                         patsearch_year];

    fprintf('Year %d finished.\n', ix_year)
end

patsearch_allyears(1, :) = [];

% Save to .csv file
tic
save_name = 'patsearch_allyears.csv';
csvwrite(save_name, patsearch_allyears);
time_csv_write = toc;
fprintf('Save file (%3.2fs): %s.\n', save_name, time_csv_write)








