function [uspc_nr, ipc_nr] = lookup_techclassification_nr(nr_patents, ...
    ix_find, ftset, search_corpus)

% Initialize
uspc_nr = repmat({''}, nr_patents, 1);
ipc_nr = repmat({''}, nr_patents, 1);


for ix_patent=1:nr_patents
    
    % Get start and end of patent text
    % ====================================================================
    patent_text_corpus = get_patent_text_corpus(ix_find, ix_patent, ...
        nr_patents, ftset, search_corpus);

    % Lookup technology classification number
    % ====================================================================
    switch ftset.indic_filetype
         case 1
             
            % Look up USPC tech classification (sometimes called OCL)
            % ------------------------------------------------------------
            ix_find_USPC = strfind(patent_text_corpus, ftset.uspc_nr_findstr);
            all_USPC_matches = find(~cellfun(@isempty, ix_find_USPC));

            % Only look at first USPC match
            row_USPC_class = patent_text_corpus{all_USPC_matches(1)}; 

            % Extract tech class number from string
            uspc_nr{ix_patent} = row_USPC_class(6:numel(row_USPC_class));

            % Get rid of leading and trailing whitespace
            uspc_nr = strtrim(uspc_nr);
            
            
            % Look up IPC tech classification
            % ------------------------------------------------------------
            ix_find_IPC = strfind(patent_text_corpus, ftset.ipc_nr_findstr);
            all_IPC_matches = find(~cellfun(@isempty, ix_find_IPC));
            
            % Get all IPC matches
            ipc_indiv = repmat({''}, length(all_IPC_matches), 1);
            
            for ix_ipc=1:length(all_IPC_matches)
                row_IPC_class = patent_text_corpus{all_IPC_matches(ix_ipc)}; 
                % Extract tech class number from string
                ipc_extract = row_IPC_class(6:numel(row_IPC_class));
                
                % Get rid of leading and trailing whitespace
                ipc_extract = strtrim( ipc_extract );

                % Save in cell array
                ipc_indiv{ix_ipc, 1} = ipc_extract;
            end
                    
            ipc_nr{ix_patent} = ipc_indiv;               
            
        case {2, 3}
            
            % Look up USPC tech classification (sometimes called OCL)
            % ------------------------------------------------------------
            indic_uspc_find = regexp(patent_text_corpus, ...
                ftset.uspc_nr_findstr);
            
            % Make logical array
            indic_uspc_find = ~cellfun(@isempty, indic_uspc_find); 
            ix_uspc_find = find(indic_uspc_find);

            switch ftset.indic_filetype
                case 2
                     uspc_nr_ix = ix_uspc_find;
                    
                case 3
                    % Two lines below the first appearance of the search 
                    % string is where we find our tech classificiation
                    uspc_nr_ix = ix_uspc_find(1) + 2;
            end

            uspc_nr_line = patent_text_corpus(uspc_nr_ix, :);
            uspc_nr_line = uspc_nr_line{1};
            
            % Classificiations differ in length, so have to find end
            % where the classification stops.
            uspc_find_end = regexp(uspc_nr_line, ftset.uspc_nr_linestop); 
            uspc_number = strtrim( uspc_nr_line(...
                ftset.uspc_nr_linestart : uspc_find_end - 1) );
            uspc_nr{ix_patent} = uspc_number;
                        
            % Look up IPC tech classification
            % ------------------------------------------------------------
            indic_class_find = regexp(patent_text_corpus, ...
                ftset.uspc_nr_findstr);
            
    end
end
