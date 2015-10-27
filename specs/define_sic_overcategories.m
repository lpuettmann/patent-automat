function sic_overcategories = define_sic_overcategories()

sic_overcategories = { ...
    1, 'A', 'Agriculture, Forestry, And Fishing';
    10, 'B', 'Mining';
    15, 'C', 'Construction';
    20, 'D', 'Manufacturing';
    40, 'E', 'Transportation, Communications, Electric, Gas, And Sanitary Services';
    50, 'F', 'Wholesale Trade';
    52, 'G', 'Retail Trade';
    60, 'H', 'Finance, Insurance, And Real Estate';
    70, 'I', 'Services';
    91, 'J', 'Public Administration'};       

sic_overcategories = cell2table(sic_overcategories);
sic_overcategories.Properties.VariableNames = {'starting_digit', ...
    'letter', 'fullname'};
