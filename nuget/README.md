# Description
Uses [NuGet](https://www.nuget.org/) to publish a package.

# What the script does
1. Save the file changes
   1. `Set-Content -Path $specFile $nuspecContent -Force;`
1. Package the Nuget
   1. `nuget pack;`
1. Add the Nuget Source
   1. `nuget sources Add -Name "$name" -Source "$source";`
1. Push to the Nuget Source
   1. `nuget push -Source "$source" -ApiKey AzureDevOps $nupkg;`
