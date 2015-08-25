function check_idata(idata)
% Check plausibility of the extracted labor market data for different
% industries.

if not ( all( isnan( idata.production(1:11, 1) ) ) )
    warning('Production data for industry 311 should be NaN for 1976-1986.')
end

if idata.output(12, 1) ~= 75.876
    warning('Not expected value.')
end

if idata.output_deflator(37, 26) ~= 118.717
    warning('Not expected value.')
end

if idata.employment(12, 8) ~= 146.7
    warning('Not expected value.')
end



