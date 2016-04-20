function make_table_yearsstats(nrAutomat, nrAllPats, shareAutomat, ...
    year_start, year_end)

%% 


%% Print to .txt file in Latex format
printname = 'output/table_yearsstats.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}[!htb]\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Overview of yearly classified patents}}\n');
fprintf(FID,'\\label{table:table_yearsstats}\n');
fprintf(FID,'\\begin{tabular}{lrrrrlrrrrlrrr}\n'); 
fprintf(FID,'\\toprule \\addlinespace[0.5em]\n');
fprintf(FID,' & \\textbf{\\#A} & \\textbf{\\#P} & \\textbf{\\%%} & \\phantom{aaa} & & \\textbf{\\#A} & \\textbf{\\#P} & \\textbf{\\%%} & \\phantom{aaa} & & \\textbf{\\#A} & \\textbf{\\#P} & \\textbf{\\%%}\\tabularnewline[0.1cm]\n');
fprintf(FID,'\\midrule \\addlinespace[0.5em]\n');

addyear = 13;
addyear2 = addyear*2;

for t=1:13
    ix_year = year_start + t - 1;
   
    fprintf(FID,'%d & %d & %d & %3.1f & & %d & %d & %d & %3.1f & & %d & %d & %d & %3.1f \\tabularnewline[0.1cm]\n', ...
        ix_year, nrAutomat(t), nrAllPats(t), ...
        shareAutomat(t)*100, ...
        ix_year + addyear, nrAutomat(t + addyear), ...
        nrAllPats(t + addyear), shareAutomat(t + addyear)*100, ix_year + ...
        addyear2, nrAutomat(t + addyear2), ...
        nrAllPats(t + addyear2), ...
        shareAutomat(t + ...
        addyear2)*100);
end
 
fprintf(FID,'& & & & & & & & & & 2015$^*$ & %d & %d & %3.1f  \\tabularnewline[0.1cm]\n', ...
    nrAutomat(end), nrAllPats(end), ...
    shareAutomat(end)*100);
fprintf(FID,'& & & & & & & & & & \\textbf{Total} & \\textbf{%d} & \\textbf{%d} & \\textbf{%3.1f} \\tabularnewline[0.1cm]\n', ...
    sum(nrAutomat), sum(nrAllPats), ...
    sum(nrAutomat)/sum(nrAllPats)*100);

fprintf(FID, '\\bottomrule');
fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\begin{tablenotes}\n');
fprintf(FID,'\\small\n');
fprintf(FID,'\\item\\textit{Note:} \\#A: number of automation patents as classified by Algorithm~\\ref{alg:baseline_alg1}, \\#P: total number of patents, $^*$: up to 23.03.2015.\n');
fprintf(FID,'\\item\\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID,'\\end{tablenotes}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 

fprintf('Saved: %s.\n', printname)
