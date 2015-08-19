function make_table_yearsstats(year_start, year_end)

%% Load summary data
build_load_filename = horzcat('allyr_patstats_', num2str(year_start), ...
    '-', num2str(year_end), '.mat');
load(build_load_filename)

clean_ix = [0; allyr_patstats.ix_new_year(2:end); ...
    length(allyr_patstats.nr_patents_per_week)];

for t=1:length(year_start:year_end)
    ix_start = clean_ix(t) + 1;
    ix_stop = clean_ix(t + 1);
    
    nr_patents_per_year(t) = sum( allyr_patstats.nr_patents_per_week(...
        ix_start : ix_stop) );
    total_alg1_per_year(t) = sum( allyr_patstats.total_alg1_week(...
        ix_start : ix_stop) );
end
    


%% Print to .txt file in Latex format
printname = 'output/table_yearsstats.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}[!htb]\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Overview of yearly classified patents}}\n');
fprintf(FID,'\\label{table:table_yearsstats}\n');
fprintf(FID,'\\begin{tabular}{lrrrllrrrllrrr}\n'); 
fprintf(FID,'\\toprule \\addlinespace[0.5em]\n');
fprintf(FID,' & \\textbf{\\#A} & \\textbf{\\#P} & \\textbf{\\%%} & \\phantom{aaa} & & \\textbf{\\#A} & \\textbf{\\#P} & \\textbf{\\%%} & \\phantom{aaa} & & \\textbf{\\#A} & \\textbf{\\#P} & \\textbf{\\%%}\\tabularnewline[0.1cm]\n');
fprintf(FID,'\\midrule \\addlinespace[0.5em]\n');

addyear = 13;
addyear2 = addyear*2;

for t=1:13
    ix_year = year_start + t - 1;
   
    fprintf(FID,'%d & %d & %d & %3.1f & & %d & %d & %d & %3.1f & & %d & %d & %d & %3.1f \\tabularnewline[0.1cm]\n', ...
        ix_year, total_alg1_per_year(t), nr_patents_per_year(t), ...
        total_alg1_per_year(t)/nr_patents_per_year(t)*100, ...
        ix_year + addyear, total_alg1_per_year(t + addyear), ...
        nr_patents_per_year(t + addyear), total_alg1_per_year(t + ...
        addyear)/nr_patents_per_year(t + addyear)*100, ix_year + ...
        addyear2, total_alg1_per_year(t + addyear2), ...
        nr_patents_per_year(t + addyear2), ...
        total_alg1_per_year(t + addyear2)/nr_patents_per_year(t + ...
        addyear2)*100);
end
 
fprintf(FID,'& & & & & & & & & & 2015$^3$ & %d & %d & %3.1f  \\tabularnewline[0.1cm]\n', ...
    total_alg1_per_year(end), nr_patents_per_year(end), ...
    total_alg1_per_year(end)/nr_patents_per_year(end)*100);
fprintf(FID,'& & & & & & & & & & \\textbf{Total} & \\textbf{%d} & \\textbf{%d} & \\textbf{%3.1f} \\tabularnewline[0.1cm]\n', ...
    sum(total_alg1_per_year), sum(nr_patents_per_year), ...
    sum(total_alg1_per_year)/sum(nr_patents_per_year)*100);


fprintf(FID, '\\bottomrule');
fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\begin{tablenotes}\n');
fprintf(FID,'\\small\n');
fprintf(FID,'\\item\\textit{Note:} \\#A: number of automation patents as classified by Algorithm1, \\#P: total number of patents, $^3$: up to 23.03.2015.\n');
fprintf(FID,'\\item\\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID,'\\end{tablenotes}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 
