# Params for command-line
param(
    # The full file path to msbuild.exe
    [string] $msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\amd64\MSBuild.exe",
    # The full file path to the solution
    [string] $solutionPath = "C:\Users\timothy.cope\source\repos\cdc_ipsas\CDC_IPSAS\CDC.IPSAS.Testing.EFSAP\CDC.IPSAS.Testing.EFSAP.sln",
    # The configuration to build
    [string] $configuration = "/p:Configuration=Release"
)

"$msbuildPath $solutionPath $configuration";
& $msbuildPath $solutionPath $configuration;
