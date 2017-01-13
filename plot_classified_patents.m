clear all
close all

addpath('make_figures\')

year_start = 1976;
year_end = 2015;

%% Summmarize classified patents with plots and tables
load('output/nb_stats')

ix_new_year = diff(nb_stats.weekstats.year);
ix_new_year(1) = 1; % first year
ix_new_year = find(ix_new_year);

plot_nb_overtime(year_start, year_end, nb_stats.weekstats.nrAutomat, ...
    ix_new_year)

plot_nb_share(year_start, year_end, nb_stats.weekstats.shareAutomat, ...
    ix_new_year)

plot_nb_autompat_yearly(year_start, year_end, ...
    nb_stats.yearstats.shareAutomat)

% Make plot that compares number of yearly patents 1976-2014
plot_error_nr_patents(nb_stats.yearstats.nrAllPats, year_start)

% Make table of yearly summary statistics
make_table_yearsstats(nb_stats.yearstats.nrAutomat, ...
    nb_stats.yearstats.nrAllPats, nb_stats.yearstats.shareAutomat, ...
    year_start, year_end)
