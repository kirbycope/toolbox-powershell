# Purpose: To create a CSV file in the documentation directory that shows all test results in a CSV file.

# Allow the current user to run this script
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned;

# Define the root directory
$rootDirectory = Split-Path -Path $psISE.CurrentFile.FullPath -Parent | Split-Path -Parent | Split-Path -Parent;
Set-Location $rootDirectory;

# Import the code library
. "$rootDirectory\scripts\libraries\file-parser-library.ps1";

# Define the directory for the test results
$testResultsDirectory = $rootDirectory + "\TestResults";

# Get the path of the last file modified
$testResultsPath = Get-LastModified $testResultsDirectory;

# Parse the results
$testResults = Parse-TestResults $testResultsPath;

# Define the directory for the parsed test results file
$resultsCsvPath = "$rootDirectory\documentation\test-results.csv";

# Save the tests to a CSV file
$testResults | Export-Csv -Path $resultsCsvPath -NoTypeInformation

# Display the parsed test results in the csv file
Invoke-Item $resultsCsvPath
