
from selenium import webdriver 
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile


# Define parameters
# ----------------------------------------------------------------
savepath = 'D:\\' # set the desired path here for the files
#savepath = 'D:\\2015' # set the desired path here for the files
fname = ["ipg150106.zip", "ipg150113.zip"]


# Download the files from Google Patents
# ----------------------------------------------------------------
profile = FirefoxProfile ()
profile.set_preference("browser.download.panel.shown", False) 

profile.set_preference("browser.download.folderList", 2) # 2 means specify custom location
profile.set_preference("browser.download.manager.showWhenStarting", False)
profile.set_preference("browser.download.dir", savepath) # choose folder to download to
profile.set_preference("browser.helperApps.neverAsk.saveToDisk",'application/octet-stream')

driver = webdriver.Firefox(firefox_profile=profile)
driver.get('https://www.google.com/googlebooks/uspto-patents-grants-text.html#2015')

print('Enter loop:')

#for f in fname:
	#filename = driver.find_element_by_xpath('//a[contains(text(), f)]') # use loop to list all zip files
	#filename.click()
	#print('Finished loop for: {}.'.format(f))

# print(filename)

# print('Try it out again')
# filename.click()

filename = driver.find_element_by_xpath('//a[contains(text(), "ipg150106.zip")]') # use loop to list all zip files
filename.click()

#filename = driver.find_element_by_xpath('//a[contains(text(), "ipg150113.zip")]') # use loop to list all zip files
#filename.click()

print('End.')
