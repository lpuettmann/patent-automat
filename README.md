Analyze Patent Grant Texts
===========================================================
**Katja Mann, Lukas Püttmann

1. [Overview](https://github.com/lpuettmann/patent-automat#overview)
2. [Get data](https://github.com/lpuettmann/patent-automat#get-data)
3. [Before running](https://github.com/lpuettmann/patent-automat#before-running)
4. [To run](https://github.com/lpuettmann/patent-automat#to-run)
5. [Necessary software](https://github.com/lpuettmann/patent-automat#necessary-software)

Overview:
---------------------------
This repository holds the codes for our paper. Please let us know if you find any bugs by filing an issue or sending us an email. You are free to use them (see [license](https://github.com/lpuettmann/patent-automat/blob/master/LICENSE.md)). If you do, please cite us as

> Mann, Katja and Lukas Püttmann (2016). "A New Indicator of Automation Based on Patent Text Search". University of Bonn.

Get data:
---------------------------
The Matlab function `download_patent_files.m` goes to [Google Patents](http://www.google.com/googlebooks/uspto-patents-grants-text.html) and downloads the Patent Grant Full Texts for all years 1976-2015. 

| Years  | Format | Size (unzipped) | 
| ------------- | ------------- | ------------- |
| 1976-2015  | `.txt` | 98 GB |
| 2002-2015  | `.XML`, `.xml` | 238 GB |

It puts the unzipped data files into subdirectories */[year]*. Adjust the paths to this data in the function `set_data_path.m` in directory */specs*.

So in directory */1976* you should see:
```
$ls
pftaps19760106_wk01.txt
pftaps19760106_wk02.txt
pftaps19760106_wk03.txt
...
```
and in directory */2014* you should see:
```
$ls
ipg140107.xml
ipg140114.xml
ipg140121.xml
...
```

Before running:
---------------------------
In directory */specs* in in `set_data_path.m` specify the absolute paths to the patent text data. Be aware that you still have to do this even if you automatically downloaded the files using the `download_patent_files.m` function. 

Run `set_up.m` to add the current directory and all underlying directories to Matlab's search path. Only then run `testPatentAutomat.m` to use Matlab's xUnit testing framework which checks if the code functions properly. There should be no warnings or error messages here.

To run:
---------------------------
Run `run_patentsearch.m`. You can find all the figures and tables that go into the paper in the directory */output*.

Necessary software:
---------------------------
We wrote and tested this in Matlab R2013b on Windows, OS X and Linux machines. No toolboxes are used. The tests rely on Matlab's xUnit Framework which are included in Matlab from version R2013a (March 2013) onwards or else you downloaded them [here](http://de.mathworks.com/matlabcentral/fileexchange/22846-matlab-xunit-test-framework).
