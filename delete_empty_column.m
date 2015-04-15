
clc
clear all
close all


addpath('matches');

% 1985-1989 is fine

% delete empty 5th column 1976-1984

year_start = 1976; % be careful
year_end = 2015; % be careful


for ix_year = year_start:year_end

    % Load matches
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)
    
    
    if size(patent_keyword_appear, 2) < 6
        error('patent_keyword_appear in year %d should have 6 columns.\n', ix_year)
    end
    
    
%     patent_keyword_appear(:, 5) = [];
    
    
    % Overwrite the file
    % -------------------------------------------------------------------
%     save_name = horzcat(load_file_name, '.mat');
%     matfile_path_save = fullfile('matches', save_name);
%     save(matfile_path_save, 'patent_keyword_appear');    
%     fprintf('Saved: %s.\n', save_name)
    
    
end
