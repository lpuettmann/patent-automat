function english_stop_words = define_english_stopwords()
% Load a pre-defined dictionary of English stop words. 
%   Source:   https://github.com/faridani/MatlabNLP 
% 
%   File in: MatlabNLP/nlp lib/corpora/English Stop Words/english.stop
%
%   Downloaded on 9th of December 2015.
%   By: Siamak Faridani
% 

% Load file with English stop words
fileID = fopen('english_stopwords.txt');

% Scan the text
english_stop_words = textscan(fileID, '%s', 'Delimiter', '\n');

% Close file again
fclose(fileID);

% Extract the nested cell
english_stop_words = english_stop_words{1};
