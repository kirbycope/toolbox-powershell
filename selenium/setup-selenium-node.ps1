# Author: Timothy Cope
# Reference: https://www.seleniumhq.org/docs/07_selenium_grid.jsp#starting-a-node
# Reference: http://web.archive.org/web/20190217011809/http://timothycope.com/working-with-selenium-3-grid/

# Define the Selenium Server Standalone JAR path
$Jar = "C:\selenium\selenium-server-standalone.jar"

# Define the ChromeDriver path
$ChromeDriver = "C:\selenium\chromedriver.exe"

# Define the EdgeDriver path
$EdgeDriver = "C:\selenium\MicrosoftWebDriver.exe"

# Define the FirefoxDriver path
$FirefoxDriver = "C:\selenium\geckodriver.exe"

# Define the InternetExplorerDriver path
$InternetExplorerDriver = "C:\selenium\IEDriverServer.exe"

# Define the Selenium Grid Hub URL
$Hub = "http://localhost:4444/grid/register"

# Start a Selenium Grid Node
Start-Process java -ArgumentList "-Dwebdriver.chrome.driver=$ChromeDriver -Dwebdriver.edge.driver=$EdgeDriver -Dwebdriver.gecko.driver=$FirefoxDriver -Dwebdriver.ie.driver=$InternetExplorerDriver -jar $Jar -role node -hub $Hub"
