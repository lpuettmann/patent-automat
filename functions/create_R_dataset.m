function [pdata, fDictColNames, dictInc] = create_R_dataset(patextr, ...
    find_dictionary)

% Bring the struct into a form which allows transferring it to a dataframe
pdata = patextr;

% Get only first IPC entry
ipc_first = cellfun(@(c) c(1), patextr.ipc_nr);
pdata.ipc_ocat = cellfun(@(x) x(1), ipc_first, 'un', 0);

pdata.abstract_strConc = [];
pdata.body_strConc = [];

for i = 1:length(patextr.patentnr)
    abstract_str = patextr.abstract_str(i);
    body_str = patextr.body_str(i);
    pdata.abstract_strConc{i, 1} = strjoin(abstract_str{1}');
    pdata.body_strConc = strjoin(body_str{1}');plot_nb_overtime
end

delFields = {'abstract_str', 'body_str', 'title_tokens', ...
    'abstract_tokens', 'body_tokens', 'ipc_nr', ...
    'unique_titleT', 'unique_abstractT', ...
    'unique_bodyT', 'incidMat_title', 'incidMat_abstract', ...
    'incidMat_body', 'title_occurstats', 'abstract_occurstats', ...
    'body_occurstats', 'tokRanking_title', 'tokRanking_abstract', ...
    'tokRanking_body', 'title_cond_prob_yes', 'title_cond_prob_no', ...
    'abstract_cond_prob_yes', 'abstract_cond_prob_no', ...
    'body_cond_prob_yes', 'body_cond_prob_no', 'prior_automat', ...
    'prior_notautomat'};

for i = 1:length(delFields)
    pdata = rmfield(pdata, delFields{i});
end


% Get index position of the dictionary words
dictLen = length(find_dictionary);
iTitle = [];
iAbstract = [];
iBody = [];

for i = 1:dictLen
    tok = find_dictionary{i};
    
    posTitle = find(strcmp(tok, patextr.unique_titleT));
    posAbstract = find(strcmp(tok, patextr.unique_abstractT));
    posBody = find(strcmp(tok, patextr.unique_bodyT));
    
    if ~isempty(posTitle)
        iTitle = [iTitle; posTitle];
    end
    
    if ~isempty(posAbstract)
        iAbstract = [iAbstract; posAbstract];
    end
    
    if ~isempty(posBody)
        iBody = [iBody; posBody];
    end
end

%% append "t", "a" and "b" to column names
fDictColNames = [strcat('t_', patextr.unique_titleT(iTitle)); ...
    strcat('a_', patextr.unique_abstractT(iAbstract));
    strcat('b_', patextr.unique_bodyT(iBody))];
assert(length(fDictColNames) == length(iTitle) + length(iAbstract) + ...
    length(iBody))


% Extract the right columns from the incidence matrices
titleDictInc = full(patextr.incidMat_title(:, iTitle));
abstractDictInc = full(patextr.incidMat_abstract(:, iAbstract));
bodyDictInc = full(patextr.incidMat_body(:, iBody));


% Every column should have at least one non-zero value.
assert(all(sum(titleDictInc) > 0))
assert(all(sum(abstractDictInc) > 0))
assert(all(sum(bodyDictInc) > 0))

% Put all in matrix next to each other
dictInc = [titleDictInc, abstractDictInc, bodyDictInc];
