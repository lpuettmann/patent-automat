clear all
close all
clc

% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path


%% Make patent index
year_start = 2005;
year_end = 2005;

for ix_year = year_start:year_end
    tic
 
    % Search for keywords in the patent grant texts
    pat_ix = make_patent_index(ix_year);
    
    % Print how long the year took
    print_finish_summary(toc, ix_year)
    
    % Save to .mat file
%     save_patix2mat(pat_ix, ix_year)
end

break
%% Search for keywords
year_start = 1976;
year_end = 2004;

for ix_year = year_start:year_end
    tic
    
    % Define dictionary to search for
    find_dictionary = define_dictionary();
    
    % Search for keywords in the patent grant texts
    analyze_patent_text(ix_year, find_dictionary);
    
    % Print how long the year took
    print_finish_summary(toc, ix_year)
    
    % Save to .mat file
%     save_patent_keyword_appear2mat(patent_keyword_appear, ix_year)
end
