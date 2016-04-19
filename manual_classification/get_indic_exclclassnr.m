function indic_exclclassnr = get_indic_exclclassnr(uspc_nr)
% For the sample of manually classified patents, check their USPC
% technology classification numbers against those USPC numbers we wish to
% exlcude.
%
% IN:
%       - uspc_nr: cell array with strings of full USPC numbers
%
% OUT:
%       - indic_exclclassnr: vector of 1 and 0 indicating if patents should
%       be exluded from further analysis. 1: exclude, 0: don't exclude
%

% Check for correct inputs
assert( not( isstr( uspc_nr ) ) ) % not a string
assert( iscell( uspc_nr ) )

% Get string until first space
classnr_tok = strtok( uspc_nr );

% Extract first 3 digits
classnr_3dig = repmat({''}, length(classnr_tok), 1);
for i=1:length(classnr_tok)
    extrstr = classnr_tok{i};
    
    if numel(extrstr) >=3
        classnr_3dig{i, 1} = str2num( extrstr(1:3) );
    else
        classnr_3dig{i, 1} = str2num( extrstr );
    end
end

classnr_3dig = cell2mat( classnr_3dig );

if length( classnr_3dig ) < length( uspc_nr )
    warning('Maybe some tech. numbers are missing.')
end

% Get tech numbers to exclude
exclude_techclass = choose_exclude_techclass();

assert( not( isstr( exclude_techclass ) ) ) % not a string
assert( not( iscell( exclude_techclass ) ) ) % not a cell array

% Check if tech numbers of manually classified patents is one of those
% chosen to be excluded
indic_exclclassnr = nan( size(classnr_3dig) );

for i=1:size(classnr_3dig,1)   
    pick_classnr = classnr_3dig(i);    
    indic_exclclassnr(i) = any( exclude_techclass == pick_classnr );
end
