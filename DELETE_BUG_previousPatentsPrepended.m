close all
clear all
clc



year_start = 1976;
year_end = 2001;


for ix_year = year_start:year_end
    ix_iter = ix_year - year_start + 1;
    
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)
    
    nr_patents = size(patent_keyword_appear.patentnr, 1);
    
    unique_nrpat = unique(patent_keyword_appear.patentnr);
    
    if not(size(unique_nrpat) == size(nr_patents))
        warning('There are duplicates.')
    end
    
    
    ixBrake = find((cell2mat(patent_keyword_appear.week) == 1));
    weekDiff = diff(ixBrake);
    weekDiff = find(weekDiff>1);
    
    ixNewYear = ixBrake(weekDiff + 1);
                

    % Delete all the wrong patents
    deleteStop = max(ixNewYear) - 1;
    
    newTemp = patent_keyword_appear;  
    
    newTemp.patentnr(1:deleteStop) = [];
    newTemp.classnr(1:deleteStop) = [];
    newTemp.week(1:deleteStop) = [];
    newTemp.NAMkeyword_count(1:deleteStop) = [];
    newTemp.matches(1:deleteStop, :) = []; % matrix not vector   
    
        
    % Summarize matches
    tableMatches = table(sum(newTemp.matches,1)', ...
        'RowNames', newTemp.dictionary, 'Variablenames', ...
        {'number_of_matches'});
    
    fprintf('\t<strong>Year: %d</strong>\n', ix_year)
    fprintf('\tAfter cleaning, number of patents: %d.\n', size(newTemp.patentnr,1))
    disp(tableMatches)


    
    % Check again
    New_ixBrake = find((cell2mat(newTemp.week) == 1));
    New_weekDiff = diff(New_ixBrake);
    New_weekDiff = find(New_weekDiff>1);
    
    New_ixNewYear = New_ixBrake(New_weekDiff + 1);
    
    if not(isempty(New_weekDiff))
        warning('Week 1 appears not consecutively.')
        fprintf('Changes: %d.\n', New_ixNewYear)
    else
        disp('All fine, weeks are consecutive')
    end
    
    
    % Save the cleaned results again
    patent_keyword_appear = newTemp;
    
    save_name = horzcat('patent_keyword_appear_', num2str(ix_year), '.mat');
    matfile_path_save = fullfile('matches', save_name);
    save(matfile_path_save, 'patent_keyword_appear');    
    fprintf('Saved: %s.\n', save_name)
    
    disp('--------------------------------------------------------------')
end










