# Author: Timothy Cope

function Create-SeleniumDirectory ($seleniumDirectory) {
    # Pre-Event Message
    Write-Host "Creating the local selenium folder..."

    # Create the folder
    New-Item -ItemType Directory -Force -Path $seleniumDirectory | Out-Null

    # Post-Event Message
    Write-Host "  => $seleniumDirectory" -ForegroundColor Green

    return $seleniumDirectory
}

function Download-File ($requestUri, $directory, $fileName) {
    # Pre-Event Message
    Write-Host "Downloading file..."
    
    # Download the file and save it to the local selenium folder
    Invoke-WebRequest $requestUri -OutFile $directory\$fileName
    
    # Post-Event Message
    Write-Host "  => $($directory)\$($fileName)" -ForegroundColor Green

    return "$directory\$fileName"
}

function Get-LatestDownloadUrlSelenium {
    # Pre-Event Message
    Write-Host "Getting the latest Selenium Standalone Server download URL..."

    # Navigate to the page and find the latest download link
    $DownloadPageUrl = "https://www.seleniumhq.org/download/"
    $SeleniumStandaloneServerUrl = (Invoke-WebRequest -UseBasicParsing $DownloadPageUrl).Content | %{[regex]::matches($_, '(?:<a href="https://bit.ly)(.*)(?:">)').Groups[1].Value}
    $SeleniumStandaloneServerUrl = "https://bit.ly$SeleniumStandaloneServerUrl"

    # Post-Event Message
    Write-Host "  => $SeleniumStandaloneServerUrl" -ForegroundColor Green

    return $SeleniumStandaloneServerUrl
}

function Get-LatestDownloadUrlChromeDriver {
    # Pre-Event Message
    Write-Host "Getting the latest Chrome WebDriver download URL..."

    # Navigate to the page and find the latest download link
    $DownloadPageUrl = "https://chromedriver.chromium.org/downloads"
    $DownloadPage = Invoke-WebRequest -Uri $DownloadPageUrl
    $LatestDownloadUrl = ($DownloadPage.links | Where-Object {$_.href -like "*chromedriver.storage.googleapis.com/index.html?path=*"} | Select-Object -First 1).href
    $Tag = $LatestDownloadUrl.Substring($LatestDownloadUrl.IndexOf("=")+1)                   
    $ChromeDriverUrl = "https://chromedriver.storage.googleapis.com/$($Tag)chromedriver_win32.zip"
    
    # Post-Event Message
    Write-Host "  => $ChromeDriverUrl" -ForegroundColor Green

    return $ChromeDriverUrl
}

function Get-LatestDownloadUrlEdgeDriver {
    # Pre-Event Message
    Write-Host "Getting the latest Edge WebDriver download URL..."

    # Navigate to the page and find the latest download link
    $DownloadPageUrl = "https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/#downloads"
    $DownloadPage = Invoke-WebRequest -Uri $DownloadPageUrl
    $EdgeDriverUrl = ($DownloadPage.links | Where-Object {$_.href -like "*download.microsoft.com/download/*"} | Select-Object -First 1).href

    # Post-Event Message
    Write-Host "  => $EdgeDriverUrl" -ForegroundColor Green

    return $EdgeDriverUrl
}

function Get-LatestDownloadUrlFirefoxDriver {
    # Pre-Event Message
    Write-Host "Getting the latest Firefox WebDriver download URL..."
    
    # Navigate to the page and find the latest download link
    $DownloadPageUrl = "https://github.com/mozilla/geckodriver/releases"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Tag = (Invoke-WebRequest -UseBasicParsing $DownloadPageUrl).Content | %{[regex]::matches($_, '(?:<a href="/mozilla/geckodriver/releases/tag/)(.*)(?:">)').Groups[1].Value}
    $GeckoDriverUrl = "https://github.com/mozilla/geckodriver/releases/download/$Tag/geckodriver-v0.24.0-win32.zip"

    # Post-Event Message
    Write-Host "  => $GeckoDriverUrl" -ForegroundColor Green

    return $GeckoDriverUrl
}

function Get-LatestDownloadUrlIeDriver {
    # Pre-Event Message
    Write-Host "Getting the latest Internet Explorer Driver Server download URL..."
    
    # Navigate to the page and find the latest download link
    $DownloadPageUrl = "https://www.seleniumhq.org/download/"
    $InternetExplorerDriverServerUrl = (Invoke-WebRequest -UseBasicParsing $DownloadPageUrl).Content | %{[regex]::matches($_, '(?:href="https://goo.gl/)(.*)(?:">)').Groups[1].Value}
    $InternetExplorerDriverServerUrl = "https://goo.gl/$InternetExplorerDriverServerUrl"

    # Post-Event Message
    Write-Host "  => $InternetExplorerDriverServerUrl" -ForegroundColor Green

    return $InternetExplorerDriverServerUrl
}

function Get-LatestDownloadUrlJava {
    # Pre-Event Message
    Write-Host "Getting the latest Java download URL..."

    # Navigate to the page and find the latest download link
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $JavaUrl = (Invoke-WebRequest -UseBasicParsing https://www.java.com/en/download/manual.jsp).Content | %{[regex]::matches($_, '(?:<a title="Download Java software for Windows Online" href=")(.*)(?:">)').Groups[1].Value}

    #Invoke-WebRequest -UseBasicParsing -OutFile $SeleniumDirectory\jre-windows-i586.exe $URL

    # Post-Event Message
    Write-Host "  => $JavaUrl" -ForegroundColor Green

    return $JavaUrl
}

#---

# Selenium directory
$SeleniumDirectory = Create-SeleniumDirectory "c:\selenium"

# [SeleniumHQ] Selenium Standalone Server
$SeleniumStandaloneServerUrl = Get-LatestDownloadUrlSelenium
$SeleniumJar = Download-File $SeleniumStandaloneServerUrl $SeleniumDirectory "selenium-server-standalone.jar"

# [Google] Chrome WebDriver
$ChromeDriverUrl = Get-LatestDownloadUrlChromeDriver
$ChromeDriverZip = Download-File $ChromeDriverUrl $SeleniumDirectory "chromedriver_win32.zip"
Expand-Archive $ChromeDriverZip -DestinationPath $SeleniumDirectory -Force

# [Microsoft] Edge WebDriver
$EdgeDriverUrl = Get-LatestDownloadUrlEdgeDriver
$EdgeExe = Download-File $EdgeDriverUrl $SeleniumDirectory "MicrosoftWebDriver.exe"

# [Mozilla] Firefox (Gecko) WebDriver
$FirefoxDriverUrl = Get-LatestDownloadUrlFirefoxDriver
$FirefoxDriverZip = Download-File $FirefoxDriverUrl $SeleniumDirectory "geckodriver-win32.zip"
Expand-Archive $FirefoxDriverZip -DestinationPath $SeleniumDirectory -Force

# [Microsoft] Internet Explorer Driver Server
$InternetExplorerDriverServerUrl = Get-LatestDownloadUrlIeDriver
$InternetExplorerDriverServerZip = Download-File $InternetExplorerDriverServerUrl $SeleniumDirectory "IEDriverServer_Win32.zip"
Expand-Archive $InternetExplorerDriverServerZip -DestinationPath $SeleniumDirectory -Force

# [Oracle] Java
if ((Get-Command java | Select-Object Version) -eq $null) {
    $JavaUrl = Get-LatestDownloadUrlJava
    $JavaExe = Download-File $JavaUrl $SeleniumDirectory "jre-windows-i586.exe"
    Start-Process $JreExe '/s REBOOT=0 SPONSORS=0 AUTO_UPDATE=0' -wait
}
