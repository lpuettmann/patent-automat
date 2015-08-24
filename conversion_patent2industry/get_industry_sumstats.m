function industry_sumstats = get_industry_sumstats(year_start, year_end, ...
    linked_pat_ix)

for ix_year = year_start:year_end
    
    ix_iter = ix_year - year_start + 1;
    
    load(horzcat('patsearch_results_', num2str(ix_year), '.mat'))  

    for ix_industry=1:size(linked_pat_ix, 2)
        
        % Extract which patents link to industries
        patix2ind = linked_pat_ix{ix_iter, ix_industry};
        
        % Find keyword matches of the patents that map to the industry
        industry_title_matches = patsearch_results.title_matches(patix2ind, :);
        industry_abstract_matches = patsearch_results.abstract_matches(patix2ind, :);
        industry_body_matches = patsearch_results.body_matches(patix2ind, :);

        % Find patents classified as automation patents by Algorithm1
        industry_alg1 = classif_alg1(patsearch_results.dictionary, ...
            industry_title_matches, ...
            industry_abstract_matches, ...
            industry_body_matches);

        % Find patents classified as automation patents if contain
        % "automat" at least once.
        industry_nr_keyword_per_patent = industry_title_matches(:,1) + ...
            industry_abstract_matches(:,1) + industry_body_matches(:,1);
        industry_pat1m = +(industry_nr_keyword_per_patent > 1);
        
        % Save yearly summary statistics for industries
        save_sumstats = [length(patix2ind), sum(industry_alg1), ...
            sum(industry_pat1m)];

        industry_sumstats(ix_industry, :, ix_iter) = save_sumstats;
    end
    
    fprintf('Calculated summary statistics for industries: %d.\n', ix_year)
end




