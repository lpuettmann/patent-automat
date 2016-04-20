function indic_exclclassnr = check_classnr_uspc(classnr_uspc)
% Check the technology numbers of the manually coded patents to see if they
% should be excluded.

% Check for correct inputs
assert( not( isstr( classnr_uspc ) ) ) % not a string
assert( not( iscell( classnr_uspc ) ) ) % not a cell array

% Get tech numbers to exclude
exclude_techclass = choose_exclude_techclass();

assert( not( isstr( exclude_techclass ) ) ) % not a string
assert( not( iscell( exclude_techclass ) ) ) % not a cell array

% Check if tech numbers of manually classified patents is one of those
% chosen to be excluded
indic_exclclassnr = nan( size(classnr_uspc) );

for i=1:size(classnr_uspc,1)   
    pick_classnr = classnr_uspc(i);    
    indic_exclclassnr(i) = any( exclude_techclass == pick_classnr );
end
