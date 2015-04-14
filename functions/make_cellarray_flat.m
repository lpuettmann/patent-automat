function flat_cell_array = make_cellarray_flat(cellarray_in)

flat_cell_array = horzcat(cellarray_in{:})';
