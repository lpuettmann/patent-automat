close all
clear all
clc

addpath('../functions')



%%
year_start = 1976;
year_end = 2015;

% load_file_name = horzcat('../word_match_distr_', num2str(year_start), ...
%     '-', num2str(year_end), '.mat');
% load(load_file_name)

load('D:\US_PatentsData\patent-automat\word_match_distr_1976-2015.mat')


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
cutoff_par = 25;

nr_word_matches = [nr_word_matches(1:cutoff_par), sum(nr_word_matches(cutoff_par+1:end))];
word_name = {word_name{1:cutoff_par}, 'Other'};


% Also attach the not assigned matches
nr_word_matches = [nr_word_matches(1:end), sum(rest_matches)];
word_name = {word_name{1:end}, 'Not assigned'};



% Normalize word matches to show shares
nr_word_share = nr_word_matches / sum(nr_word_matches);





%% Make table
table_word_distr = table(nr_word_matches', round(nr_word_share'*1000)/10, ...
    'RowNames', word_name, 'VariableNames', {'Count', 'Share'})

%% Print to .txt file in Latex format
printname = 'table_word_distribution.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Distribution over word matches}}\n');
fprintf(FID,'\\label{tab:word_distribution}\n');
fprintf(FID,'\\begin{tabular}{lrr}\n');
fprintf(FID,'\\toprule \\addlinespace[0.5em]\n');
fprintf(FID,' & \\textbf{Count} & \\textbf{Share (\\%%)}\\tabularnewline[0.1cm]\n');
fprintf(FID,'\\midrule \\addlinespace[0.5em]\n');

for w=1:length(nr_word_matches)
    fprintf(FID,'%s & %d & %3.1f \\tabularnewline[0.1cm]\n', word_name{w}, nr_word_matches(w), nr_word_share(w)*100);
end

fprintf(FID,' & \\textbf{%d} & \\textbf{100} \\tabularnewline[0.1cm]\n', sum(nr_word_matches));

fprintf(FID,'\\bottomrule\n');
fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\begin{tablenotes}\n');
fprintf(FID,'\\small\n');
fprintf(FID,'\\item \\textit{Note:} Full words are delimited by spaces, line beginnings or endings or characters such as a comma, period, etc.\n');
fprintf(FID,'\\item \\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID,'\\end{tablenotes}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 

fprintf('Saved: %s.\n', printname)


break

%% Plot the not assigned values over time
plot(rest_matches)




%% Make barchart 
set(0, 'DefaultTextFontName', 'Palatino')
set(0, 'DefaultAxesFontName', 'Palatino')

color1_pick = [49, 130, 189] ./ 255;
my_gray = [0.8, 0.8, 0.8];

my_xaxis_labels = word_name;


figureHandle = figure;
set(gcf, 'Color', 'w');
bar(nr_word_share, 'FaceColor', color1_pick, 'EdgeColor', 'none')
box off
set(gca,'TickDir','out') 
set(gca,'FontSize',10) % change default font size of axis labels
ylim([0, 1])
xlim([0.5, length(nr_word_share)+0.5])

set(gca, 'XTick', 1:length(nr_word_share)) % Set the x-axis tick labels
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
