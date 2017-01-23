clear all
close all


% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()

% Choose years 
ix_year = 2001;
opt2001 = 'xml';

%% Compare raw matches

% load('./comp_2001/patent_keyword_appear_2001.mat')
% pat_xml = patent_keyword_appear;
% 
% load('./matches/patent_keyword_appear_2001.mat')
% pat_txt = patent_keyword_appear;
% clear patent_keyword_appear
% 
% l_txt = length(pat_txt.patentnr);
% l_xml = length(pat_xml.patentnr);
% 
% fprintf('# patents txt: %d, # patents xml: %d (change: %3.1f percent).\n', ...
%     l_txt, l_xml, l_txt / l_xml * 100 - 100)


% Compare cleaned matches
load('./cleaned_matches/patsearch_results_2001.mat')
pclean_txt = patsearch_results;

load('./comp_2001/patsearch_results_2001_comp.mat')
pclean_xml = patsearch_results;
clear patsearch_results

lclean_txt = length(pclean_txt.patentnr);
lclean_xml = length(pclean_xml.patentnr);

fprintf('# patents txt: %d, # patents xml: %d (change: %3.1f percent).\n', ...
    lclean_txt, lclean_xml, lclean_txt / lclean_xml * 100 - 100)

% Convert strings to numbers (already done for xml)
pclean_txt.patentnr = cellfun(@str2num, pclean_txt.patentnr);

pint.patentnr = intersect(pclean_txt.patentnr, pclean_xml.patentnr);
pdiff.patentnr = setdiff(pclean_txt.patentnr, pclean_xml.patentnr);

pdiff.ix = find( ismember(pclean_txt.patentnr, pdiff.patentnr) );

ndiff = length(pdiff.ix);
assert(ndiff == length(pdiff.patentnr))

fprintf('Number missing patents: %d (%3.1f percent).\n', ndiff, ...
    ndiff / lclean_txt * 100)

pdiff.classnr_uspc = pclean_txt.classnr_uspc(pdiff.ix);
pdiff.week = pclean_txt.week(pdiff.ix);
pdiff.classnr_ipc = pclean_txt.classnr_ipc(pdiff.ix);
pdiff.title_matches = pclean_txt.title_matches(pdiff.ix);
pdiff.abstract_matches = pclean_txt.abstract_matches(pdiff.ix);
pdiff.body_matches = pclean_txt.body_matches(pdiff.ix);
pdiff.length_pattext = pclean_txt.length_pattext(pdiff.ix);
pdiff.is_nbAutomat = pclean_txt.is_nbAutomat(pdiff.ix);
pdiff.indic_exclclassnr = pclean_txt.indic_exclclassnr(pdiff.ix);

fprintf('Number of missing patents classified as automation patents: %3.1f percent.\n', ...
    sum(pdiff.is_nbAutomat) / ndiff * 100)




