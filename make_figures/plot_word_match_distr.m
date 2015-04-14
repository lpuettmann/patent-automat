close all
clear all
clc

addpath('../functions')

load('../word_match_distr_1976-1989.mat')



%%
year_start = 1976;
year_end = 1989;


%%



for w=1:size(word_match_distr,1)
    line_find_str = word_match_distr{w, 1, 1}; % all years have same word distributions
    word_name{w} = line_find_str{1};

    for ix_year = year_start:year_end
        ix_iter = ix_year - year_start + 1;
        
        word_matches_overtime(ix_iter) = word_match_distr{w, 2, ix_iter};
    end
    nr_word_matches(w) = sum(word_matches_overtime);
end
        

% Sort 
[nr_word_matches, ix_sort] = sort(nr_word_matches);
nr_word_matches = fliplr(nr_word_matches);
ix_sort = fliplr(ix_sort);

word_name = word_name(ix_sort);


% Optional: replace last stuff
nr_word_matches = [nr_word_matches(1:6), sum(nr_word_matches(7:end))];
word_name = {word_name{1:6}, 'rest'};



%% Make barchart 
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

color1_pick = [49, 130, 189] ./ 255;
my_gray = [0.8, 0.8, 0.8];


nr_word_matches = nr_word_matches / sum(nr_word_matches);
my_xaxis_labels = word_name;


figureHandle = figure;
set(gcf, 'Color', 'w');
bar(nr_word_matches, 'FaceColor', color1_pick, 'EdgeColor', 'none')
box off
set(gca,'TickDir','out') 
set(gca,'FontSize',10) % change default font size of axis labels
ylim([0, 1])
xlim([0.5, length(nr_word_matches)+0.5])

set(gca, 'XTick', 1:length(nr_word_matches)) % Set the x-axis tick labels
set(gca, 'xticklabel',{}) % turn x-axis labels off
set(gca, 'xticklabel', my_xaxis_labels); 
% set(gca, 'YTick', [], 'YColor', 'white') % turn y-axis off
rotateXLabels( gca(), -45 )



% Reposition the figure
% -----------------------------------------------------------------------
set(gcf, 'Position', [100 200 800 500]) % in vector: left bottom width height

set(figureHandle, 'Units', 'Inches');
pos = get(figureHandle, 'Position');

set(figureHandle, 'PaperPositionMode', 'Auto', 'PaperUnits', ...
    'Inches', 'PaperSize', [pos(3), pos(4)])


a = [cellstr(num2str(get(gca,'ytick')'*100))]; 
pct = char(ones(size(a,1),1)*'%'); % create a vector of '%' signs
new_yticks = [char(a),pct]; % append the '%' signs after the percentage values
set(gca,'yticklabel', new_yticks)


% Export to pdf
% -----------------------------------------------------------------------
print_pdf_name = horzcat('barchart_word_distribution_', num2str(year_start), '-',  num2str(year_end),'.pdf');
print(figureHandle, print_pdf_name, '-dpdf', '-r0')
