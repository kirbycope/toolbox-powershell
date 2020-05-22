# Allow the current user to run this script
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned;

# Define the root directory
$rootDirectory = Split-Path -Path $psISE.CurrentFile.FullPath -Parent | Split-Path -Parent | Split-Path -Parent;
Set-Location $rootDirectory;

# Define the path to the solution file
$solution = "$rootDirectory\SolutionName.sln";

# Define the build configuration
$configuration = "/p:Configuration=Debug";

# Define the path to the msbuild exe
$msbuild = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\amd64\MSBuild.exe";

# Run the command
"$msbuild $solution $configuration";
& $msbuild $solution $configuration;
