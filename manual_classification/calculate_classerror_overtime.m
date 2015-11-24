function classifstat_yrly = calculate_classerror_overtime(manclassData, ...
    compClass_Yes, year_start, year_end)

for ix_year=year_start:year_end
    ix_iter = ix_year + 1 - year_start;
    
    ix_pos = find(manclassData.indic_year == ix_year);
    nr_class = length(ix_pos);
    
    manclass_Yes_yr = manclassData.manAutomat(ix_pos);
    compClass_Yes_yr = compClass_Yes(ix_pos);
    
    assert( nr_class == length(compClass_Yes_yr) )
    
    nr_equal = length( find( manclass_Yes_yr == compClass_Yes_yr ) );
    nr_wrong = nr_class - nr_equal;
       
    classifstat = calculate_manclass_stats(manclass_Yes_yr, ...
        compClass_Yes_yr);
    
    % Save in struct
    classifstat_yrly.nr_class(ix_iter) = nr_class;
    classifstat_yrly.nr_equal(ix_iter) = nr_equal;
    classifstat_yrly.nr_wrong(ix_iter) = nr_wrong;
    classifstat_yrly.nr_manclass_Yes_yr(ix_iter) = sum( manclass_Yes_yr );
    classifstat_yrly.nr_compClass_Yes_yr(ix_iter) = sum( compClass_Yes_yr );
    classifstat_yrly.accuracy(ix_iter) = classifstat.accuracy;
    classifstat_yrly.fmeasure(ix_iter) = classifstat.fmeasure;
end
