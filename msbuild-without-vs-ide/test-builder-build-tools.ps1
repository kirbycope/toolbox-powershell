# Allow the current user to run this script
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Define the root directory
$rootDirectory = Split-Path -Path $psISE.CurrentFile.FullPath -Parent | Split-Path -Parent | Split-Path -Parent;
Set-Location $rootDirectory;

# Define the path to the solution file
$solution = "$rootDirectory\SolutionName.sln";

# Define the URL for NuGet
$nugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe";

# Define the path for the NuGet executable
$nugetExe = "$rootDirectory\nuget.exe";

# Download the Nuget executable, if necessary
if ( (Test-Path $nugetExe -PathType Leaf) -eq $false) {
    Invoke-WebRequest $nugetUrl -Outfile $nugetExe
}

# Restore NuGet packages
"$nugetExe restore $solution";
& $nugetExe restore $solution;

# Define the build configuration
$configuration = "/p:Configuration=Debug";

# Define the path to the msbuild exe
$msbuild = "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\amd64\MSBuild.exe";

# Run the command
"$msbuild $solution $configuration";
& $msbuild $solution $configuration;
