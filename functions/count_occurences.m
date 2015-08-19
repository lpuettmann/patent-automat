function [indic_find, nr_find, ix_find] = count_occurences(file_str, find_str)

if numel(find_str) < 1
    warning('find_str in count_occurences implausibly short.')
end

indic_find = strcmp(file_str, find_str);
nr_find = sum(indic_find);
ix_find = find(indic_find);
