# Params for command-line
param(
    # The full file path to vstest.console.exe
    [string] $vstestPath = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe",
    # The full file path to the test dynamic-link-library
    [string] $testDllPath = "C:\Users\timothy.cope\source\repos\cdc_ipsas\CDC_IPSAS\CDC.IPSAS.Testing.EFSAP\CDC.IPSAS.Testing.EFSAP\bin\Release\CDC.IPSAS.Testing.EFSAP.dll",
    # The filter to apply
    [string] $filter = "",
    # The logger to use
    [string] $logger = "/Logger:trx"
)

# Define the filter
#$filter= "/TestCaseFilter:TestCategory=`"Smoke`"";

# Run the command
"$vsTestPath $testDllPath $filter $logger";
& $vsTestPath $testDllPath $filter $logger;
