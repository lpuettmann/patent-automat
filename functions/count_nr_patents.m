function [indic_find, nr_find, ix_find] = count_nr_patents(file_str, find_str)

indic_find = strcmp(file_str, find_str);
nr_find = sum(indic_find);
ix_find = find(indic_find);
