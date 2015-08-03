function check_if1occurence(nr_find)

if nr_find > 1
    warning('More than 1 string.')
elseif nr_find == 0
    warning('No string found.')
end