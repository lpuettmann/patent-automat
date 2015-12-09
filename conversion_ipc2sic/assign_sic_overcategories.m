function overcat = assign_sic_overcategories(sic_list)
    % Assign more aggregated SIC "over"-classes to the SIC industries

    sic_first2digits = extract_first2digits( sic_list );

    sic_overcategories = define_sic_overcategories();

    overcat = repmat({''}, size(sic_first2digits) );

    for i=1:length(sic_first2digits)
        first2digit = sic_first2digits(i);

        if isnan( first2digit )
            overcat{i} = 'not applicable';
        else 
            j = max( find( first2digit >= sic_overcategories.starting_digit ) );
            overcat(i) = sic_overcategories.letter(j);
        end
    end
end


%%
function first_digits = extract_first2digits(vec_in)
    % Extract the first two digits of the vector of SIC numbers of with 3 and 4
    % digits. If there are 3 digits, only extract the first digit. If there are
    % 4 digits, extract the first two digits. If there are more or less digits,
    % return NaN (not a number). 


    assert( isnumeric( vec_in ) ) % check that input is numerical vector
    assert( min( size( vec_in ) ) == 1 ) % check that 1-dimensional vector


    first_digits = zeros( size( vec_in ) );

    for k=1:length(vec_in)
       extr_num = vec_in(k); 

       convstr = num2str( extr_num ); % convert to string

       if numel( convstr ) == 3
           first_digits(k) = str2num( convstr(1) );
       elseif numel( convstr ) == 4
           first_digits(k) = str2num( convstr(1:2) );
       else
           first_digits(k) = NaN;
       end
    end


    assert( isnumeric( first_digits ) )
    assert( size(vec_in, 1) == size(first_digits, 1) )
    assert( size(vec_in, 2) == size(first_digits, 2) )
end
