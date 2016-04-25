function [aggr_automix, aggr_automix_share] = ...
    get_sic_ocat_automix_data(year_start, year_end, sic_automix_allyears, ...
    sic_overcategories)
% Compile some yearly statistics for aggregate industries.

for ix_year=year_start:year_end
    t = ix_year - year_start + 1;    
    
    year_data = sic_automix_allyears( find( sic_automix_allyears.year ...
        == ix_year ), :);
    
    for i=1:length(sic_overcategories.letter)
        pick_sic_overcat = sic_overcategories.letter{i};

        find_ix = find( strcmp( year_data.overcat, ...
            pick_sic_overcat) );
        aggr_automix(t, i) = nansum( year_data.automix_use(find_ix));
        
        aggr_automix_share(t, i) = nanmean( year_data.automix_use(find_ix) ./ ...
            year_data.patents_use(find_ix));
    end
end
