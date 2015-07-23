clear all
close all
clc

% Close all previously openned files
fclose('all');

% Set paths to all underlying directories
setup_path

% Make patent index for 2002-2004
find_patents_part2

disp('================================================================')

% Search for keywords for 2002-2004
analyze_patent_text_part2

disp('================================================================')
