function sic_automix_allyears = compile_sic_automix_table(year_start, ...
    year_end)

sic_automix_allyearsMat = [];

for ix_year=year_start:year_end
    ix_save = ix_year - year_start + 1;
    
    load_file_name = horzcat('sic_automix_yres_', num2str(ix_year));
    load(load_file_name)
    
    sic_automix_yres.year = repmat(ix_year, size(sic_automix_yres.sic));

    % Convert table to matrix
    sic_automix_yres_tempMat = table2array( sic_automix_yres );
    
    % Put yearly tables underneath
    sic_automix_allyearsMat = [sic_automix_allyearsMat;
                               sic_automix_yres_tempMat];
end

% Extract variable names
varnames = sic_automix_yres.Properties.VariableNames;

% Convert back to table
sic_automix_allyears = array2table(sic_automix_allyearsMat);

% Attach variable names back
sic_automix_allyears.Properties.VariableNames = varnames;
