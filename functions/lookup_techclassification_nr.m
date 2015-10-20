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
            ix_find_uspc = strfind(patent_text_corpus, ftset.uspc_nr_findstr);
            all_uspc_matches = find(~cellfun(@isempty, ix_find_uspc));

            % Only look at first USPC match
            row_uspc_class = patent_text_corpus{all_uspc_matches(1)}; 

            % Extract tech class number from string
            uspc_nr{ix_patent} = row_uspc_class(6:numel(row_uspc_class));

            % Get rid of leading and trailing whitespace
            uspc_nr = strtrim(uspc_nr);
            
            
            % Look up IPC tech classification
            % ------------------------------------------------------------
            ix_find_ipc = strfind(patent_text_corpus, ftset.ipc_nr_findstr);
            all_ipc_matches = find(~cellfun(@isempty, ix_find_ipc));
            
            % Get all IPC matches
            ipc_indiv = repmat({''}, length(all_ipc_matches), 1);
            
            for ix_ipc=1:length(all_ipc_matches)
                row_ipc_class = patent_text_corpus{all_ipc_matches(ix_ipc)}; 
                % Extract tech class number from string
                ipc_extract = row_ipc_class(6:numel(row_ipc_class));
                
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
            indic_ipc_find = regexp(patent_text_corpus, ...
                ftset.ipc_nr_findstr);
            
            % Make logical array
            indic_ipc_find = ~cellfun(@isempty, indic_ipc_find); 
            all_ipc_matches = find(indic_ipc_find);
            
            % Get all IPC matches
            ipc_indiv = repmat({''}, length(all_ipc_matches), 1);
            
            for ix_ipc=1:length(all_ipc_matches)
                row_ipc_class = patent_text_corpus{all_ipc_matches(ix_ipc)}; 
                
                % Classificiations differ in length, so have to find end
                % where the classification stops.
                ipc_find_end = regexp(row_ipc_class, ftset.ipc_nr_linestop);
                
                % Extract tech class number from string
                ipc_extract = strtrim( row_ipc_class(...
                    ftset.uspc_nr_linestart : ipc_find_end - 1) );
                
                % Get rid of leading and trailing whitespace
                ipc_extract = strtrim( ipc_extract );

                % Save in cell array
                ipc_indiv{ix_ipc, 1} = ipc_extract;
            end
            ipc_nr{ix_patent} = ipc_indiv;           
    end
end
