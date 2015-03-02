% Take matches of keywords in patents and delete those with patent numbers
% starting with a letter

clc
clear all
close all


addpath('matches');
addpath('functions');
addpath('make_figures');



%%
year_start = 1976;
year_end = 2015;



%%
for ix_year=year_start:year_end

    fprintf('Enter year %d:\n', ix_year)

    % -------------------------------------------------------------
    week_end = set_weekend(ix_year); 
        

    % Load matches
    % -------------------------------------------------------------
    load_file_name = horzcat('patent_keyword_appear_', num2str(ix_year));
    load(load_file_name)
    
    
    nr_patents_yr = size(patent_keyword_appear, 1);
    
    % Delete 4th column for years < 2001. I previously saved the year
    % there, but I stopped doing that (it doesn't add any new information)
    if ix_year < 2002
        aux_part1 = patent_keyword_appear(:, 1:3);
        aux_part2 = patent_keyword_appear(:, 5);
        patent_keyword_appear = [aux_part1, aux_part2];
    end

    patent_numbers = patent_keyword_appear(:, 1);
    
    nr_keyword_per_patent = cell2mat(patent_keyword_appear(:, 2));
    
    % Make an index of a patent
    % -------------------------------------------------------------
    automix = zeros(nr_patents_yr, 1);
    automix = log(1 + nr_keyword_per_patent);
    
    
    % Throw out patents that start with a letter
    % -------------------------------------------------------------
    cleaned_automix = automix;
    cleaned_full_info = patent_numbers;


    ix_save = 1; % initalize saving index

    for ix_patent = 1:nr_patents_yr

        extract_row = patent_numbers{ix_patent};

        if strcmp(extract_row(1), 'D') ... % design patents
                | strcmp(extract_row(1), 'P') ... % PP: plant patents
                || strcmp(extract_row(1), 'R') ... % reissue patents
                | strcmp(extract_row(1), 'T') ... % defensive publications
                | strcmp(extract_row(1), 'H') ... % SIR (statutory invention registration)
                | strcmp(extract_row(1), 'X') % early X-patents
           save_row_delete(ix_save) = ix_patent;
           ix_save = ix_save + 1;
        end   
    end

    save_row_delete = save_row_delete';
    

    %
    % -------------------------------------------------------------
    cleaned_full_info(save_row_delete) = [];
    cleaned_automix(save_row_delete) = [];

    if nr_patents_yr - length(save_row_delete) ~= length(cleaned_full_info)
        warning('They should be the same')
    end


    patent_nr_letter(ix_year-year_start+1) = length(save_row_delete);
    share_w_letter(ix_year-year_start+1) = length(save_row_delete)/nr_patents_yr;
    
    
    % -------------------------------------------------------------
    fprintf('Patent numbers that start with a letter: %d/%d = %s percent.\n', ...
        length(save_row_delete), nr_patents_yr, ...
        num2str(length(save_row_delete)/nr_patents_yr*100))
    
    
    % Delete first and last letter
    % -------------------------------------------------------------
    patent_number_cleaned =  repmat({''}, length(cleaned_full_info), 1);
    for ix_patent = 1:length(cleaned_full_info)

        extract_row = cleaned_full_info{ix_patent};

        if ix_year >= 2002 % after (not incl.) 2001: delete first letter only
            trunc_row = extract_row(2:end);
        else % before 2001: delete first and last letter
            trunc_row = extract_row(2:end-1);
        end
        
        patent_number_cleaned{ix_patent} = trunc_row;
    end

    if length(cleaned_automix) ~= length(patent_number_cleaned)
        warning('They should be the same')
    end
    
    
    % Write to csv file
    % -------------------------------------------------------------
    save_name = horzcat('cleaned_automix_patentnr_4transfer_', num2str(ix_year), '.csv');
    csvwrite(save_name, patent_number_cleaned);
    save_name = horzcat('cleaned_automix_4transfer_', num2str(ix_year), '.csv');
    csvwrite(save_name, cleaned_automix);
    disp('Finished saving csv files.')
    

    
    % Clear variables from memory that could cause problems
    % -------------------------------------------------------------
    keep year_start year_end patent_nr_letter share_w_letter
    
    disp('------------------------------------------------------------------')
end

disp('FINISH LOOP')
disp('==================================================================')



%% Plot
% ========================================================================


% Some settings for the plots
plot_time = year_start:year_end;
color1_pick = [0.7900, 0.3800, 0.500];
color2_pick = [0.000,0.639,0.561];
color3_pick = [0.890,0.412,0.525];


figureHandle = figure;
plot_series = share_w_letter*100;

plot(plot_time, plot_series, 'Color', color3_pick, 'LineWidth', 1.4, ...
    'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', color3_pick)

set(gca,'TickDir','out'); 
box off
set(gca,'FontSize',12) % change default font size of axis labels
set(gcf, 'Color', 'w');
xlim([year_start year_end]);
% ylim([0 ceil(max(plot_series))])
ylim([0 100])
ylabel('percentage (%)')

set(0,'DefaultTextFontName','Palatino') % set font
set(0,'DefaultAxesFontName','Palatino') % set font


%% Change position and size
set(gcf, 'Position', [100 200 600 400]) % in vector: left bottom width height
set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');
set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


%% Export to pdf
print_pdf_name = horzcat('automix_named_patent_nr_stats_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')

