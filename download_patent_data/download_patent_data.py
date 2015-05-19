# http://yizeng.me/2014/05/23/download-pdf-files-automatically-in-firefox-using-selenium-webdriver/

from selenium import webdriver 
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile

profile = FirefoxProfile ()
profile.set_preference("browser.download.panel.shown", False) 

profile.set_preference("browser.download.folderList", 2) # 2 means specify custom location
profile.set_preference("browser.download.manager.showWhenStarting", False)
profile.set_preference("browser.download.dir", 'D:\\') # choose folder to download to
profile.set_preference("browser.helperApps.neverAsk.saveToDisk",'application/octet-stream')

driver = webdriver.Firefox(firefox_profile=profile)
driver.get('https://www.google.com/googlebooks/uspto-patents-grants-text.html#2015')

filename = driver.find_element_by_xpath('//a[contains(text(),"ipg150106.zip")]') # use loop to list all zip files
filename.click()
