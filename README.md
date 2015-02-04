Automization and Reshoring
===========================================================
**Katja Mann, Lukas Püttmann (2015)**


1. Do a text search through the corpus of United States patent texts. Look for words with "autom" in them.

2. Count the number of times the keyword appears in the patent description.

3. Match patent to industries. Patent classifications have already been matched to industry sectors. 

4. Look at how our index correlates with:
	1. other indices for automatization
	2. offshoring indices

Current known issues:
---------------------------
1. Year 1982, week 52, the word “PATNO” shows up in the text. I managed to circumvent this problem by using “strcomp” which compares strings for exact equality.
2. Year 1999, week 14, “PATN” shows up (when it’s not supposed to) on line number 2281359 in a table. This puts the WKU to “mum or ma”. My test found the white-space in that. 