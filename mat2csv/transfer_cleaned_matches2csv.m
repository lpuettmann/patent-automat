function transfer_cleaned_matches2csv(year_start, year_end)

patsearch_allyears = []; % initialize

for ix_year = year_start:year_end
    
    % Load cleaned matches
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)

    % Extract columns and prepare them
    % ---------------------------------------------------------------------

    % Patent numbers
    patent_nr = patsearch_results.patentnr;
    patent_nr = str2double(patent_nr);

    % Prepare tech class numbers
    tech_class_nr = patsearch_results.classnr;
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
    patent_week = cell2mat(patsearch_results.week);

    % Make new column of year patent was granted in
    % ---------------------------------------------------------------------
    patent_year = repmat(ix_year, length(patent_nr), 1);

    % Put matches next to each other
    % ---------------------------------------------------------------------
    patent_matches = [patsearch_results.title_matches, ...
        patsearch_results.abstract_matches, patsearch_results.body_matches];
    
    % Save individual year data
    % ---------------------------------------------------------------------
    patsearch_year = [patent_nr, patent_year, patent_week, ...
        tech_class_nr, patent_matches];
    
    % Save all years underneath
    % ---------------------------------------------------------------------
    patsearch_allyears = [patsearch_allyears;
                         patsearch_year];

    fprintf('Year %d finished.\n', ix_year)
end



%% Save the final matrix to different file formats
save_name = 'patsearch_allyears';

% Save to .mat file
tic
save(horzcat('output/patsearch_allyears', '.mat'), 'patsearch_allyears');
time_file_write = toc;
fprintf('Save file (%3.2fs): %s.mat.\n', time_file_write, save_name)


% Transfer results to cell array to make use of cell2csv
patsearch_allyears = num2cell(patsearch_allyears);

% Save to .csv file
tic
cell2csv(horzcat('output/patsearch_allyears', '.csv'), patsearch_allyears);
time_file_write = toc;
fprintf('Save file (%3.2fs): %s.csv.\n', time_file_write, save_name)
