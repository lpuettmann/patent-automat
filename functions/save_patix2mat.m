function save_patix2mat(pat_ix, ix_year)

save_name = horzcat('patent_index_', num2str(ix_year), '.mat');
matfile_path_save = fullfile('patent_index', save_name);
save(matfile_path_save, 'pat_ix');    
fprintf('Saved: %s.\n', save_name)
