function save_patent_keyword_appear2mat(patent_keyword_appear, ix_year)

save_name = horzcat('patent_keyword_appear_', num2str(ix_year), '.mat');
matfile_path_save = fullfile('matches', save_name);
save(matfile_path_save, 'patent_keyword_appear');    
fprintf('Saved: %s.\n', save_name)
