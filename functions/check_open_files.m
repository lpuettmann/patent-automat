function check_open_files

% Check if there are no open files left
show_open_fileIDs = fopen('all');
for ix_openfiles=1:length(show_open_fileIDs)
    display_filename = fopen(ix_openfiles);
    
    % Don't show "stdout" and "stderr"
    if ~(strcmp(display_filename, '"stderr"')) && ...
            ~(strcmp(display_filename, '"stdout"'))
        fprintf('This file is still open: %s.\n', display_filename)
    end
end