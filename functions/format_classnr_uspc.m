function outData = format_classnr_uspc(inData)

% Check for correct inputs
assert( iscell( inData ) )

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
containPunct = cellfun(@(x) any(x), isstrprop(intermData, 'punct'));
allCheck = containAlpha + containPunct;
iCheck = find( allCheck );

% Delete the trailing alphabetic part or punctuation marks
for j=1:length( iCheck )
    pickCheck = intermData{ iCheck(j) };
    delCheck = isstrprop(pickCheck, 'alpha');    
    firstAlpha = find( delCheck );
    newEntry = pickCheck(1 : firstAlpha - 1);
    
    if isempty( newEntry )
        newEntry = '000';
    end
    
    % Put number stripped of characters back
    intermData{ iCheck(j) } = newEntry;
    
    fprintf('(%d/%d) Replace ''%s'' with ''%s''.\n',iCheck(j), ...
        length( inData ), pickCheck, newEntry)
end   

% Convert strings to numbers
intermData = cellfun(@str2num, intermData, 'UniformOutput', false);

assert( not( any( cellfun(@isempty, intermData) ) ) )

% Convert cell array to matrix
outData = cell2mat(intermData);

assert( length( outData ) == length( inData ) )
