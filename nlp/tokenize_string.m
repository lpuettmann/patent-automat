function tokens = tokenize_string(inStr, english_stop_words)
% Converts a string to a cell array of strings (tokens.)
%
%   IN: 
%       - [REQUIRED] inStr: string
%       - [OPTIONAL] english_stop_words: cell array of strings to be 
%           excluded. If no list is provided, it does not remove any stop
%           words.
%
%   OUT: 
%       - tokens: cell array of tokens.
%
%   REQUIREMENTS: 
%       - This function calls the function porterStemmer.m which
%         must be on the Matlab search path. 
%
%
%

%% Run checks for correct inputs
assert( not( iscell(inStr) ), 'Input cannot be cell array.')
assert( ischar(inStr), 'Input must be a string')
assert( not( isempty( inStr ) ), 'Cannot be empty string.')

if nargin == 2
    for i=1:length(english_stop_words)
        extr_str = english_stop_words{i};
        check_allStr(i) = +ischar(extr_str);
    end
    assert( all( check_allStr ), ...
        'Stop words must be a cell array of strings.')
end


%% If no list of stop words provided, default to no stop words
if nargin < 2
    english_stop_words = {};
end


%% Tokenize

% Cut leading and trailing whitespace
inStr = strtrim(inStr);

% Convert string to lower case
inStr = lower(inStr);

% Split string into separate tokens
delimiter = {' ', ',', '.', ')', '(', '"', ';', ':', '''', '#', '<', ...
    '>', '!', '?', '=', '+', '\\', '/', '&'};
inStr = strsplit(inStr, delimiter);

% Remove stop words
inStr = setdiff(inStr, english_stop_words, 'stable');

% Transform words into their word stems
for i=1:length(inStr)
    inString = inStr{i};
    word_stem = porterStemmer(inString);
    tokens{i, 1} = word_stem;
end

% Delete empty tokens
ixCellEmpty = cellfun(@isempty, tokens);
tokens(ixCellEmpty) = [];

% Delete all tokens that contain numbers
indicCellwNum = isstrprop(tokens, 'digit');
ixCellwNum = cellfun(@max, indicCellwNum);
tokens(ixCellwNum) = [];

% Delete tokens that are too short
indicCellNumel = cellfun(@numel, tokens);
ixToken2Short = (indicCellNumel <= 2);
tokens( find(ixToken2Short) ) = [];

