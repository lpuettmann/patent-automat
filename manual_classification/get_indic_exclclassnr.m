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

classnr_3dig = cell2mat(classnr_3dig);

% Check the exctracted USPC classification numbers against the list of USPC
% numbers that we want to exclude.
indic_exclclassnr = check_classnr_uspc(classnr_3dig);
