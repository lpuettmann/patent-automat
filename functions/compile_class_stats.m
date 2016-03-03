function nb_stats = compile_class_stats(year_start, year_end)

week_start = 1;

% Initialize
weekstats.year = [];
weekstats.week = [];
weekstats.nrAutomat = [];
weekstats.nrPat = [];
weekstats.shareAutomat = [];

for ix_year=year_start:year_end  
    ix_iter = ix_year - year_start + 1;
    
    load(['patsearch_results_', num2str(ix_year)]);
    
    % Exclude some patents
    countAutomat = patsearch_results.is_nbAutomat( not( ...
        patsearch_results.indic_exclclassnr ) );
        
    assert( length(countAutomat) + sum( ...
        patsearch_results.indic_exclclassnr ) == length( ...
        patsearch_results.patentnr ) )
   
    indicWeek = patsearch_results.week( not( ...
        patsearch_results.indic_exclclassnr ) );
    
    assert( length(indicWeek) == length( countAutomat ) )
    
    % Annual summary
    yearstats.year(ix_iter, 1) = ix_year;
    yearstats.nrAutomat(ix_iter, 1) = sum( countAutomat );
    yearstats.nrPat(ix_iter, 1) = length( countAutomat );
    yearstats.nrAllPats(ix_iter, 1) = length( patsearch_results.patentnr );
    yearstats.shareAutomat(ix_iter, 1) = sum( countAutomat ) / ...
        length( countAutomat );
        
    % Weekly summary
    week_end = set_weekend(ix_year); 
    
    nrAutomat = zeros(week_end, 1);  
    nrPat = zeros(week_end, 1);
    shareAutomat = zeros(week_end, 1);
    week = zeros(week_end, 1);
    
    for ix_week=week_start:week_end
        w = ( cell2mat( indicWeek ) == ix_week);
        nrPat(ix_week) = sum( w );
        nrAutomat(ix_week) = sum( countAutomat( w ) );
        shareAutomat(ix_week) = nrAutomat(ix_week) / nrPat(ix_week);
        
        assert( shareAutomat(ix_week) <= 1 )
        assert( shareAutomat(ix_week) >= 0 )
        
        week(ix_week) = ix_week;
    end
    
    weekstats.year = [weekstats.year; repmat(ix_year, week_end, 1)];
    weekstats.week = [weekstats.week; week];
    weekstats.nrAutomat = [weekstats.nrAutomat; nrAutomat];
    weekstats.nrPat = [weekstats.nrPat; nrPat];
    weekstats.shareAutomat = [weekstats.shareAutomat; shareAutomat];
    
    fprintf('Compile Naive Bayes classificiation stats for year: %d.\n', ...
        ix_year)
end

nb_stats.weekstats = struct2table( weekstats );
nb_stats.yearstats = struct2table( yearstats );
