function week_end = set_weekend(year)

% 53 weeks: 1980, 1985, 1991, 1996 and then also 2002, 2008, 2013
if year == 1980 | year == 1985 | year == 1991 | year == 1996 ...
        | year == 2002 | year == 2008 | year == 2013
    week_end = 53;
elseif year == 2015
    week_end = 11;
else
    week_end = 52; 
end
