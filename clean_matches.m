function clean_matches(year_start, year_end)
% Take matches of keywords in patents and delete those with patent numbers
% starting with a letter. Clean patent numbers.

tic

patclean_stats.weekmean_len_pattxt = [];

for ix_year = year_start:year_end
    ix_iter = ix_year - year_start + 1;
    
    % Load matches
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)


    % Load patent_index for year
    % -------------------------------------------------------------------
    build_load_filename = horzcat('patent_index_', num2str(ix_year), ...
        '.mat');
    load(build_load_filename)
      
    week_start = 1;
    week_end = set_weekend(ix_year); 
  
    if not( size(pat_ix, 1) == week_end )
        warning('pat_ix (length = %d) should have length %d.', ...
            size(pat_ix, 1), week_end)
    end
    
    length_pattext = [];
    weekmean_len_pattxt = zeros(length(week_start:week_end), 1);
    
    for ix_week=week_start:week_end
        ix_find = pat_ix{ix_week, 2};
        wly_lenpattext = ix_find(2:end) - ix_find(1:end-1);
        % Assumption: last patent gets average length of weekly file (problem:
        % I didn't save the length of the weekly file, opening it again here would
        % take a long time)
        wly_lenpattext = [wly_lenpattext; round(mean(wly_lenpattext))];
        weekmean_len_pattxt(ix_week) = mean(wly_lenpattext);
        length_pattext = [length_pattext; wly_lenpattext];
    end
    
    if size(length_pattext) ~= size(patent_keyword_appear.patentnr, 1)
        warning('Should be equal.')
    end
        
    patclean_stats.yearmean_len_pattxt(ix_iter) = mean(length_pattext);
    patclean_stats.weekmean_len_pattxt = [...
        patclean_stats.weekmean_len_pattxt;
        weekmean_len_pattxt];
           
    % Find numbers starting with a letter
    % Number of patents per ix_year
    nr_patents_yr = size(patent_keyword_appear.patentnr, 1);

    ix_save = 1; % initalize saving index

    for ix_patent = 1:nr_patents_yr
        extract_row = patent_keyword_appear.patentnr{ix_patent};

        if strcmp(extract_row(1), 'D') ... % design patents
                || strcmp(extract_row(1), 'P') ... % PP: plant patents
                || strcmp(extract_row(1), 'R') ... % reissue patents
                || strcmp(extract_row(1), 'T') ... % defensive publications
                || strcmp(extract_row(1), 'H') ... % SIR (statutory invention registration)
                || strcmp(extract_row(1), 'X') % early X-patents
           save_row_delete(ix_save) = ix_patent;
           ix_save = ix_save + 1;
        end   
    end

    save_row_delete = save_row_delete';
    
    
    % Define new data structure to hold the results "patsearch_results"
    patsearch_results = patent_keyword_appear;
    
    patsearch_results.length_pattext = length_pattext;
    
    % Delete patents that start with letter
    patsearch_results.patentnr(save_row_delete) = [];
    patsearch_results.classnr_uspc(save_row_delete) = [];
    patsearch_results.classnr_ipc(save_row_delete) = [];
    patsearch_results.week(save_row_delete) = [];
    patsearch_results.title_matches(save_row_delete, :) = []; % matrix not vector
    patsearch_results.abstract_matches(save_row_delete, :) = []; % matrix not vector
    patsearch_results.body_matches(save_row_delete, :) = []; % matrix not vector
    patsearch_results.length_pattext(save_row_delete) = [];
    
    if nr_patents_yr - length(save_row_delete) ~= size(...
            patsearch_results.patentnr, 1)
        warning('Should be equal.')
    end
    
    if length(patent_keyword_appear.dictionary) ~= size(...
            patsearch_results.title_matches, 2)
        warning('title_matches does not have the right size for all dictionary words.')
    elseif length(patent_keyword_appear.dictionary) ~= size(...
            patsearch_results.abstract_matches, 2)
        warning('abstract_matches does not have the right size for all dictionary words.')
    elseif length(patent_keyword_appear.dictionary) ~= size(...
            patsearch_results.body_matches, 2)
        warning('body_matches does not have the right size for all dictionary words.')
    end
    
    if size(patsearch_results.patentnr, 1) ~= size(...
            patsearch_results.title_matches, 1)
        warning('title_matches does not have the right size for all patents.')
    elseif size(patsearch_results.patentnr, 1) ~= size(...
            patsearch_results.abstract_matches, 1)
        warning('abstract_matches does not have the right size for all patents.')
    elseif size(patsearch_results.patentnr, 1) ~= size(...
            patsearch_results.body_matches, 1)
        warning('body_matches does not have the right size for all patents.')
    end
    
    
    % Save some information on the deleted named patents
    patclean_stats.patent_nr_letter(ix_iter) = length(save_row_delete);
    patclean_stats.share_w_letter(ix_iter) = length(save_row_delete) / ...
        nr_patents_yr;
    
    
    % Delete first (and last [for some]) letter of patent numbers
    patent_number_cleaned =  repmat({''}, size(patsearch_results.patentnr, ...
        1), 1);
    for ix_patent = 1:size(patsearch_results.patentnr, 1)

        extract_row = patsearch_results.patentnr{ix_patent};

        if ix_year >= 2002 % after (not incl.) 2001: delete first letter only
            trunc_row = extract_row(2:end);
        else % before 2001: delete first and last letter
            trunc_row = extract_row(2:end-1);
        end
        
        patent_number_cleaned{ix_patent} = trunc_row;
    end
    
    % Insert truncated patent numbers back into patent result table
    patsearch_results.patentnr = patent_number_cleaned;
    

    % Save
    save_name = horzcat('patsearch_results_', num2str(ix_year), '.mat');
    matfile_path_save = fullfile('cleaned_matches', save_name);
    save(matfile_path_save, 'patsearch_results');    
    fprintf('Saved: %s.\n', save_name)

    % Clear variables from memory that could cause problems
    keep year_start year_end patclean_stats
end


% Save some statistics about cleaning the matches
save('output/patclean_stats.mat', 'patclean_stats');    
fprintf('Saved: %s.\n', 'patclean_stats.mat')

toc
