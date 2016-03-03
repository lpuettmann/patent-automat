function outData = format_classnr_uspc(inData)

% Break strings apart at first whitespace
intermData = cellfun(@strtok, inData, 'UniformOutput', false);

% Find out which strings are longer than 3
l = cell2mat( cellfun(@numel, intermData, 'UniformOutput', false) );
iTrunc = (l > 3);

strTrunced = cellfun(@(x) x(1:3), intermData(iTrunc), ...
    'UniformOutput', false); % shorten (truncate) the long strings
intermData(iTrunc) = strTrunced; % insert them back

% Check if there is still any letter in that string
containAlpha = cellfun(@(x) any(x), isstrprop(intermData, 'alpha'));
iAlpha = find( containAlpha );

% Delete the trailing alphabetic part for those patents that still contain
% some
for j=1:length( iAlpha )
    pickAlpha = intermData{ iAlpha(j) };
    delAlpha = isstrprop(pickAlpha, 'alpha');
    firstAlpha = find( delAlpha );
    newEntry = pickAlpha(1 : firstAlpha - 1);
    
    % Put number stripped of characters back
    intermData{ iAlpha(j) } = newEntry;
    
    fprintf('[%d:] (%d) Replace ''%s'' with ''%s''.\n', ix_year, ...
        iAlpha(j), pickAlpha, newEntry)
end   

% Convert strings to numbers
intermData = cellfun(@str2num, intermData, 'UniformOutput', false);

assert( not( isempty( intermData ) ) )

% Convert cell array to matrix
outData = cell2mat(intermData);

assert( length( outData ) == length( inData ) )
