function ix_find = get_ix_cellarray_str(file_str, find_str)

ix_find = regexp(file_str, find_str);
ix_find = ~cellfun(@isempty, ix_find); % make logical array
ix_find = find( ix_find ); 
