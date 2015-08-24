function linked_pat_ix = match_pat2industry(year_start, year_end, ...
    conversion_table, ind_corresp)

nr_industries = size(ind_corresp, 1);

% Initialize
linked_pat_ix = repmat({''}, length(year_start:year_end), ...
    nr_industries);
all_industry_keyword_matches = repmat({''}, length(year_start:year_end), ...
    nr_industries);

% Iterate through yearly files and link the patent's technology
% classification to the industry.
for ix_year = year_start:year_end
    
    ix_iter = ix_year - year_start + 1;
    
    load(horzcat('patsearch_results_', num2str(ix_year), '.mat'))  

    % Count how many patents map into the industry
    classification_nr = patsearch_results.classnr;
    
    for ix_industry=1:nr_industries
        industry_nr = ind_corresp{ix_industry, 1};

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
    end
    
    fprintf('Linked tech class to industry: %d.\n', ix_year)
end


% Make some checks
if size(linked_pat_ix, 1) ~= length(year_start:year_end)
    warning('Should be equal.')
end

if size(linked_pat_ix, 2) ~= nr_industries
    warning('Should be equal.')
end
