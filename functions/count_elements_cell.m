function element_count = count_elements_cell(in_cellarray)
% Count the total number of elements that appear in cell array including
% those in sub-cell arrays.


if numel(size(in_cellarray)) > 2
    warning('Function count_elements_cell only defined for vector.')
end

size_input = sort(size(in_cellarray));

if size_input(end-1) > 1
    warning('Function count_elements_cell only defined for vector.')
end

element_count = 0; % initialize

for j=1:length(in_cellarray)
    element_count = element_count + ...
        length(in_cellarray{j});
end
