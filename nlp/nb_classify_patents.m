function nb_classify_patents(year_start, year_end, patextr, ...
    find_dictionary)
% Classify all patents using the Bernoulli Naive Bayes algorithm.
%
%   IN:
%       - year_start
%       - year_end
%       - patexr: struct holding information about the manually classified
%       patents.
%       - find_dictionary: the keyword search dictionary that we searched
%       for on all patents.

%% Calculate posterior probabilities for all patents
cond_prob_yes = [patextr.title_cond_prob_yes; ...
    patextr.abstract_cond_prob_yes; patextr.body_cond_prob_yes];
cond_prob_no = [patextr.title_cond_prob_no; ...
    patextr.abstract_cond_prob_no; patextr.body_cond_prob_no];
prior_yes = patextr.prior_automat;
prior_no = patextr.prior_notautomat;
clear patextr

for ix_year=year_start:year_end;
    load(['patsearch_results_', num2str(ix_year), '.mat']);

    P = length(patsearch_results.patentnr);

    nb_post.post_yes = NaN(P, 1);
    nb_post.post_no = NaN(P, 1);
    share_probs_higherYes = NaN(P, 1);

    for p=1:P
        patMatches = [patsearch_results.title_matches(p, :), ...
            patsearch_results.abstract_matches(p, :), ...
            patsearch_results.body_matches(p, :)];
        patOccur = +(patMatches > 0)'; % logical to double
        indic_appear = logical( full( patOccur ) );

        % Calculate updated posterior probabilty of the patent belonging to
        % either class
        nb_post.post_yes(p) = calc_post_nb(prior_yes, cond_prob_yes, indic_appear);
        nb_post.post_no(p) = calc_post_nb(prior_no, cond_prob_no, indic_appear);

        if mod(p, 1000) == 0
            temp = +(nb_post.post_yes(p - 999 : p) > nb_post.post_no(p - 999 : p));
            share_temp = sum(temp) / length(temp);
            fprintf('Patent %d/%d finished: %3.2f percent automation patents.\n', ...
                p, P, share_temp)
        end
    end
    
    save_name = horzcat('nb_posteriors/nb_post_', num2str(ix_year), ...
        '.mat');
    save(save_name, 'nb_post');    
    disp('_____________________________________________________')
    fprintf('Finished calculating posterior prob''s for year: %d.\n', ix_year)
    disp(' ')

    clear nb_post
end


%% Check Naive Bayes for plausibility
check_plausible_nb_post(year_start, year_end)


%% Classify patents based on the posterior probabilities
for ix_year=year_start:year_end;
    ix_iter = ix_year - year_start + 1;
    
    load_name = horzcat('nb_post_', num2str(ix_year), '.mat');
    load(load_name)

    is_nbAutomat = +( nb_post.post_yes > nb_post.post_no );
       
    fname = ['patsearch_results_', num2str(ix_year), '.mat'];
    load(fname);
    patsearch_results.is_nbAutomat = is_nbAutomat;
    save(['cleaned_matches/', fname], patsearch_results);
    fprintf('Classified patents year: %d.\n', ix_year)
end
