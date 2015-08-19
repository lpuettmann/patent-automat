function [industry_list, linked_pat_ix, industry_sumstats] = ...
    match_pat2industry(year_start, year_end, ind_code_table, ...
    conversion_table)


industry_list = unique(conversion_table.naics_class_list);


% Initialize
linked_pat_ix = repmat({''}, length(year_start:year_end), ...
    length(industry_list));
all_industry_keyword_matches = repmat({''}, length(year_start:year_end), ...
    length(industry_list));


% Iterate through yearly files and link the patent's technology
% classification to the industry.
for ix_year = year_start:year_end
    
    ix_iter = ix_year - year_start + 1;
    
    load(horzcat('patsearch_results_', num2str(ix_year), '.mat'))  

    % Count how many patents map into the industry
    classification_nr = patsearch_results.classnr;
    
    
    for ix_industry=1:length(industry_list)
        industry_nr = industry_list{ix_industry};
        list_pos = find(strcmp(ind_code_table(:,1), industry_nr));
        industry_name = ind_code_table{list_pos, 2};
        industry_name = cellstr(industry_name);
        industry_name = industry_name{1};

        % Find industry number in the naics list
        positions_table = find(strcmp(conversion_table.naics_class_list, ...
            industry_nr));

        % Get the set of patent tech classifications that are matched into the
        % respective industry.
        tc2ind = conversion_table.tech_class_list(positions_table);
        tc2ind = unique(tc2ind); % delete duplicates (and sort)


        % Find patents that have the right tech classifications
        patix2ind = [];

        for ix_set=1:length(tc2ind)
            pick_nr = num2str(tc2ind(ix_set));

            patix2ind = [patix2ind;
                        find(strcmp(classification_nr, pick_nr))];
        end

        patix2ind = sort(patix2ind);

        if min(unique(patix2ind) == patix2ind) < 1
            warning('I''m not sure there can be duplicates here.')
        end

        % Save which patents link to industries
        linked_pat_ix{ix_iter, ix_industry} = patix2ind;
        
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

        industry_sumstats(ix_industry, :, ix_iter) = ...
            {industry_nr, industry_name, save_sumstats};
    end
    
    fprintf('Linked tech class to industry: %d.\n', ix_year)
end
