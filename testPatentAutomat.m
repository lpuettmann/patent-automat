function testPatentAutomat()
% Test functions if they work as expected. Both the normal function, say
% "examplefun.m", and the test function, say "test_examplefun.m" and 
% possible dependencies must be on Matlab's search path. This makes use of
% Matlab's xunit testing framework.

run(test_count_occurences);
run(test_count_elements_cell);
run(test_delete_empty_cells);
run(test_get_fullword_matches);
run(test_auc);
run(test_calculate_manclass_stats);
run(test_set_weekend);
run(test_get_ix_cellarray_str);
run(test_extract_patent_number);
run(test_flatten_cellarray);
run(test_shorten_cellarray);
run(test_make_frac_count);
run(test_match_sic2ipc);
% run(test_porterStemmer); % there's a known and unresolved bug here
run(test_porterStemmer2);
run(test_define_stopwords);
run(test_tokenize_string);
run(test_strtrim_punctuation);
run(test_extract_nested_cellarray);
run(test_compile_incidence_matrix);
run(test_get_occurstats);
run(test_get_indic_exclclassnr);
run(test_rank_tokens);
run(test_classif_alg);
run(test_calc_post_nb);
