function parsave(fname, wkly_matches)
% Need this function to be able to save in Matlab's parallel mode (parfor
% loop).
% 
% ATTENTION: This is a crude work around. This function can only save
% variables with exactly the name specified here. It does not carry
% variable names from the main script if they differ. Use with caution.
% 

save(fname, 'wkly_matches')
