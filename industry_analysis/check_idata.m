function check_idata(idata)
% Check plausibility of the extracted labor market data for different
% industries.

if not ( all( isnan( idata.production(1:11, 1) ) ) )
    warning('Production data for industry 311 should be NaN for 1976-1986.')
end

if idata.output(12, 1) ~= 75.876
    warning('Not expected value.')
end

if idata.employment(12, 4) ~= 594.1
    warning('Not expected value.')
end

if idata.labor_cost(12, 12) ~= 23922.618
    warning('Not expected value.')
end

if idata.output_deflator(37, 24) ~= 124.312
    warning('Not expected value.')
end

if idata.output(13, 5) ~= 92.803 + 97.312
    warning('Not expected value.')
end
