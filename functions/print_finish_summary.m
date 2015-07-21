function print_finish_summary(toc, ix_year)

year_loop_time = toc;
disp('---------------------------------------------------------------')
fprintf('Year %d finished, time: %d seconds (%d minutes).\n', ...
    ix_year, round(year_loop_time), round(year_loop_time/60))
disp('---------------------------------------------------------------')