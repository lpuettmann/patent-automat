Analyze Patent Grant Texts
===========================================================
**Katja Mann, Lukas Püttmann (2015)**
*University of Bonn*

Get data:
---------------------------
Go to [Google Patents](http://www.google.com/googlebooks/uspto-patents-grants-text.html) and download the Patent Grant Full Texts for all years 1976-2015. For 2001, the data is provided as two filetypes. We choose the one used in the previous years (plain `.txt`). The unzipped files are 98 GB for 1976-2001 and 238 GB for 2002-2015. Put the unzipped data files into subfolders *[year]*. Adjust the paths to this data in the files for steps 1. and 2. below.


To run:
---------------------------
1. Search through weekly patent grant text files and save where each new patent starts. Also save the technology classification number (sometimes called OCU). As the file formatting changes, we currently run the analysis separately for periods with different formatting. Save `.mat` files `patent_index_[year].mat` to folder *patent_index*.
	1. Run `find_patents_part1.m`. Years: 1976-2001
	2. Run `find_patents_part2.m`. Years: 2002-2004
	3. Run `find_patents_part3.m`. Years: 2005-2015
2. Search for keyword through (the same) weekly patent grant text files. It draws on the  previously constructed patent indices. Save `.mat` files `patent_keyword_appear_[year].mat` to folder *matches*.
	1. Run `analyze_patent_text_part1.m`. Years: 1976-2001
	2. Run `analyze_patent_text_part2.m`. Years: 2002-2004
	3. Run `analyze_patent_text_part3.m`. Years: 2005-2015
3. In folder *make_figures*, run scripts to visualize findings.
	1. Run `summarize_matches` first.
	2. Make the visualizations you like. The most important ones are probably the following:
		* `plot_matches_overtime.m` 
		* `plot_matches_over_nrpatents_weekly.m` 
		* `plot_summary_statistics_overtime.m` 
4. The script `transfer_matches_2stata.m` deletes those patents that start with a letter and cleans patent classifications. Then export matches to `.csv` to be transported to Stata. It saves all `.csv` files to *cleaned_matches_and_patentnr*. 