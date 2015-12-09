function sic_overcategories = define_sic_overcategories()

% Save data in cell array (see below for variable names)
sic_overcategories = { ...
    1, 'A', 'Agriculture, Forestry, And Fishing', 'Agriculture';
    10, 'B', 'Mining', 'Mining';
    15, 'C', 'Construction', 'Construction'
    20, 'D', 'Manufacturing', 'Manufacturing';
    40, 'E', 'Transportation, Communications, Electric, Gas, And Sanitary Services', 'Utilities';
    50, 'F', 'Wholesale Trade', 'Wholesale trade';
    52, 'G', 'Retail Trade', 'Retail trade';
    60, 'H', 'Finance, Insurance, And Real Estate', 'Financial services';
    70, 'I', 'Services', 'Services';
    91, 'J', 'Public Administration', 'Public administration'};    

% Transform cell array to table
sic_overcategories = cell2table(sic_overcategories);

% Assign variable names
sic_overcategories.Properties.VariableNames = {'starting_digit', ...
    'letter', 'fullname', 'plot_fullnames'};
