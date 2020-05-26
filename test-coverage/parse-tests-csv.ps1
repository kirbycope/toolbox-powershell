# Purpose: To create a ReadMe.md file in this directory that shows all tests in a CSV file.

# Allow the current user to run this script
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned;

# Define the directory where this script resides
$scriptDirectory = split-path -parent $psISE.CurrentFile.Fullpath;

# Define the root directory
$rootDirectory = Split-Path -Path $psISE.CurrentFile.FullPath -Parent | Split-Path -Parent| Split-Path -Parent;
Set-Location $rootDirectory | Out-Null;

# Import the code library
. "$rootDirectory\scripts\libraries\file-parser-library.ps1";

# Define the test directory
$testDirectory = "$rootDirectory\TestsWebUI\Tests";

# Get all .cs files in the Test directory
$files = Get-ChildItem -Path $testDirectory -Recurse -Include *.cs;

# Parse the .cs files
$tests = Parse-TestFiles $files;

# Save the tests to a CSV file
$tests | Export-Csv -Path "$rootDirectory\documentation\automated-test-cases.csv" -NoTypeInformation

# Open the file
Invoke-Item "$rootDirectory\documentation\automated-test-cases.csv"
