#-- Git vars
# The path the the repo on the local machine
$repoPAth = "C:\Users\timothy.cope\Source\Repos\cdc_ipsas"

#-- MsBuild vars
# The full file path to msbuild.exe
$msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\amd64\MSBuild.exe"
# The full file path to the solution
$solutionPath = "C:\Users\timothy.cope\Source\Repos\cdc_ipsas\CDC_IPSAS\CDC.IPSAS.Testing.EFSAP\CDC.IPSAS.Testing.EFSAP.sln"
# The configuration to build
$configuration = "/p:Configuration=Release";

#-- VSTest vars
# The full file path to vstest.console.exe
$vstestPath = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe"
# The full file path to the test dynamic-link-library
$testDllPath = "C:\Users\timothy.cope\source\repos\cdc_ipsas\CDC_IPSAS\CDC.IPSAS.Testing.EFSAP\CDC.IPSAS.Testing.EFSAP\bin\Release\CDC.IPSAS.Testing.EFSAP.dll"
# The filter to apply
$filter = ""
# The logger to use
$logger = "/Logger:trx;LogFileName=cdc_ipsas-dev.trx"

#-- _this_ script vars
$powershelScript = "C:\Users\timothy.cope\Source\Repos\cdc_ipsas\CDC_IPSAS\CDC.IPSAS.Testing.EFSAP\scripts\tests-build-run-push.ps1"

# Run script via powershell
"$powershelScript -repoPAth $repoPAth -msbuildPath $msbuildPath -solutionPath $solutionPath -configuration $configuration -vstestPath $vstestPath -testDllPath $testDllPath -filter $filter -logger $logger"
& $powershelScript -repoPath $repoPAth -msbuildPath $msbuildPath -solutionPath $solutionPath -configuration $configuration -vstestPath $vstestPath -testDllPath $testDllPath -filter $filter -logger $logger
