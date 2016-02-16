function delete_zip_patent_files(year_start, year_end, parent_dname)
% Delete zipped files.
 

for ix_year=year_start:year_end
    zip_files = dir([parent_dname, '/', num2str(ix_year), ...
        '/*.zip']);

    for i=1:length(zip_files)
        zfile = [parent_dname, '/', num2str(ix_year), '/', ...
            zip_files(i).name];
        delete(zfile)
    end
end

disp('_____________________________________________')
disp('Deleted zipped files.')
