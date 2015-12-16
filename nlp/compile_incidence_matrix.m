function incidMat = compile_incidence_matrix(tokenList, docTokens)

for k=1:length(tokenList)
    compareStr = tokenList{k};

    for i=1:length(docTokens)

        for j=1:length(docTokens{i})
            occurences(j, 1) = +strcmp(compareStr, docTokens{i}{j});
        end

        incidMat(i, k) = sum( occurences );
    end
    
    if mod(k, 100) == 0
        fprintf('Finished token %d/%d.\n', k, length(tokenList))
    end
end
