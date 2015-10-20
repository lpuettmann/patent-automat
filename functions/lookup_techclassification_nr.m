function trunc_tech_class = lookup_techclassification_nr(nr_patents, ...
    ix_find, ftset, search_corpus)

% Initialize
class_number = repmat({''}, nr_patents, 1);
trunc_tech_class = repmat({''}, nr_patents, 1);

for ix_patent=1:nr_patents
    
    % Get start and end of patent text
    % ------------------------------------------------------------
    patent_text_corpus = get_patent_text_corpus(ix_find, ix_patent, ...
        nr_patents, ftset, search_corpus);

    % lookup technology classification number
    % ------------------------------------------------------------
    switch ftset.indic_filetype
         case 1
            % Look up OCL (tech classification)
            ix_find_OCL = strfind(patent_text_corpus,  ftset.uspc_nr_findstr);
            all_OCL_matches = find(~cellfun(@isempty, ix_find_OCL));

            % Only look at first OCL match
            row_OCL_class = patent_text_corpus{all_OCL_matches(1)}; 

            % Extract tech class number from string
            class_number{ix_patent} = row_OCL_class(6:numel(row_OCL_class));

        case {2, 3}
            % Search for technology classification number
            indic_class_find = regexp(patent_text_corpus,  ftset.uspc_nr_findstr);
            indic_class_find = ~cellfun(@isempty, indic_class_find); % make logical array
            ix_class_find = find(indic_class_find);

            switch ftset.indic_filetype
                case 2
                     class_nr_ix = ix_class_find;
                    
                case 3
                    % Two lines below the first appearance of the search string 
                    % is where we find our tech classificiation
                    class_nr_ix = ix_class_find(1) + 2;
            end

            class_nr_line = patent_text_corpus(class_nr_ix, :);
            class_nr_line = class_nr_line{1};
            
            % Classificiations differ in length, so have to find end
            % where the classification stops.
            class_find_end = regexp(class_nr_line, ftset.classnr_linestop); 
            class_number{ix_patent} = class_nr_line(...
                ftset.classnr_linestart : class_find_end - 1);
    end
end

% Get rid of leading and trailing whitespace
cleaned_patent_tech_class = strtrim(class_number);

% Keep only the first 3 digits
for i=1:length(cleaned_patent_tech_class)
    pick = cleaned_patent_tech_class{i};

    if numel(pick)>=3
        trunc_tech_class{i} = pick(1:3);
    else
        trunc_tech_class{i} = pick;
        fprintf('Patent with index %d has too short tech class: %s.\n', ...
            i, pick)
    end
end
