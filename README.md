Analyze Patent Grant Texts
===========================================================
**Katja Mann, Lukas Püttmann (2015)**


Get data:
---------------------------
Go to [Google Patents](http://www.google.com/googlebooks/uspto-patents-grants-text.html) and download the Patent Grant Full Texts for all years 1976-2015. 

| Years  | Format | Size (unzipped) | 
| ------------- | ------------- | ------------- |
| 1976-2015  | `.txt` | 98 GB |
| 2002-2015  | `.XML`, `.xml` | 238 GB |

Put the unzipped data files into subfolders *[year]*. Adjust the paths to this data in the function `set_data_path.m` in folder *functions*.

So in directory (folder) *1976* you should see:
```
$ls
pftaps19760106_wk01.txt pftaps19760113_wk19.txt pftaps19760120_wk37.txt
pftaps19760106_wk02.txt pftaps19760113_wk20.txt pftaps19760120_wk38.txt
pftaps19760106_wk03.txt pftaps19760113_wk21.txt pftaps19760120_wk39.txt
...		...		...
```


Before running:
---------------------------
1. In directory *specs* in in `set_data_path.m` specify the absolute paths to the patent text data.
2. Run `set_up.m` to add the current directory and all underlying directories to Matlab's search path.
3. Run `testPatentAutomat.m` to use Matlab's xUnit testing framework which checks if the code functions properly.


To run:
---------------------------
Run `run_patentsearch.m`. It runs `set_up.m` (step 1) above and then executes the steps explained below.


Individual steps:
---------------------------
1. Search through weekly patent grant text files and save where each new patent starts. Also save the first 3 digits of the technology classification number (sometimes called OCU). As the file formatting changes, we currently run the analysis separately for periods with different formatting. This saves `.mat` files `patent_index_[year].mat` to folder *patent_index*. 
2. Search for keyword through (the same) weekly patent grant text files. It draws on the  previously constructed patent indices. Also save a list of the words surrounding the matches. This saves `.mat` files `patent_keyword_appear_[year].mat` to folder *matches*.
3. Run `clean_matches.m`. This deletes those patents whose numbers start with a letter. It also deletes the previously saved list of words that were found for every patent. It then extracts the patent number from by deleting the first or last letter, depending on year formatting. This saves `.mat` files `patsearch_results_[year].mat` to folder *cleaned_matches*.
4. Visualize findings: First run `summarize_matches.m` first, then make several plots.
5. Run `transfer_cleaned_matches2csv.m`. This takes `patsearch_results_[year].mat`, cleans the numbers some more and then saves the results from the patent search for all years in an .csv to be exported to Stata.
6. Run `prepare_conversion_table.m` which loads and prepares the table which allows to link patent's technologoy classification number to manufacturing sectors. It saves `conversion_table.mat` to *conversion_patent2industry*. 
7. Run `match_pat2industry.m` which for 26 manufacturing sectors check which patents are linked to it.
8. *manual classification* contains the files for testing the performance of the classification algorithm.
	1. Use `draw_patents4manclass.m` to draw a random sample of patents and send information about that patent to an excel file `manclass_v[version number].xlsx`.
	2. Follow the instructions from the `manual_coding_handbook.tex` to manually classify patents.
	3. Run `prepare_manclass.m` to test the format of the coded files and add this data to the structure `manclassData.mat`.
	4. Run `analyze_manclass.m` to apply different classification algorithms on this test set and calculate a number of performance metrics.
	5. Run `make_manclass_contingency_table.m` to produce a `.tex` table with the results.


Necessary software:
---------------------------
We wrote and tested this in Matlab R2013b on Windows, OS X and Linux machines. No toolboxes are used (apart from `hpfilter` from the Econometrics Toolbox for some non-essential plots). The tests rely on Matlab's xUnit Framework which are included in Matlab from version R2013a (March 2013) onwards or else can be downloaded [here](http://de.mathworks.com/matlabcentral/fileexchange/22846-matlab-xunit-test-framework).


