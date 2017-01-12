clear all
close all


%% Choose years 
year_start = 1976;
year_end = 2015;


for ix_year = year_start:year_end
    t = ix_year - year_start + 1;
    
    load_name = horzcat('cleaned_matches/patsearch_results_', ...
        num2str(ix_year), '.mat');
    load(load_name, 'patsearch_results')

    plength = patsearch_results.length_pattext;
    plength_ap = plength(find(patsearch_results.is_nbAutomat));
       
    maxL(t) = max(plength);
    minL(t) = min(plength);
    meanL(t) = mean(plength);
    medianL(t) = median(plength);
    
    maxL_ap(t) = max(plength_ap);
    minL_ap(t) = min(plength_ap);
    meanL_ap(t) = mean(plength_ap);
    medianL_ap(t) = median(plength_ap);
    
    fprintf('%d: max = %3.1f, min = %3.1f, mean = %3.1f, median = %3.1f.\n', ...
        ix_year, maxL(t), minL(t), meanL(t), medianL(t))
end
 
%%
col1 = [0.1, 0.9, 0.1];
col2 = [0.9, 0.1, 0.1];

figure
subplot(2, 1, 1)
plot(year_start:year_end, meanL, 'b')
hold on
plot(year_start:year_end, meanL_ap, 'r')
title('Mean')
ylabel('Numbers of lines')
legend('All patents', 'Automation patents', 'Location', 'NorthWest')
hold off
y1 = get(gca, 'ylim');
line([2000 2000], y1, 'Color', col1);
line([2001 2001], y1, 'Color', col1);
line([2002 2002], y1, 'Color', col2);
line([2003 2003], y1, 'Color', col2);
line([2004 2004], y1, 'Color', col2);
line([2005 2005], y1, 'Color', col1);
line([2006 2006], y1, 'Color', col1);

subplot(2, 1, 2)
plot(year_start:year_end, medianL, 'b')
hold on
ylabel('Numbers of lines')
plot(year_start:year_end, medianL_ap, 'r')
title('Median')
legend('All patents', 'Automation patents', 'Location', 'NorthWest')
y1 = get(gca, 'ylim');
line([2000 2000], y1, 'Color', col1);
line([2001 2001], y1, 'Color', col1);
line([2002 2002], y1, 'Color', col2);
line([2003 2003], y1, 'Color', col2);
line([2004 2004], y1, 'Color', col2);
line([2005 2005], y1, 'Color', col1);
line([2006 2006], y1, 'Color', col1);



