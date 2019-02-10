#region Imports

# Get the file path of this (running) .ps1 file
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Add-Type -Path "$dir\WebDriver.dll";
Add-Type -Path "$dir\WebDriver.Support.dll";
$env:PATH += ";$dir";

#endregion Imports

function Click([OpenQA.Selenium.By] $by)
{
    $global:driver.FindElement($by).Click()
}

function Click-Via-JavaScript([OpenQA.Selenium.By] $by)
{
    $element = $global:driver.FindElement($by)
    $global:driver.ExecuteScript("arguments[0].click()", $element)
}

function Displayed([OpenQA.Selenium.By] $by)
{
    try
    {
        $global:driver.FindElement($by).Displayed
    }
    catch
    {
        return $false;
    }
}

function Find-Element([OpenQA.Selenium.By] $by)
{
    $global:driver.FindElement($by)
}

function Find-Elements([OpenQA.Selenium.By] $by)
{
    $global:driver.FindElements($by)
}

function Get-Attribute([OpenQA.Selenium.By] $by, [string] $attribute)
{
    $global:driver.FindElement($by).GetAttribute($attribute)
}

function Get-Text([OpenQA.Selenium.By] $by)
{
    $global:driver.FindElement($by).Text.Trim()
}

function Go-To-Url([string] $url)
{
    $global:driver.Navigate().GoToUrl($url)
}

function Send-Keys([OpenQA.Selenium.By] $by, [string] $text)
{
    $global:driver.FindElement($by).SendKeys($text)
}

function SetUp-WebDriver
{
    $global:driver = New-Object -TypeName OpenQA.Selenium.Chrome.ChromeDriver
    try { $global:driver.Manage().Window.Maximize() } catch { <# do nothing #> }
}

function TearDown-WebDriver
{
    $global:driver.Quit()
}

function Wait-For-Element([OpenQA.Selenium.By] $by)
{
    $timeSpan = New-TimeSpan -Seconds 60;
    $wait = New-Object OpenQA.Selenium.Support.UI.WebDriverWait($global:driver, $timeSpan)
    $wait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementExists($by)) | Out-Null
}

function Wait-For-Url-To-Contain([string] $textToFind)
{
    $timeSpan = New-TimeSpan -Seconds 60;
    $wait = New-Object OpenQA.Selenium.Support.UI.WebDriverWait($global:driver, $timeSpan)
    $wait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::UrlContains($textToFind)) | Out-Null
}
