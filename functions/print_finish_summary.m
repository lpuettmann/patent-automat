function print_finish_summary(toc, ix_year)

disp('_______________________________________________________________')
fprintf('Year %d finished, time: %d seconds (%d minutes).\n', ...
    ix_year, round(toc), round(toc/60))
disp('_______________________________________________________________')
