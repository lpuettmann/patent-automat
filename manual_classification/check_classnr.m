function indic_exclclassnr = check_classnr(classnr)
% Check the technology numbers of the manually coded patents to see if they
% should be excluded.

% Get tech numbers to exclude
exclude_techclass = choose_exclude_techclass();

% Check if tech numbers of manually classified patents is one of those
% chosen to be excluded
indic_exclclassnr = nan( size(classnr) );

for i=1:size(classnr,1)   
    pick_classnr = classnr(i);    
    indic_exclclassnr(i) = any( exclude_techclass == pick_classnr );
end
