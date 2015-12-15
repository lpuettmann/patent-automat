function stop_words = define_stopwords()
    % Combine several lists of stop words.

    english_stop_words = define_english_stopwords();
    markup_garbage = define_markup_garbage();

    % Combine lists
    cl = [english_stop_words;
          markup_garbage];

    assert( length(english_stop_words) + length(markup_garbage) ...
        == length(cl), 'Not the right length.')
      
    % Delete any duplicates   
    [~, idx] = unique( cl );
    stop_words = cl(idx, :);
    
    % Make some checks
    for i=1:length(stop_words)
        extr_str = stop_words{i};
        check_allStr(i) = +ischar(extr_str);
    end
    assert( all( check_allStr ), ...
        'Stop words must be a cell array of strings.')
end


function markup_garbage = define_markup_garbage()
    % Define a self-selected list of markup garbage that tends to slip through
    % other parsing steps.

    % Load a list of self-selected junk words
    fileID = fopen('other_junk_words.txt');
    other_junk_words = textscan(fileID, '%s', 'Delimiter', '\n');
    other_junk_words = other_junk_words{1};
    fclose(fileID);

    % Load a list of phrases that pop up in our .txt files
    fileID = fopen('txt_markup_del_list.txt');
    txt_markup_del_list = textscan(fileID, '%s', 'Delimiter', '\n');
    txt_markup_del_list = txt_markup_del_list{1};
    fclose(fileID);

    % Load a list of phrases that pop up in our .xml (and .XML) files
    fileID = fopen('xml_markup_del_list.txt');
    xml_markup_del_list = textscan(fileID, '%s', 'Delimiter', '\n');
    xml_markup_del_list = xml_markup_del_list{1};
    fclose(fileID);

    % Put all three lists together
    markup_garbage = [other_junk_words;
                     txt_markup_del_list;
                     xml_markup_del_list];

    % Make some checks
    assert( length(other_junk_words) + length(txt_markup_del_list) + ...
        length(xml_markup_del_list) == length(markup_garbage), ...
        'Not the right length.')
end

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
end