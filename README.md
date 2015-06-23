Analyze Patent Grant Texts
===========================================================
**Katja Mann, Lukas Püttmann (2015)**


Get data:
---------------------------
Go to [Google Patents](http://www.google.com/googlebooks/uspto-patents-grants-text.html) and download the Patent Grant Full Texts for all years 1976-2015. For 2001, the data is provided as two filetypes. We choose the one used in the previous years (plain `.txt`). The unzipped files are 98 GB for 1976-2001 and 238 GB for 2002-2015. Put the unzipped data files into subfolders *[year]*. Adjust the paths to this data in the files for steps 1. and 2. below.


Before running:
---------------------------
1. Run `set_up.m` to add the current directory and all underlying directories to Matlab's search path.
2. Run `testPatentAutomat.m` to use Matlab's xUnit testing framework.


To run:
---------------------------
1. Search through weekly patent grant text files and save where each new patent starts. Also save the first 3 digits of the technology classification number (sometimes called OCU). As the file formatting changes, we currently run the analysis separately for periods with different formatting. This saves `.mat` files `patent_index_[year].mat` to folder *patent_index*.
	1. Run `find_patents_part1.m`. Years: 1976-2001
	2. Run `find_patents_part2.m`. Years: 2002-2004
	3. Run `find_patents_part3.m`. Years: 2005-2015
2. Search for keyword through (the same) weekly patent grant text files. It draws on the  previously constructed patent indices. Also save a list of the words surrounding the matches. This saves `.mat` files `patent_keyword_appear_[year].mat` to folder *matches*.
	1. Run `analyze_patent_text_part1.m`. Years: 1976-2001
	2. Run `analyze_patent_text_part2.m`. Years: 2002-2004
	3. Run `analyze_patent_text_part3.m`. Years: 2005-2015
3. Run `clean_matches.m`. This deletes those patents whose numbers start with a letter. It also deletes the previously saved list of words that were found for every patent. It then extracts the patent number from by deleting the first or last letter, depending on year formatting. This saves `.mat` files `patsearch_results_[year].mat` to folder *cleaned_matches*.
4. In folder *make_figures*, run scripts to visualize findings.
	1. Run `summarize_matches.m` first.
	2. Make the visualizations you like. The most important ones are probably the following:
		* `plot_matches_overtime.m` 
		* `plot_matches_over_nrpatents_weekly.m` 
		* `plot_summary_statistics_overtime.m` 
5. Run `transfer_cleaned_matches2csv.m`. This takes `patsearch_results_[year].mat`, cleans the numbers some more and then saves the results from the patent search for all years in an .csv to be exported to Stata.
6. Run `analyze_word_distribution.m` which counts the occurences of frequent words in the found matches. This saves `word_match_distr_1976-2015.mat` which can be visualized and transferred to a `.tex` table by running `plot_word_match_distr.m` in directory *make_figures*.
7. Run `prepare_conversion_table.m` which loads and prepares the table which allows to link patent's technologoy classification number to manufacturing sectors. It saves `conversion_table.mat` to *conversion_patent2industry*. 
8. Run `match_pat2industry.m` which for 26 manufacturing sectors check which patents are linked to it.
9. *manual classification* contains the files for testing the performance of the classification algorithm.
	1. Use `draw_patents4manclass.m` to draw a random sample of patents and send information about that patent to an excel file `manclass_v[version number].xlsx`.
	2. Follow the instructions from the `manual_coding_handbook.tex` (which is also in this directory) to manually classify patents.
	3. Run `prepare_manclass.m` to test the format of the coded files and add this data to the structure `manclassData.mat`.
	4. Run `analyze_manclass.m` to apply different classification algorithms on this test set and calculate a number of performance metrics.
	5. Run `make_manclass_contingency_table.m` to produce a `.tex` table with the results.


Necessary software:
---------------------------
We wrote and tested this in Matlab R2013b. No toolboxes are used (apart from `hpfilter` from the Econometrics Toolbox for some non-essential plots).


