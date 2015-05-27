close all
clear all
clc

addpath('../cleaned_matches');

load('patents_automatic1_manual0.mat')

% Sort data after years. This is important as we'll later loop through
[~, ix_sort] = sort(patents_automatic1_manual0(:,2));
patents_automatic1_manual0 = patents_automatic1_manual0(ix_sort, :);

patent_numbers = patents_automatic1_manual0(:, 1);
patent_years = patents_automatic1_manual0(:, 2);


year_start = 1976;
year_end = 2015;
nr_years = length(year_start:year_end);

all_technr = [];

ix_extract_start = 1;

%% Extract the technology numbers for patents
for ix_year=year_start:year_end
    
    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patsearch_results_', num2str(ix_year));
    load(load_file_name)
    
    patentyr_numbers = patsearch_results(:, 1);
    patentyr_technr = patsearch_results(:, 3);
    
    nr_yearlength = length(find(patent_years == ix_year));
    
    ix_extract_stop = ix_extract_start + nr_yearlength - 1;
    
    extract_patyrnr = patent_numbers(ix_extract_start:ix_extract_stop);
    
    if length(extract_patyrnr) ~= nr_yearlength
        warning('Check if length is right.')
    end
    
    j_technr = zeros(nr_yearlength,1);
    
    for j=1:length(extract_patyrnr)
        extract_me = extract_patyrnr(j,:);
        extract_me = num2str(extract_me);
        ix_pos_ex = find(strcmp(patentyr_numbers, extract_me));
        j_technr(j) = str2num(patentyr_technr{ix_pos_ex});
    end
    all_technr = [all_technr; j_technr];
    
    ix_extract_start = ix_extract_stop + 1;
    
    fprintf('Year finished: %d.\n', ix_year)
end


%% Check that extracted series have right size
if not(length(patent_years) == length(all_technr))
    warning('Should have same length.')
end

patents_automatic1_manual0 = [patents_automatic1_manual0, all_technr];


%%
save('all_technr.mat', 'all_technr');    


%%













