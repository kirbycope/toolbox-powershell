#---------------------------------------------------------------------------------------------------------------------#
# Set Values below #

$idText                   = "CDC.IPSAS.Testing.Common"
$versionText              = "1.0.12"
$titleText                = "Testing.Common"
$authorsText              = "Timothy Cope"
$ownersText               = "CDC/NWT/MS"
$licenseUrlText           = ""
$projectUrlText           = ""
$iconUrlText              = ""
$requireLicenseAcceptance = "false"
$descriptionText          = "A common helper library used for testing."
$releaseNotesText         = ""
$copyrightText            = "2019"
$tagsText                 = ""

# Set values above #
#---------------------------------------------------------------------------------------------------------------------#

# Allow the current user to run this script
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Define the root directory
$rootDirectory = Split-Path -Path $psISE.CurrentFile.FullPath | Split-Path -Parent

# Set present working directory to the project directory
Set-Location "$rootDirectory\CDC.IPSAS.Testing.Common"

# Create the spec file
nuget spec CDC.IPSAS.Testing.Common -Force

# Define the nuspec file path
$specFile = "$rootDirectory\CDC.IPSAS.Testing.Common\CDC.IPSAS.Testing.Common.nuspec"

# Get the nuspec file content
$nuspecContent = Get-Content -path $specFile -Raw

    #region metadata

    # Replace <id>
    $placeholder = "<id>`$id`$</id>"
    $replacement = "<id>$idText</id>"
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)

    # Replace <version>
    $placeholder = "<version>`$version`$</version>"
    $replacement = "<version>$versionText</version>"
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)

    # Replace <title>
    $placeholder = "<title>`$title`$</title>"
    $replacement = "<title>$titleText</title>"
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)

    # Replace <authors>
    $placeholder = "<authors>`$author`$</authors>"
    $replacement = "<authors>$authorsText</authors>"
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)
    
    # Replace <owners>
    $placeholder = "<owners>`$author`$</owners>"
    $replacement = "<owners>$ownersText</owners>"
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)

    # Replace <licenseUrl>
    $placeholder = "<licenseUrl>http://LICENSE_URL_HERE_OR_DELETE_THIS_LINE</licenseUrl>"
    if ([string]::IsNullOrEmpty($licenseUrlText)) {
        $replacement = ""
    }
    else {
        $replacement = "<licenseUrl>$licenseUrlText</licenseUrl>"
    }
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)
    
    # Replace <projectUrl>
    $placeholder = "<projectUrl>http://PROJECT_URL_HERE_OR_DELETE_THIS_LINE</projectUrl>"
    
    if ([string]::IsNullOrEmpty($projectUrlText)) {
        $replacement = ""
    }
    else {
        $replacement = "<projectUrl>$projectUrlText</projectUrl>"
    }
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)

    # Replace <iconUrl>
    $placeholder = "<iconUrl>http://ICON_URL_HERE_OR_DELETE_THIS_LINE</iconUrl>"
     if ([string]::IsNullOrEmpty($iconUrlText)) {
        $replacement = ""
    }
    else {
        $replacement = "<iconUrl>$iconUrlText</iconUrl>"
    }
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)

    # Replace <requireLicenseAcceptance>
    $placeholder = "<requireLicenseAcceptance>false</requireLicenseAcceptance>"
    $replacement = "<requireLicenseAcceptance>$requireLicenseAcceptance</requireLicenseAcceptance>"
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)

    # Replace <description>
    $placeholder ="<description>`$description`$</description>"
    $replacement = "<description>$descriptionText</description>"
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)

    # Replace <releaseNotes>
    $placeholder ="<releaseNotes>Summary of changes made in this release of the package.</releaseNotes>"
    $replacement = "<releaseNotes>$releaseNotesText</releaseNotes>"
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)

    # Replace <copyright>
    $placeholder ="<copyright>Copyright 2019</copyright>"
    $replacement = "<copyright>$copyrightText</copyright>"
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)

    # Replace <tags>
    $placeholder ="<tags>Tag1 Tag2</tags>"
    $replacement = "<tags>$tagsText</tags>"
    $nuspecContent = $nuspecContent.Replace($placeholder,$replacement)

    #endregion

# Save the file changes
Set-Content -Path $specFile $nuspecContent -Force

# Package the Nuget
nuget pack

# Add the Nuget Source
$name = "SATRNInternalPackages"
$source = "https://cdcipsas-vsts.pkgs.visualstudio.com/_packaging/SATRNInternalPackages/nuget/v3/index.json"
nuget sources Add -Name "$name" -Source "$source"

# Push to the Nuget Source
$nupkg = "$rootDirectory\CDC.IPSAS.Testing.Common\$idText.$versionText.nupkg"
nuget push -Source "$source" -ApiKey AzureDevOps $nupkg
