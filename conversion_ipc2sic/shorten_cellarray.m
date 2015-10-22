function ipc_short = shorten_cellarray(ipc_list)

ipc_short = strtok(ipc_list);

for i=1:length(ipc_short)
    
    temp = ipc_short{i};
    
    count_letter(i,1) = numel(temp);
end    