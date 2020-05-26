# Description
Uses the MSBuild from the [Build Tools](https://visualstudio.microsoft.com/downloads/?q=build+tools) to build a solution.

# What the script does
1. Download [NuGet](https://www.nuget.org/)
   1. `Invoke-WebRequest $nugetUrl -Outfile $nugetExe`
1. Restore Nuget packages
   1. `$nugetExe restore $solution;`
1. Build the solution
   1. `$msbuild $solution $configuration;`
