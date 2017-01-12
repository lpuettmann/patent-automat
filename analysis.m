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
figure
subplot(2, 1, 1)
plot(year_start:year_end, meanL, 'b')
hold on
plot(year_start:year_end, meanL_ap, 'r')
title('Mean')
ylabel('Numbers of lines')
legend('All', 'Automation patents', 'Location', 'NorthWest')
hold off

subplot(2, 1, 2)
plot(year_start:year_end, medianL, 'b')
hold on
ylabel('Numbers of lines')
plot(year_start:year_end, medianL_ap, 'r')
title('Median')
legend('All', 'Automation patents', 'Location', 'NorthWest')