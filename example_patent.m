clear all
close all

ix_year = 2001;
load_name = horzcat('cleaned_matches/patsearch_results_', num2str(ix_year), '.mat');
load(load_name, 'patsearch_results')

% Pick a patent number
pnr = '6170584';

% Find entry
ixPat = find(strcmp(patsearch_results.patentnr, pnr));

fprintf('Patent "%s" in %d is classified: %d (0: no, 1: automation).\n', ...
    pnr, ix_year, patsearch_results.is_nbAutomat(ixPat))

patsearch_results.classnr_ipc{ixPat}
patsearch_results.classnr_uspc(ixPat)

hits = patsearch_results.title_matches(ixPat, :);
patsearch_results.dictionary(find(full(hits)))

hits = patsearch_results.abstract_matches(ixPat, :);
patsearch_results.dictionary(find(full(hits)))

hits = patsearch_results.body_matches(ixPat, :);
patsearch_results.dictionary(find(full(hits)))


patsearch_results.indic_exclclassnr(ixPat)