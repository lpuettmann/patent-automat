function [ix_find, nr_find] = count_nr_string_appearance(file_string, ...
    find_string)

ix_find = strfind(file_string, find_string);
nr_find = length(ix_find);
