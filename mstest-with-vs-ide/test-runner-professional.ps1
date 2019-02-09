# Allow the current user to run this script
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Define the root directory
$rootDirectory = Split-Path -Path $psISE.CurrentFile.FullPath -Parent | Split-Path -Parent | Split-Path -Parent;
Set-Location $rootDirectory;

# Define the path to the test code
$testDll = "$rootDirectory\ProjectName\bin\Debug\ProjectName.dll";

# Define the path to the vs test runner
$vsTest = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe";

# Define the filter
#$filter= "/TestCaseFilter:TestCategory=`"Element Verification`"";

# Define the logger
$logger = "/Logger:trx";

# Run the command
"$vsTest $testDll $filter $logger";
& $vsTest $testDll $filter $logger;
