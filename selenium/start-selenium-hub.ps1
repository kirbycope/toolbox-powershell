# Author: Timothy Cope
# Reference: https://www.seleniumhq.org/docs/07_selenium_grid.jsp#starting-a-hub
# Reference: http://web.archive.org/web/20190217011809/http://timothycope.com/working-with-selenium-3-grid/

# Define the Selenium Server Standalone JAR path
$Jar = "C:\selenium\selenium-server-standalone.jar"

# Start a Selenium Grid Hub
Start-Process java -ArgumentList "-jar $Jar -role hub"

# Open the Selenium Grid Hub console
$ie = New-Object -ComObject "InternetExplorer.Application"
$ie.navigate("http://localhost:4444/grid/console")
