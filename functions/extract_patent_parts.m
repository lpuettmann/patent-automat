function patparts = extract_patent_parts(patent_text_corpus, ftset)
% Extract title string, abstract string and patent text body string from
% the patent text.

% Get title
switch ftset.indic_filetype
    case 1
        patxt_trunc = truncate_corpus(patent_text_corpus, ...
            ftset.nr_trunc);
        [~, nr_find, ix_find] = count_occurences(patxt_trunc, ...
            ftset.indic_titlefind);

    case 2
        ix_find = get_ix_cellarray_str(patent_text_corpus, ...
            ftset.indic_titlefind);
        nr_find = length(ix_find);

    case 3
        ix_find = get_ix_cellarray_str(patent_text_corpus, ...
            ftset.indic_titlefind);
        nr_find = length(ix_find);
end

if nr_find > 1
    % If shows up more than once, keep only first occurence as the
    % title occurs near the top of the patent.
    ix_find = ix_find(1);
elseif nr_find == 0
    warning('No string found.')
end

title_line = patent_text_corpus{ix_find, :};

switch ftset.indic_filetype
    case 1
        title_str = title_line(6:end);

    case 2
        line_nr_end = regexp(title_line, '</PDAT>'); 
        title_str = title_line(20:line_nr_end - 1);

    case 3
        line_nr_start = regexp(title_line, '>'); 
        line_nr_start = line_nr_start(1);
        line_nr_end = regexp(title_line, '</invention-title>'); 
        title_str = title_line(line_nr_start + 1 : line_nr_end ... 
            - 1);

        if not( isempty( regexp(title_str(1), '>') ) )
            warning('Title string starts with ''>'' in patent %s (%d, week %d)', ...
                patent_number{ix_patent}, ix_year, ix_week)
            title_str
        end
end


% Get abstract
switch ftset.indic_filetype
    case 1
        [~, nr_find, ix_abstractstart] = count_occurences( ...
            patxt_trunc, ftset.indic_abstractfind);

    case {2, 3}
        ix_abstractstart = get_ix_cellarray_str( ...
            patent_text_corpus, ftset.indic_abstractfind);
end

if nr_find > 1
    % If shows up more than once, keep only first occurence as the
    % abstract occurs near the top of the patent.
    ix_abstractstart = ix_abstractstart(1);
end

if nr_find == 0
    abstract_str = ' ';
else
    switch ftset.indic_filetype
        case 1
            dict_abstract_end = ftset.indic_abstractend;

            for d=1:length(dict_abstract_end)
                find_str = dict_abstract_end{d};
                [~, nr_absEnd(d), ix_absEnd{d}] = ...
                    count_occurences(patxt_trunc, find_str);
            end

            if max(nr_absEnd) == 0       
                % If we cannot determine where the abstract ends, then just
                % take the first 10 lines or until end of patent.

                shortEndAbs = min(size(patent_text_corpus( ... 
                    ix_abstractstart + 1:end, :), 1), 11);
                ix_abstractend = ix_abstractstart + shortEndAbs;

            else

                min_absEnd = [];
                for i=1:length(dict_abstract_end)
                    pick_absEnd = ix_absEnd{i};
                    min_absEnd = [min_absEnd;
                                    pick_absEnd(pick_absEnd > ...
                                    ix_abstractstart)];
                end

                if isempty( min_absEnd )
                    warning('Should not be empty.')
                end

                ix_abstractend = min(min_absEnd);
            end

            if isnan( ix_abstractend )
                warning('ix_abstractend is Nan.')
            elseif isempty( ix_abstractend )
                warning('ix_abstractend is empty.')
            end

        case {2, 3}
            ix_abstractend = get_ix_cellarray_str( ...
                patent_text_corpus, ftset.indic_abstractend);
    end

    abstract_str = patent_text_corpus(ix_abstractstart + 1 : ...
        ix_abstractend - 1, :);
end

switch ftset.indic_filetype
    case 1
        [~, ~, ix_bodystart] = count_occurences(patxt_trunc, ...
            ftset.indic_bodyfind);

    case {2, 3}
        [~, ~, ix_bodystart] = count_occurences(patent_text_corpus, ...
            ftset.indic_bodyfind);
end

if isempty( ix_bodystart )
    body_str = ' ';
else
    body_str = patent_text_corpus(ix_bodystart + 1 : end);
end

% Store text parts in struct
patparts.title_str = title_str;
patparts.abstract_str = abstract_str;
patparts.body_str = body_str;





