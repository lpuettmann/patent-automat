Analyze Patent Grant Texts
===========================================================
**Katja Mann, Lukas Püttmann (2015)**



To run:
---------------------------
1. Run `find_patents.m`. This runs through patent grant texts and saves where new patents start. It also saves the patent's WKU number and the name rows that are deleted. 
2. Main analysis file is `analyze_patent_text.m`. This searches the patent text files for a specified keyword.
3. In folder *make_figures*, run script to visualize findings.


Current plan:
---------------------------
1. Do a text search through the corpus of United States patent texts. Look for words with "autom" in them.

2. Count the number of times the keyword appears in the patent description.

3. Match patent to industries. Patent classifications have already been matched to industry sectors. 

4. Look at how our index correlates with:
	1. other indices for automatization
	2. offshoring indices
