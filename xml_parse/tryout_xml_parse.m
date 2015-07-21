close all
clear all
clc


%% Load the patent text
fname = 'pg020101.xml';
unique_file_identifier = fopen(fname, 'r');   

if unique_file_identifier == -1
    warning('Matlab cannot open the file')
end

open_file_aux = textscan(unique_file_identifier, '%s', ...
    'delimiter', '\n');
search_corpus = open_file_aux{1,1};


%% Look for patents
find_str = '<?xml version="1.0" encoding="UTF-8"?>';
% otherstring = '<B110><DNUM><PDAT>';

indic_find = strcmp(search_corpus, find_str);
ix_find = find(indic_find);

if length(ix_find) ~= length(unique(ix_find))
    warning('Elements in ix_find should all be different.')
end

nr_patents = length(ix_find);


if nr_patents < 100
    warning('The number of patents (= %d) is implausibly small', ...
        nr_patents)
end 


%% Extract patent text
ix_patent = 1;

% Get start and end of patent text
start_text_corpus = ix_find(ix_patent);

if ix_patent < nr_patents
    end_text_corpus = ix_find(ix_patent+1) - 2; % this number is hard-coded
else
    end_text_corpus = length(search_corpus);
end

patent_text_corpus = search_corpus(start_text_corpus:...
    end_text_corpus, :);

patent_str = strjoin(patent_text_corpus');

%% Read string into XML parser

% Specify project directory
choose_p = 'D:\Dropbox\0_Lukas\econ\projects\PatentSearch_Automation\patent-automat\xml_parse';

% Set Java's working directory to the current project directory
java.lang.System.setProperty('user.dir', choose_p);

xDoc = xmlreadstring(patent_str);


xDoc = xmlread('patent_example.xml');

