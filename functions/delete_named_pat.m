function save_row_delete = delete_named_pat(patentnr)
% Go through patent numbers and check if they start with
% some particular letter that indicates if they are a "named patent".
%
%   IN:
%       - patentnr: cell array of strings with patent numbers
%
%   OUT:
%       - save_row_delete: index positions of patents that are named
%       patents.

ix_save = 1; % initalize saving index

save_row_delete = [];

for ix_patent = 1:size(patentnr, 1)
    extract_row = patentnr{ix_patent};

    if strcmp(extract_row(1), 'D') ... % design patents
            || strcmp(extract_row(1), 'P') ... % PP: plant patents
            || strcmp(extract_row(1), 'R') ... % reissue patents
            || strcmp(extract_row(1), 'T') ... % defensive publications
            || strcmp(extract_row(1), 'H') ... % SIR (statutory invention registration)
            || strcmp(extract_row(1), 'X') % early X-patents
        
        save_row_delete(ix_save) = ix_patent;
        ix_save = ix_save + 1;
    end   
end

save_row_delete = save_row_delete';
