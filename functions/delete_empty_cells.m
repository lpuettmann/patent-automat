function cleaned_cellarray = delete_empty_cells(cellarray_in)

cleaned_cellarray = cellarray_in(~cellfun('isempty', ...
    cellarray_in));
