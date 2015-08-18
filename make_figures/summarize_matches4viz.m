function summarize_matches(year_start, year_end)


week_start = 1;

% Initialize
allyr_patstats.total_matches_week = []; 
allyr_patstats.total_pat1m_week = []; 
allyr_patstats.nr_patents_per_week = [];
allyr_patstats.total_alg1_week = [];

% Where new year data starts
ix_new_year = ones(length(year_start:year_end) + 1, 1); 

aux_ix_save = 1; % where to save data in vector


for ix_year=year_start:year_end

    week_end = set_weekend(ix_year); 


    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
   
    
    % Add all weekly total matches together
    % -------------------------------------------------------------
    nr_keyword_per_patent = patsearch_results.title_matches + ...
        patsearch_results.abstract_matches + patsearch_results.body_matches;
    pat1m = +(nr_keyword_per_patent > 1);
    alg1 = classif_alg1(patsearch_results.dictionary, ...
        patsearch_results.title_matches, ...
        patsearch_results.abstract_matches, patsearch_results.body_matches);
    
    patent_week = cell2mat(patsearch_results.week);
    
    if size(patent_week, 1) ~= size(nr_keyword_per_patent, 1)
        warning('Number of patents not equal to number of week identifiers')
    end

    total_matches_week = zeros(week_end, length(patsearch_results.dictionary));
    total_pat1m_week = zeros(week_end, length(patsearch_results.dictionary));  
    total_alg1_week = zeros(week_end, 1);  
    nr_patents_per_week = zeros(week_end, 1);
    
    for ix_week=week_start:week_end
        keywords_week = nr_keyword_per_patent(patent_week==ix_week, :);
        total_matches_week(ix_week, :) = sum(keywords_week, 1);

        pat1m_week = pat1m(patent_week==ix_week, :);
        total_pat1m_week(ix_week, :) = sum(pat1m_week, 1);
        
        alg1_week = alg1(patent_week==ix_week, :);
        total_alg1_week(ix_week, :) = sum(alg1_week, 1);
        
        % Count number of patents per week
        nr_patents_per_week(ix_week) = length(keywords_week);
    end
    

    allyr_patstats.total_matches_week = [allyr_patstats.total_matches_week;
                                        total_matches_week];

    allyr_patstats.total_pat1m_week = [allyr_patstats.total_pat1m_week;
                                       total_pat1m_week];           
                                    

    allyr_patstats.total_alg1_week = [allyr_patstats.total_alg1_week;
                                      total_alg1_week];     
                                    
    allyr_patstats.nr_patents_per_week = [allyr_patstats.nr_patents_per_week;
                                         nr_patents_per_week];

    ix_new_year(aux_ix_save + 1) = size(allyr_patstats.total_matches_week, 1);
    aux_ix_save = aux_ix_save + 1;
    
    
    fprintf('Summarized year: %d.\n', ix_year)
end


% Re-formate the index showing where new year data starts
ix_new_year = ix_new_year(1:end-1);

if length(ix_new_year) ~= length(year_start:year_end)
    warning('Should be the same.')
end

allyr_patstats.ix_new_year = ix_new_year;
allyr_patstats.dictionary = patsearch_results.dictionary;


%% Save
% ========================================================================
save_name = horzcat('output/allyr_patstats_', num2str(year_start), '-', ...
    num2str(year_end), '.mat');
save(save_name, 'allyr_patstats')
fprintf('Saved: %s.\n', save_name)
