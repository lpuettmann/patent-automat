clear all
close all
clc

% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path


%% Choose years
year_start = 1976;
year_end = 2015;
years = year_start:year_end;


%% Make patent index
% for ix_year = years
%     tic
%  
%     % Search for keywords in the patent grant texts
%     pat_ix = make_patent_index(ix_year);
%     
%     % Print how long the year took
%     print_finish_summary(toc, ix_year)
%     
%     % Save to .mat file
%     save_patix2mat(pat_ix, ix_year)
% end
% 
% 
% %% Search for keywords
% for ix_year = years
%     tic
%     
%     % Define dictionary to search for
%     find_dictionary = define_dictionary();
%     
%     % Search for keywords in the patent grant texts
%     patent_keyword_appear = analyze_patent_text(ix_year, find_dictionary);
%     
%     % Print how long the year took
%     print_finish_summary(toc, ix_year)
%     
%     % Save to .mat file
%     save_patent_keyword_appear2mat(patent_keyword_appear, ix_year)
% end


%% Clean matches
% clean_matches(year_start, year_end)


%% Summarize matches
% summarize_matches(year_start, year_end)


%% Plot 
% plot_matches_overtime(year_start, year_end)
% plot_matches_over_nrpatents_weekly(year_start, year_end)


%% Transfer matches to CSV (for use in Stata)
%transfer_cleaned_matches2csv(year_start, year_end)
