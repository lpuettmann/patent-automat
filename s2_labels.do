* Open data with patents for SIC industries and assign variable labels
* (The most likely candidates you will want to work with are those that end 
* on "_use".)

clear       
cls

* Set working directory
if  "`c(os)'" == "MacOSX" {
	cd "/Users/Lukas/Documents/mydocs/projects/2015/PatentSearch_Automation/patent-automat"
}

if "`c(hostname)'" == "E700-Puettmann" {
	cd D:\patent-automat
}

* Import data
use "output/sicData.dta", clear

* Assign labels to the data
label var sic "SIC industries"
label var nr_pat "Number patents"
label var nr_fracpat "Number patents (fractional counting)"
label var nr_autompat "Number automation patents"
label var nr_fracautompat "Number automation patents (fractional counting)"
label var nr_software "Number software patents"
label var nr_fracsoftware "Number software patents (fractional counting)"
label var nr_robot "Number robot patents"
label var nr_fracrobot "Number robot patents (fractional counting)"
label var patents_mfg "Number of patents by industry of manufacture"
label var patents_use "Number of patents by sector of use"
label var automix_mfgt "Number of automation patents by industry of manufacture"
label var automix_use "Number of automation patents by sector of use"
label var software_mfgt "Number of software patents by industry of manufacture"
label var software_use "Number of software patents by sector of use"
label var robot_mfgt "Number of robot patents by industry of manufacture"
label var robot_use "Number of robot patents by sector of use"
label var year "Year"
label var overcat "More highly aggregated overcategories of SIC industries"

* Save again
save "output/sicData.dta", replace
