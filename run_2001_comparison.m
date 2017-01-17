clear all
close all


% Close all open files
fclose('all');

% Set paths to all underlying directories
setup_path()

%% Choose years 
ix_year = 2001;

year_start = ix_year;
year_end = ix_year;

parent_dname = 'T:\Puettmann\patent_project\2001_compare_data';

