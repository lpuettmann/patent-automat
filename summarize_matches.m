close all
clear all
clc

tic

addpath('matches');
addpath('functions');


%% Define parameters
% ========================================================================
find_str = 'automat'; 

year_start = 1976;
year_end = 1996;
week_start = 1;


%% Loop through data for all years
% ========================================================================
allyear_total_matches_week = 0; % pre-define vector


for ix_year=year_start:year_end
    year = ix_year;

    if year == 1980 | year == 1985 | year == 1991 | year == 1996
        week_end = 53;
    else
        week_end = 52;
    end


    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patent_keyword_appear_', num2str(year));
    load(load_file_name)


    % Add all weekly total matches together
    % -------------------------------------------------------------
    nr_keyword_per_patent = cell2mat(patent_keyword_appear(:, 2));
    patent_week = cell2mat(patent_keyword_appear(:, 5));

    if size(patent_week, 1) ~= size(nr_keyword_per_patent, 1)
        warning('Number of patents not equal to number of week identifiers')
    end


    total_matches_week = zeros(week_end, 1);

    for ix_week=week_start:week_end
        keywords_week = nr_keyword_per_patent(patent_week==ix_week);
        total_matches_week(ix_week) = sum(keywords_week);
    end
    
    if size(total_matches_week, 1) < size(total_matches_week, 2)
        warning('Check if column vector')
    end

    allyear_total_matches_week = [allyear_total_matches_week;
                                  total_matches_week];
   
    fprintf('Year %d completed.\n', year)
end

% Cut of the first zero used for pre-defining
allyear_total_matches_week = allyear_total_matches_week(2:end);


%% Save
% ========================================================================
save_name = horzcat('allyear_total_matches_week_', num2str(year_start), '-',  num2str(year_end), '.mat');
save(save_name, 'allyear_total_matches_week')


%% End
% ======================================================================
toc
disp('*** end ***')
