function build_data_path = set_data_path(ix_year, opt2001)

[~, cname] = system('hostname');
cname = strtrim(cname);

if ispc && strcmp(cname, 'E700-Puettmann')
    
    if (ix_year == 2001) && strcmp(opt2001, 'xml')
        build_data_path = 'T:\Puettmann\patent_project\2001_compare_data';
    else
        build_data_path = horzcat( ... 
            'T:\Puettmann\patent_project\patent_data_save\', ...
            num2str(ix_year));
    end
    
elseif ismac
    build_data_path = horzcat('/Users/Lukas/econ/PatentData/', ...
        num2str(ix_year));
elseif and(isunix, not(ismac))
    build_data_path = horzcat('/home/lukas/ssd/PatentProject/patent_data/', ...
        num2str(ix_year));
else
    error('Not sure about the path where the data is.')
end
