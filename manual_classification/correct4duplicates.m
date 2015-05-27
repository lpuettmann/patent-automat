close all
clear all
clc

addpath('../functions')
addpath('../cleaned_matches')

% Load excel file
[manclass_data, ~, ~] = xlsread('manclass_consolidated.xlsx');

% Figure out how many patents have been classified yet
indic_automat = manclass_data(:, 3);


%% Merge duplicate entries
patent_numbers = manclass_data(:, 1);
[unique_entries, i] = unique(patent_numbers, 'first');
ix_duplicates = find(not(ismember(1:length(patent_numbers), i)));

manclass_data_merged = manclass_data;

if length(unique_entries) ~= length(patent_numbers)
    nr_duplicates = length(patent_numbers) - length(unique_entries);
    warning('There are %d duplicate patents.', nr_duplicates)

    duplicates = patent_numbers(ix_duplicates);

    for d=1:length(ix_duplicates)
        ix_bothdupl = find(patent_numbers == duplicates(d));
        entry1 = manclass_data(ix_bothdupl(1), :);
        entry2 = manclass_data(ix_bothdupl(2), :);
                
        if isequaln(entry1, entry2)
            delete_index(d) = ix_bothdupl(2);
            fprintf('Same entry, merge.\n')
        else
            warning('Different entry for %d and %d (%d).\n', ...
                ix_bothdupl(1), ix_bothdupl(2), patent_numbers(ix_bothdupl(1)))
        end
    end
end

manclass_data_merged(delete_index, :) = [];

xlswrite('merged_manclass_consolidated.xlsx', manclass_data_merged)
