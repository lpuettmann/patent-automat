function ftset = customize_ftset(ix_year, opt2001)
% Customize file type settings (ftset)
%
%   IN:
%       - ix_year: year
%       - opt2001: pick an option for the files in 2001, either 'txt' or
%         'xml'. This is an option input, only necessary for year 2001.


%% Check inputs
assert(isnumeric(ix_year))
assert(ix_year >= 1976, 'Year too early.')
assert(ix_year <= 2015, 'Year too late')

if ix_year == 2001
    assert(nargin == 2, 'Too few arguments, 2001 file type not specified?')
end


%% Get the customized file type settings

if ((ix_year <= 2000) && (ix_year >= 1976)) || ((ix_year == 2001) && ...
        strcmp(opt2001, 'txt'))
    ftset.indic_filetype = 1;
    ftset.nr_lines4previouspatent = 1;
    ftset.nr_trunc = 4;
    ftset.indic_titlefind = 'TTL ';
    ftset.indic_abstractfind = 'ABST';
    ftset.indic_abstractend = {'BSUM', 'PARN', 'PAC '};
    ftset.indic_bodyfind = 'BSUM';
    ftset.patent_findstr = 'PATN'; % patent grant text start   
    ftset.uspc_nr_findstr = 'OCL'; % United States Patent Classification (USPC)
    ftset.ipc_nr_findstr = 'ICL '; % International Patent Classification (IPC)
    ftset.fdate_findstr = 'APD'; % file date
    ftset.fdate_linestart = 6;
    ftset.fdate_linestop = 11;
    
elseif (ix_year == 2001) && strcmp(opt2001, 'xml')
    ftset.indic_filetype = 2;
    ftset.patent_findstr = '<!DOCTYPE PATDOC PUBLIC "-//USPTO//DTD ST.32 US PATENT GRANT V2.4 2000-09-20//EN" [';
    ftset.pnr_find_str = '<B110><DNUM><PDAT>';
    ftset.nr_lines4previouspatent = 2;
    
    ftset.indic_titlefind = '<B540><STEXT><PDAT>';
    ftset.indic_abstractfind = '<SDOAB>';
    ftset.indic_abstractend = '/SDOAB>';
    ftset.indic_bodyfind = '<SDODE>';

    ftset.uspc_nr_findstr = '<B521><PDAT>';
    ftset.uspc_nr_linestart = 13;
    ftset.uspc_nr_linestop = '</PDAT>';

    ftset.indic_specialcase = 0;

    % Use a regular expression to search for one or the other
    ftset.ipc_nr_findstr = '(<B511><PDAT>)|(<B512><PDAT>)';
    ftset.ipc_nr_linestart = 13;
    ftset.ipc_nr_linestop = '</PDAT>';

    ftset.fdate_findstr = '<B220><DATE><PDAT>';
    ftset.fdate_linestart = 19;
    ftset.fdate_linestop = 24;
    
elseif (ix_year >=2002) && (ix_year <= 2004)
    ftset.indic_filetype = 2;
    ftset.nr_lines4previouspatent = 2;
    ftset.indic_titlefind = '<B540><STEXT><PDAT>';
    ftset.indic_abstractfind = '<SDOAB>';
    ftset.indic_abstractend = '/SDOAB>';
    ftset.indic_bodyfind = '<SDODE>';
    
    ftset.patent_findstr = '<?xml version="1.0" encoding="UTF-8"?>';
    ftset.pnr_find_str = '<B110><DNUM><PDAT>';
    
    ftset.uspc_nr_findstr = '<B521><PDAT>';
    ftset.uspc_nr_linestart = 13;
    ftset.uspc_nr_linestop = '</PDAT>';
    
    % Use a regular expression to search for one or the other
    ftset.ipc_nr_findstr = '(<B511><PDAT>)|(<B512><PDAT>)';
    ftset.ipc_nr_linestart = 13;
    ftset.ipc_nr_linestop = '</PDAT>';
    
    ftset.fdate_findstr = '<B220><DATE><PDAT>';
    ftset.fdate_linestart = 19;
    ftset.fdate_linestop = 24;
    
    
elseif (ix_year >=2005) && (ix_year <= 2015)
    ftset.indic_filetype = 3;
    ftset.nr_lines4previouspatent = 1;
    ftset.indic_titlefind = '<invention-title';
    ftset.indic_abstractfind = '<abstract id="abstract">';
    ftset.indic_abstractend = '</abstract>';
    ftset.indic_bodyfind = '<description id="description">';
    
    ftset.patent_findstr = '<!DOCTYPE us-patent-grant';
    ftset.pnr_find_str = '<us-patent-grant lang=';   
    ftset.uspc_nr_findstr = '<classification-national>';
    ftset.uspc_nr_linestart = 22;
    ftset.uspc_nr_linestop = '</main-classification>';
    
    if ix_year == 2005
        ftset.ipc_nr_findstr = '(<main-classification>)|(<further-classification>)';
        ftset.ipc_nr_start_str = '<classification-ipc>';
        ftset.ipc_nr_end_str = '</classification-ipc>';
        ftset.ipc_nr_linestart = 13;
        ftset.ipc_nr_linestop = '</main-classification>|(</further-classification>)';
    else
        ftset.indic_specialcase = 1;        
        ftset.ipc_nr_findstr = '<classification-ipcr>';
        ftset.ipc_nr_start_str = '<classifications-ipcr>';
        ftset.ipc_nr_end_str = '</classifications-ipcr>';
    end
    
    ftset.fdate_linestart = 7;
    ftset.fdate_linestop = 12;
    
else
    warning('The codes are not designed for year: %d.', ix_year)
end
