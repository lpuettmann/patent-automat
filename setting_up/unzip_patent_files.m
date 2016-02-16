function unzip_patent_files(year_start, year_end, parent_dname)
% Unzip patent text files from Google Patents and delete zipped files.

for ix_year=year_start:year_end
    zip_files = dir([parent_dname, '/', num2str(ix_year), ...
        '/*.zip']);

    for i=1:length(zip_files)
        zfile = [parent_dname, '/', num2str(ix_year), '/', ...
            zip_files(i).name];
        
        unzip(zfile, [parent_dname, '/', num2str(ix_year)]);
        delete(zfile)
    end
end

disp('_____________________________________________')
disp('Done unzipping files and deleted zipped files.')
