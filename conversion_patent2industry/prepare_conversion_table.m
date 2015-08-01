function conversion_table = prepare_conversion_table(fname, lnumber)

fid = fopen(fname, 'r'); % open the file

lineArray = cell(lnumber, 1); % initialize
                          
lineIndex = 1; % index of cell to place the next line in
nextLine = fgetl(fid); % read the first line from the file

while ~isequal(nextLine, -1) % loop while not at the end of the file
    lineArray{lineIndex} = nextLine; % add the line to the cell array
    lineIndex = lineIndex + 1;
    nextLine = fgetl(fid); % read the next line from the file
end

fclose(fid); % close the file

% Delete first row with headings
lineArray(1) = [];


tech_class_list = zeros(length(lineArray), 1);
naics_class_list = repmat({''}, length(lineArray), 1);

for ix_line = 1:length(lineArray)
    line_str = lineArray{ix_line};
    splitted_line = strsplit(line_str, ',');
    
    tech_class_list(ix_line) = str2double(splitted_line{1});
    naics_class_list{ix_line} = splitted_line{4};
end

if ~(length(tech_class_list)==length(naics_class_list))
    warning('tech_class_list and naics_class_list should have same length.')
end

% Save in structure
conversion_table.tech_class_list = tech_class_list;
conversion_table.naics_class_list = naics_class_list;
