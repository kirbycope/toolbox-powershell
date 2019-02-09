# NOTE: Encrypting requires elevated user privileges (run this as an admin)

# The following is an example of a section to be encrypted:
#  <appSettings>
#    <add key="SqlConnectionString" value="Data Source=10.000.00.1; Initial Catalog=CatalogName; User id=foo; Password=bar;" />
#  </appSettings>

# Allow the current user to run this script
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Define the root directory of the project (based off this script's expected location)
$rootDirectory = Split-Path -Path $psISE.CurrentFile.FullPath -Parent | Split-Path -Parent | Split-Path -Parent;

# Change the working location from this script's directory to the root directory
Set-Location $rootDirectory;

# Define the path to the aspnet regiis
$regiis = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe";

# Define the section of the configuration file to encrypt
$pef = "`"appSettings`"";

# Define the path to the configuration file(s)
$configDirectory = "$rootDirectory\ProjectName";
$appConfig = "$configDirectory\app.config";
$webConfig = "$configDirectory\web.config";

# (Temporarily) Rename the app.config to web.config
Rename-Item -Path "$appConfig" "$webConfig"

# Print the command
"$regiis -pef $pef $configDirectory";

# Execute the command
& $regiis -pef $pef $configDirectory;

# Rename the web.config [back] to app.config
Rename-Item -Path "$webConfig" "$appConfig"
