function tokens = tokenize_string(inStr, indicStemmer, ...
    stop_words)
% Converts a string to a cell array of shortened word stems (tokens.)
%
%   IN: 
%       - [REQUIRED] inStr: string
%       - [REQUIRED] indicStemmer: string
%                    Choose: 
%                           - 'porter': Porter stemmer
%                           - 'snowball': "Snowball" Porter 2 stemmer
%       - [OPTIONAL] stop_words: cell array of strings to be 
%           excluded. If no list is provided, it does not remove any stop
%           words
%
%   OUT: 
%       - tokens: cell array of tokens.
%
%   REQUIREMENTS: 
%       - porterStemmer.m and porterStemmer2.m must be on Matlab's search 
%       path. 
%

%% Run checks for correct inputs
assert( not( iscell(inStr) ), 'Input cannot be cell array.')
assert( ischar(inStr), 'Input must be a string')
assert( not( isempty( inStr ) ), 'Cannot be empty string.')

% error(nargchk(1,3,nargin));

if nargin < 2
    error('Too few inputs specified.')
   
elseif nargin == 2
    assert(ischar(indicStemmer), 'Not specified choice of stemmer.');
    
elseif nargin == 3
    for i=1:length(stop_words)
        extr_str = stop_words{i};
        check_allStr(i) = +ischar(extr_str);
    end
    assert( all( check_allStr ), ...
        'Stop words must be a cell array of strings.')
end


%% If no list of stop words provided, default to no stop words
if nargin < 3
    stop_words = {};
end


%% Tokenize

% Cut leading and trailing whitespace
inStr = strtrim(inStr);

% Convert string to lower case
inStr = lower(inStr);

% Split string into separate tokens
delimiter = {' ', ',', '.', ')', '(', '"', ';', ':', '''', '#', '<', ...
    '>', '!', '?', '=', '+', '\\', '/', '&', '*', '@', '[', ']', ...
    '|', '{', '}', '`', '$'};
inStr = strsplit(inStr, delimiter);

% Remove stop words
inStr = setdiff(inStr, stop_words, 'stable');

%% Stem: transform words into their word stems
for i=1:length(inStr)
    inString = inStr{i};
    
    switch indicStemmer
        case 'porter1'
            word_stem = porterStemmer(inString);
            
        case 'snowball'
            word_stem = porterStemmer2(inString);
    end
    
    tokens{i, 1} = word_stem;
end

%% Delete uninformative tokens

% Delete empty tokens
% --------------------------
ixCellEmpty = cellfun(@isempty, tokens);
tokens(ixCellEmpty) = [];

% Delete all tokens that contain numbers
% --------------------------
indicCellwNum = isstrprop(tokens, 'digit');
ixCellwNum = cellfun(@max, indicCellwNum);
tokens(ixCellwNum) = [];

% Delete tokens that are too short
% --------------------------
indicCellNumel = cellfun(@numel, tokens);
ixToken2Short = (indicCellNumel <= 2);
tokens( find(ixToken2Short) ) = [];

% Delete all tokens that do not contain at least one alphabetic letter.
% This also deletes empty cells.
% --------------------------
indicCellNoAlph = isstrprop(tokens, 'alpha');
% Take max to find strings with at least one alphanumeric character
ixCellAlph = cellfun(@max, indicCellNoAlph);
% ixCellNoAlph = find(ixCellAlph == 0);
% tokens(ixCellNoAlph) = [];
tokens( not(ixCellAlph) ) = [];

% Delete leading or trailing punctuation, so transform "--automat" into 
% "automat"
% --------------------------
tokens = strtrim_punctuation(tokens);
