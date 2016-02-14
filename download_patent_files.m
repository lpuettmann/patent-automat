clear all
close all
clc

% function download_patent_files()
% Save patent files from Google patent into PatentData/[year].
 

% Get HTML from Website
google_patents_URL = 'https://www.google.com/googlebooks/uspto-patents-grants-text.html';
[webstr, status] = urlread(google_patents_URL);

if status == 0
    warning('Problem with accessing Google Patents website.')
end

fid = fopen('test.txt', 'wt');
fprintf(fid, webstr);
fclose(fid);

searchStr = 'http://storage.googleapis.com/patents/grant_full_text/';
AA = strfind(webstr, searchStr)


webstr(AA(1): AA(1) + numel(searchStr) + 18)


break


% Construct the URL
url_base = 'http://storage.googleapis.com/patents/grant_full_text/'

ix_year = 1976

if ix_year < 2002
    filetype = 'pftaps';
elseif ix_year < 2005
    filetype = 'pg';
else
    filetype = 'ipg';
end

url = [url_base, num2str(ix_year), '/', filetype]

pftaps19760106_wk01.zip'

% Determine where to save the file and how to call it.
filename = ['patent_data/', num2str(ix_year), '/', url(end-22:end)]

% Download file and save to disk.
[~, status] = urlwrite(url, filename)

% If download not successful, show warning message.
if status == 0
    warning('Download of %s not successful.', filename(18:end))
end
