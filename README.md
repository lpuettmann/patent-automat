Analyze Patent Grant Texts
===========================================================
**Katja Mann, Lukas Püttmann**

- [Overview](https://github.com/lpuettmann/patent-automat#overview)
- [Before running](https://github.com/lpuettmann/patent-automat#before-running)
- [To run](https://github.com/lpuettmann/patent-automat#to-run)
- [Outputs](https://github.com/lpuettmann/patent-automat#outputs)
- [Necessary software](https://github.com/lpuettmann/patent-automat#necessary-software)


Overview:
---------------------------
This repository holds the codes for our paper. Please let us know if you find any bugs by filing an issue or sending us an email. You are free to use them (see [license](https://github.com/lpuettmann/patent-automat/blob/master/LICENSE.md)). If you do, please cite us.

Get data:
---------------------------
Use [these](https://github.com/lpuettmann/get-patents) codes to obtain the patent grant texts.


Before running:
---------------------------
In directory */specs* in in `set_data_path.m` specify the absolute paths to the patent text data. 

Run `set_up.m` to add the current directory and all underlying directories to Matlab's search path. 

Only then run `testPatentAutomat.m` to use Matlab's xUnit testing framework which checks if the code functions properly. There should be no warnings or error messages here.

To run:
---------------------------
Run `run_patentsearch.m`. You can find all the figures and tables that go into the paper in the directory */output*.

Outputs:
---------------------------
The program creates among other things `sic_automix_allyears.csv`. This industry-year dataset is described in more details [here](https://github.com/lpuettmann/patent-automat/wiki/Data-description-of-industry-year-CSV-datafile).

Necessary software:
---------------------------
We wrote and tested this in Matlab R2013b on Windows, OS X and Linux machines. No toolboxes are used. The tests rely on Matlab's xUnit Framework which are included in Matlab from version R2013a (March 2013) onwards or else you downloaded them [here](http://de.mathworks.com/matlabcentral/fileexchange/22846-matlab-xunit-test-framework).
