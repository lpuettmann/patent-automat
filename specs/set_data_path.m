function build_data_path = set_data_path(ix_year)

if ispc
    build_data_path = horzcat('T:\Puettmann\patent_data_save\', ...
        num2str(ix_year));
elseif ismac
    build_data_path = horzcat('/Users/Lukas/econ/PatentData/', ...
        num2str(ix_year));
elseif and(isunix, not(ismac))
    build_data_path = horzcat('/home/lukas/ssd/PatentProject/patent_data/', ...
        num2str(ix_year));
else
    error('Not sure about the path where the data is.')
end
