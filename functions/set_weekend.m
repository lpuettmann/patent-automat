function week_end = set_weekend(year)

% 53 weeks: 1980, 1985, 1991, 1996
if year == 1980 | year == 1985 | year == 1991 | year == 1996
    week_end = 53;
else
    week_end = 52; 
end
