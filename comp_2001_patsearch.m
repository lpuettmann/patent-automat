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
% 

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


% Continue
lclean_txt = length(pclean_txt.patentnr);
lclean_xml = length(pclean_xml.patentnr);

fprintf('# patents txt: %d, # patents xml: %d (change: %3.1f percent).\n', ...
    lclean_txt, lclean_xml, lclean_txt / lclean_xml * 100 - 100)

% Make sure they used the same dictionaries
assert(all(strcmp(pclean_txt.dictionary, pclean_xml.dictionary)))

% Convert strings to numbers (already done for xml)
pclean_txt.patentnr = cellfun(@str2num, pclean_txt.patentnr);

% Solve problem with first patent
pclean_xml.patentnr(1) = [];
pclean_xml.classnr_uspc(end) = [];
pclean_xml.week(end) = [];
pclean_xml.classnr_ipc(end) = [];
pclean_xml.title_matches(end, :) = [];
pclean_xml.abstract_matches(end, :) = [];
pclean_xml.body_matches(end, :) = [];
pclean_xml.length_pattext(end) = [];
pclean_xml.is_nbAutomat(end) = [];
pclean_xml.indic_exclclassnr(end) = [];

pclean_txt.patentnr(1) = [];
pclean_txt.classnr_uspc(1) = [];
pclean_txt.week(1) = [];
pclean_txt.classnr_ipc(1) = [];
pclean_txt.title_matches(1, :) = [];
pclean_txt.abstract_matches(1, :) = [];
pclean_txt.body_matches(1, :) = [];
pclean_txt.length_pattext(1) = [];
pclean_txt.is_nbAutomat(1) = [];
pclean_txt.indic_exclclassnr(1) = [];


pclean_txt.dictionary(find(pclean_txt.title_matches(1, :)))
pclean_xml.dictionary(find(pclean_xml.title_matches(1, :)))

pclean_txt.patentnr(1)
pclean_xml.patentnr(1)

pclean_txt.dictionary(find(pclean_txt.title_matches(2, :)))
pclean_xml.dictionary(find(pclean_xml.title_matches(2, :)))

pclean_txt.patentnr(2)
pclean_xml.patentnr(2)


%% Check out differing patents
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


%% Delete non-overlapping patents from both
assert( isempty( find( ismember(pclean_xml.patentnr, pdiff.patentnr) )) )

pclean_txt.patentnr(pdiff.ix) = [];
pclean_txt.classnr_uspc(pdiff.ix) = [];
pclean_txt.week(pdiff.ix) = [];
pclean_txt.classnr_ipc(pdiff.ix) = [];
pclean_txt.title_matches(pdiff.ix, :) = [];
pclean_txt.abstract_matches(pdiff.ix, :) = [];
pclean_txt.body_matches(pdiff.ix, :) = [];
pclean_txt.length_pattext(pdiff.ix) = [];
pclean_txt.is_nbAutomat(pdiff.ix) = [];
pclean_txt.indic_exclclassnr(pdiff.ix) = [];

assert(length(pclean_txt.patentnr) == length(pclean_xml.patentnr))
assert(isequal(pclean_txt.patentnr, pclean_xml.patentnr))
assert( min(pclean_txt.patentnr == pclean_xml.patentnr) == 1)

classEqual = (pclean_txt.is_nbAutomat == pclean_xml.is_nbAutomat)
sum(classEqual)
sum(classEqual) / length(pclean_txt.patentnr)
corr(pclean_txt.is_nbAutomat, pclean_xml.is_nbAutomat)

%%
clc

I = 66666;

for i = I:(I+10)
    disp(i)
    pclean_txt.dictionary(find(pclean_txt.title_matches(i, :)))
    pclean_xml.dictionary(find(pclean_xml.title_matches(i, :)))
    
    assert(pclean_txt.patentnr(i) == pclean_xml.patentnr(i))
    
    disp('___________________')
    disp('')
end













