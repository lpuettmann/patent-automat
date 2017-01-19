function patsearch_results = clean_matches(pat_ix, ...
    patent_keyword_appear, ix_year, opt2001)
% Take matches of keywords in patents and delete those with patent numbers
% starting with a letter. Clean patent numbers.

week_start = 1;
week_end = set_weekend(ix_year); 

if not( size(pat_ix, 1) == week_end )
    warning('pat_ix (length = %d) should have length %d.', ...
        size(pat_ix, 1), week_end)
end

length_pattext = [];
weekmean_len_pattxt = zeros(length(week_start:week_end), 1);

for ix_week=week_start:week_end
    ix_find = pat_ix{ix_week, 2};
    wly_lenpattext = ix_find(2:end) - ix_find(1:end-1);
    % Assumption: last patent gets average length of weekly file (problem:
    % I didn't save the length of the weekly file, opening it again here 
    % would take a long time)
    wly_lenpattext = [wly_lenpattext; round(mean(wly_lenpattext))];
    weekmean_len_pattxt(ix_week) = mean(wly_lenpattext);
    length_pattext = [length_pattext; wly_lenpattext];
end

if size(length_pattext) ~= size(patent_keyword_appear.patentnr, 1)
    warning('Should be equal.')
end

% Find numbers starting with a letter
save_row_delete = delete_named_pat(patent_keyword_appear.patentnr);

% Define new data structure to hold the results "patsearch_results"
patsearch_results = patent_keyword_appear;

patsearch_results.length_pattext = length_pattext;

% Delete patents that start with letter
patsearch_results.patentnr(save_row_delete) = [];
patsearch_results.classnr_uspc(save_row_delete) = [];
patsearch_results.classnr_ipc(save_row_delete) = [];
patsearch_results.week(save_row_delete) = [];
patsearch_results.title_matches(save_row_delete, :) = []; % matrix not vector
patsearch_results.abstract_matches(save_row_delete, :) = []; % matrix not vector
patsearch_results.body_matches(save_row_delete, :) = []; % matrix not vector
patsearch_results.length_pattext(save_row_delete) = [];

if size(patent_keyword_appear.patentnr, 1) - length(save_row_delete) ...
        ~= size(patsearch_results.patentnr, 1)
    warning('Should be equal.')
end

if length(patent_keyword_appear.dictionary) ~= size(...
        patsearch_results.title_matches, 2)
    warning('title_matches does not have the right size for all dictionary words.')
elseif length(patent_keyword_appear.dictionary) ~= size(...
        patsearch_results.abstract_matches, 2)
    warning('abstract_matches does not have the right size for all dictionary words.')
elseif length(patent_keyword_appear.dictionary) ~= size(...
        patsearch_results.body_matches, 2)
    warning('body_matches does not have the right size for all dictionary words.')
end

if size(patsearch_results.patentnr, 1) ~= size(...
        patsearch_results.title_matches, 1)
    warning('title_matches does not have the right size for all patents.')
elseif size(patsearch_results.patentnr, 1) ~= size(...
        patsearch_results.abstract_matches, 1)
    warning('abstract_matches does not have the right size for all patents.')
elseif size(patsearch_results.patentnr, 1) ~= size(...
        patsearch_results.body_matches, 1)
    warning('body_matches does not have the right size for all patents.')
end

% Delete first (and last [for some]) letter of patent numbers
patsearch_results.patentnr = strip_patentnr(patsearch_results.patentnr, ...
    ix_year, opt2001);
