function download_patent_files(year_start, year_end)
% Save patent files from Google patent into PatentData/[year].
 

%% Get HTML from website
disp('Get names of files to download.')
google_patents_URL = 'https://www.google.com/googlebooks/uspto-patents-grants-text.html';
[webStr, status] = urlread(google_patents_URL);

if status == 0
    warning('Problem with accessing Google Patents website.')
end


%% Find the download links on the webpage
url_base = 'http://storage.googleapis.com/patents/grant_full_text/';
patternStart = strfind(webStr, url_base);

searchStrEnd = '.zip';
patterEnd = strfind(webStr, searchStrEnd);

for i=1:length(patternStart)
    startStr = patternStart(i);
    endStr = min( patterEnd(patterEnd > startStr) ) + 3;
    download_url{i, 1} = webStr(startStr:endStr);
end


%% Run some checks to make sure that the links look plausible
assert( not( isempty( download_url ) ) )
assert( iscell( download_url ) )

for i=1:length(download_url)
    extrStr = download_url{i};
    assert( strcmp( extrStr(1:numel(url_base)), url_base), ...
        '%d: Wrong start', i)
    assert( strcmp( extrStr(end-3:end), '.zip' ), '%d:  Wrong ending', i)
    assert( numel(extrStr) > 68, '%d: Implausibly short.', i)
    assert( numel(extrStr) < 100, '%d: Implausibly long', i)
end

% Extract the year index from every link
year_indices = cellfun(@(x) x(numel(url_base) + 1 : numel(url_base) + 4), ...
    download_url, 'UniformOutput', false);
year_indices = cellfun(@str2num, year_indices, 'UniformOutput', false);
year_indices = cell2mat(year_indices);

assert( all( (year_indices >= year_start) & (year_indices <= year_end) ) )


%% Access URLs and download files
parent_dname = 'patent_data';

[status, ~, ~] = mkdir(parent_dname);
assert( status ~= 0 )

for ix_year=year_start:year_end
    [status, ~, ~] = mkdir('patent_data', num2str(ix_year));
    assert( status ~= 0 )

    extrInd = find( year_indices == ix_year );
    url_yearly = download_url(extrInd);

    % Check that known format string is in there
    if ix_year < 2002
        filetype = 'pftaps';
    elseif ix_year < 2005
        filetype = 'pg';
    else
        filetype = 'ipg';
    end

    indic_checkFormat = regexp(url_yearly, filetype);
    assert( not( any( cellfun(@isempty, indic_checkFormat) ) ), ...
        'Format looks wrong in year %d.', ix_year)

    tic
    fprintf('Downloading files %d (%d files): ', ix_year, length(url_yearly))
    for i=1:length(url_yearly)
        url = url_yearly{i};

        % Determine where to save the file and how to call it.
        filename = [parent_dname, '/', url(numel(url_base) + 1:end)];

        % Download file and save to disk.
        [~, status] = urlwrite(url, filename);

        % If download not successful, show warning message.
        if status == 0
            warning('Download of %s not successful.', filename(18:end))
        end

        fprintf('.')
    end
    fprintf('\n')
    fprintf('Time: %d minutes.\n', round(toc/60) )
end

disp('_____________________________________________')
disp('Done with downloading files from Google Patents.')
