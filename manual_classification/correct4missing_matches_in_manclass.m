
close all
clear all
clc

addpath('../cleaned_matches');


% Load excel file
[manclass_data, txt, ~] = xlsread('manclass_FULL_v1.xlsx');


[~, ix_sort] = sort(manclass_data(:,2));


manclass_data = manclass_data(ix_sort, :);

patent_data = manclass_data(:,1:2);

year_start = 1976;
year_end = 2015;
nr_years = length(year_start:year_end);

all_matches = [];

ix_extract_start = 1;


for ix_year=year_start:year_end
    
    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
    
    patentyr_numbers = patsearch_results(:, 1);
    patentyr_matches = patsearch_results(:, 2);
    
    nr_yearlength = length(find(manclass_data(:, 2) == ix_year));
    
    ix_extract_stop = ix_extract_start + nr_yearlength - 1;
    
    extract_patyrnr = patent_data(ix_extract_start:ix_extract_stop, 1);
    
    if length(extract_patyrnr) ~= nr_yearlength
        warning('Check right length.')
    end
    
    j_matches = zeros(nr_yearlength,1);
    
    for j=1:length(extract_patyrnr)
        extract_me = extract_patyrnr(j,:);
        extract_me = num2str(extract_me);
        ix_pos_ex = find(strcmp(patentyr_numbers, extract_me));
        j_matches(j) = patentyr_matches{ix_pos_ex};
    end
    all_matches = [all_matches; j_matches];
    
    ix_extract_start = ix_extract_stop + 1;
    
    fprintf('Year finished: %d.\n', ix_year)
end


%%
if not(size(manclass_data,1) == size(all_matches, 1))
    warning('Should be same size.')
end

manclass_data = [manclass_data, all_matches];

xlswrite('new_manclass_FULL.xlsx', manclass_data)




