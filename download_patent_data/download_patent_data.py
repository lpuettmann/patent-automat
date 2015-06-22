
from selenium import webdriver 
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile

import urllib.request
import re



# Define parameters
# ----------------------------------------------------------------
#savepath = '/Users/Lukas/econ/PatentData/1976' # set the desired path here for the files
savepath = 'D:\\1976' # set the desired path here for the files
#fname = ["ipg150106.zip", "ipg150113.zip"]
fname = ["pftaps19760106_wk01.zip", "pftaps19760113_wk02.zip"]




# Download the files from Google Patents
# ----------------------------------------------------------------
profile = FirefoxProfile ()
profile.set_preference("browser.download.panel.shown", False) 

profile.set_preference("browser.download.folderList", 2) # 2 means specify custom location
profile.set_preference("browser.download.manager.showWhenStarting", False)
profile.set_preference("browser.download.dir", savepath) # choose folder to download to
profile.set_preference("browser.helperApps.neverAsk.saveToDisk",'application/octet-stream')

#driver = webdriver.Firefox(firefox_profile=profile)

url = 'https://www.google.com/googlebooks/uspto-patents-grants-text.html#2015'
#driver.get(url)


html = urllib.request.urlopen(url).read()

links = re.findall('<a href="(.*)">', html)
print(links)


#print('Enter loop:')

#for f in fname:
#    filename = driver.find_element_by_partial_link_text(f)
#    filename.click()

#print('End.')
