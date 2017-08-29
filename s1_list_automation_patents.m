clear all
close all

% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()

% Extract information on patents and remove some information (word matches)
% that doesn't fit neatly into a rectangular dataset.

for ix_year = 1976:2014
    fname = ['patsearch_results_', num2str(ix_year)];
    load(fname);

    
    patsearch_results = rmfield(patsearch_results, 'dictionary');
    patsearch_results = rmfield(patsearch_results, 'title_matches');
    patsearch_results = rmfield(patsearch_results, 'abstract_matches');
    patsearch_results = rmfield(patsearch_results, 'body_matches');
    
    % Not easy to save, as there are many IPCs for any patent
    patsearch_results = rmfield(patsearch_results, 'classnr_ipc');
    
    patsearch_results.week = vertcat(patsearch_results.week{:});
    assert(length(patsearch_results.week) == ...
        length(patsearch_results.patentnr))    
    
    patent_info = patsearch_results;
    clear patsearch_results

    save(['patent_info/', fname, '.mat'], 'patent_info')
    fprintf('%d\n', ix_year)
end



