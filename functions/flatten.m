function cell_array = flatten(cell_array)
%converts nested cell arrays into a flat cell array
%FLATTEN converts nested cell arrays into a flat cell array
%
%Example:
%    flatten_cell({'a', {'b', 'c'}})
%        {'a', 'b', 'c'}
%
%See also: cell, cellfun
%

%#ok<*AGROW>
	c = {};
	cell_array = cell_array(cellfun(@(c) ~isempty(c), cell_array));
	for i = 1:numel(cell_array)
		if iscell(cell_array{i})
			if ~isempty(cell_array{i})
				ctemp = flatten(cell_array{i});
				c = [c{:}, ctemp{:}];
			end
		else
			c = {c{:}, cell_array(i)};
		end
	end
	cell_array = c(~cellfun(@isempty, c));
end

% Copyright 2009-2013 Alexandra Heidsieck <aheidsieck@tum.de>,
%                     IMETUM, Technische Universitaet Muenchen
