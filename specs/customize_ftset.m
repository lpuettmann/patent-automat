function ftset = customize_ftset(ix_year)
% Customize file type settings (ftset)

if (ix_year < 2002) && (ix_year > 1975)
    ftset.indic_filetype = 1;
    ftset.nr_lines4previouspatent = 1;
    ftset.nr_trunc = 4;
    ftset.indic_titlefind = 'TTL ';
    ftset.indic_abstractfind = 'ABST';
    ftset.indic_abstractend = {'BSUM', 'PARN', 'PAC '};
    ftset.indic_bodyfind = 'BSUM';
    
elseif (ix_year >=2002) && (ix_year < 2005)
    ftset.indic_filetype = 2;
    ftset.nr_lines4previouspatent = 2;
    ftset.indic_titlefind = '<B540><STEXT><PDAT>';
    ftset.indic_abstractfind = '<SDOAB>';
    ftset.indic_abstractend = '/SDOAB>';
    ftset.indic_bodyfind = '<SDODE>';
    
elseif (ix_year >=2005) && (ix_year < 2016)
    ftset.indic_filetype = 3;
    ftset.nr_lines4previouspatent = 1;
    ftset.indic_titlefind = '<invention-title';
    ftset.indic_abstractfind = '<abstract id="abstract">';
    ftset.indic_abstractend = '</abstract>';
    ftset.indic_bodyfind = '<description id="description">';
    
else
    warning('The codes are not designed for year: %d.', ix_year)
end