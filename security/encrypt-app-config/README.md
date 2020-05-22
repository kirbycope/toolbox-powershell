# Description
Uses the [ASP.NET IIS Registration Tool](https://docs.microsoft.com/en-us/previous-versions/aspnet/zhhddkxy(v%3Dvs.100)) to encrypt or decrypt sections of a Web configuration file.

# What the script does
1. (Temporarily) Rename the app.config to web.config
   1. Rename-Item -Path "$appConfig" "$webConfig"
1. Encrypt the config
   1. `$regiis -pef $pef $configDirectory;`
