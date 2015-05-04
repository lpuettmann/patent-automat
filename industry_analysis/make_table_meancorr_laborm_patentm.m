close all
clear all
clc


%% Load data
load('manufacturing_ind_data.mat');

%% Make table of correlations

% Take mean of correlations
meancorr = nanmean(corr_laborm_patentm, 3);

meancorr = meancorr(:, [5, 10, 4, 2, 8, 6, 9, 1, 3, 7]);


stdcorr = nan(size(meancorr));

for ix_row=1:size(stdcorr,1)
    for ix_column=1:size(stdcorr,2)
        extractvec = squeeze(corr_laborm_patentm(ix_row, ix_column, :));
        stdcorr(ix_row, ix_column) = nanstd(extractvec);
    end
end


tablestr = repmat({''}, size(meancorr));

for ix_val=1:length(meancorr(:))
    if abs(meancorr(ix_val))/stdcorr(ix_val) > 1
        tablestr{ix_val} = ['\textbf{', num2str(round(100*meancorr(ix_val))/100), '}'];
%     if meancorr(ix_val) > 0
%         tablestr{ix_val} = ['\cellcolor{mylightred}', num2str(round(100*meancorr(ix_val))/100)];
%     elseif meancorr(ix_val) < 0
%         tablestr{ix_val} = ['\cellcolor{mylightgreen}', num2str(round(100*meancorr(ix_val))/100)];
    else
        tablestr{ix_val} = num2str(round(100*meancorr(ix_val))/100);
    end
end

% Print to .txt file in Latex format
printname = 'table_meancorr_laborm_patentm.tex';

FID = fopen(printname, 'w');

fprintf(FID,'\\begin{table}\n');
fprintf(FID,'\\begin{small}\n');
fprintf(FID,'\\begin{threeparttable}\n');
fprintf(FID,'\\caption{{\\normalsize Average correlations of labor market outcomes and automation across industries}}\n');
fprintf(FID,'\\label{tab:meancorr_laborm_patentm}\n');
fprintf(FID,'\\begin{tabular}{lrrrrrrrrrr}\n');
fprintf(FID,'\\toprule \\addlinespace[0.5em]\n');
% fprintf(FID,' & Production & Output & Capital & Capital Productivity & Employment & Labor cost & Labor productivity & Capital cost & Output deflator  \\tabularnewline[0.05cm]\n');

fprintf(FID,' & \\rot{Employment} & \\rot{Employment share} &  \\rot{Capital productivity} & \\rot{Output} & \\rot{Capital cost} &  \\rot{Labor cost} & \\rot{Output deflator} & \\rot{Production} & \\rot{Capital} & \\rot{Labor productivity} \\tabularnewline[0.05cm]\n');
fprintf(FID,'\\midrule \\addlinespace[0.5em]\n');


fprintf(FID,'\\# Automation patents$^1$ ');
for ix_element=1:size(tablestr,2)
    fprintf(FID,'& %s ', tablestr{1,ix_element});
end
fprintf(FID,' \\tabularnewline[0.0cm]\n');
fprintf(FID,' & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} \\tabularnewline[0.1cm]\n', stdcorr(1,:));


fprintf(FID,'Average match per patent ');
for ix_element=1:size(tablestr,2)
    fprintf(FID,'& %s ', tablestr{2,ix_element});
end
fprintf(FID,' \\tabularnewline[0.0cm]\n');
fprintf(FID,' & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} \\tabularnewline[0.1cm]\n', stdcorr(2,:));


fprintf(FID,'Share of automation patents ');
for ix_element=1:size(tablestr,2)
    fprintf(FID,'& %s ', tablestr{3,ix_element});
end
fprintf(FID,' \\tabularnewline[0.0cm]\n');
fprintf(FID,' & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} \\tabularnewline[0.1cm]\n', stdcorr(3,:));


fprintf(FID,'Automation index$^2$ ');
for ix_element=1:size(tablestr,2)
    fprintf(FID,'& %s ', tablestr{4,ix_element});
end
fprintf(FID,' \\tabularnewline[0.0cm]\n');
fprintf(FID,' & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{\\scriptsize{(%3.2f)}} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} & \\scriptsize{(%3.2f)} \\tabularnewline[0.1cm]\n', stdcorr(4,:));


% fprintf(FID,'\\# Automation patents & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f \\tabularnewline[0.1cm]\n', meancorr(1,:));
% fprintf(FID,'Average match per patent & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f \\tabularnewline[0.1cm]\n',  meancorr(2,:));
% fprintf(FID,'Share of automation patents & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f \\tabularnewline[0.1cm]\n',  meancorr(3,:));
% fprintf(FID,'Automation index & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f & %3.2f \\tabularnewline[0.1cm]\n',  meancorr(4,:));


fprintf(FID,'\\bottomrule\n');
fprintf(FID,'\\end{tabular}\n');
fprintf(FID,'\\begin{tablenotes}\n');
fprintf(FID,'\\small\n');
fprintf(FID,'\\item \\textit{Note:} Correlations are calculated from the yearly time series 1987-2014 of the automation indicator and the labor market outcome series. The values are cross-sectional averages across the 26 manufacturing industries. Values in parentheses show standard deviations. Bold values are at least one standard deviation away from 0.\n');
fprintf(FID,'\\item $^1$: Automation patents are defined as patents with at least one keyword match.\n');
fprintf(FID,'\\item $^2$: Calculated as $log(1 + \\text{number of matches per patent})$.\n');
fprintf(FID,'\\item \\textit{Source:} USPTO, Google and own calculations.\n');
fprintf(FID,'\\end{tablenotes}\n');
fprintf(FID,'\\end{threeparttable}\n');
fprintf(FID,'\\end{small}\n');
fprintf(FID,'\\end{table}\n');
fclose(FID); 


%%
fprintf('Saved: %s.\n', printname)
