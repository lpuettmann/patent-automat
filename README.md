Automization and Reshoring
===========================================================
**Katja Mann, Lukas Püttmann (2015)**


Current plan:
---------------------------
1. Do a text search through the corpus of United States patent texts. Look for words with "autom" in them.

2. Count the number of times the keyword appears in the patent description.

3. Match patent to industries. Patent classifications have already been matched to industry sectors. 

4. Look at how our index correlates with:
	1. other indices for automatization
	2. offshoring indices


To run:
---------------------------
1. Run `find_patents.m`. This runs through patent grant texts and saves where new patents start. It also saves the patent's WKU number and the name rows that are deleted. 
2. Main analysis file is `analyze_patent_text.m`. This searches the patent text files for a specified keyword.
3. In folder *make_figures*, run script to visualize findings.



Current known issues:
---------------------------
1. Year 1982, week 52, the word “PATNO” shows up in the text. I managed to circumvent this problem by using “strcomp” which compares strings for exact equality.
2. Year 1984, week 50, at line 377322, hit PATN 866/1516 the format changes. There is an empty line between PATN and WKU.
3. Year 1999, week 14, “PATN” shows up (when it’s not supposed to) on line number 2281359 in a table. This puts the WKU to “mum or ma”. My test found the white-space in that. 
4. Year 2001, week 52, "PATNOS" shows up on line 1300139. Year 2001 at the moment gets a special treatment that truncates all lines to the first 4 characters. This means PATNOS is shortened to PATN and looks like a new patent. The WKU that is given to that then spells "C. Piguet" which raises a white-space warning.