clear all
close all
clc

% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()

% Extract information on patents and remove some information (word matches)
% that doesn't fit neatly into a rectangular dataset.

for ix_year = 1976:2014
    tic
    fname = ['patsearch_results_', num2str(ix_year)];
    load(fname);

    patentnr_exp = [];
    P = length(patsearch_results.patentnr);

    
    for p = 1:P

        p_nr = str2num( patsearch_results.patentnr{p} );
        p_ipcs = patsearch_results.classnr_ipc{p};

        I = length(p_ipcs);

        patentnr_exp = [patentnr_exp; 
                        repmat(p_nr, I, 1)];
    end

    ipcs_exp = vertcat(patsearch_results.classnr_ipc{:});
    assert(length(patentnr_exp) == length(ipcs_exp))

    ipcs.patentnr_exp = patentnr_exp;
    ipcs.ipcs_exp = ipcs_exp;

    save(['ipcs/ipcs_', num2str(ix_year), '.mat'], 'ipcs')
    fprintf('%d. [%ds]\n', ix_year, round(toc))
end