# Params for command-line
param(
    #-- Git vars
    # The path the the repo on the local machine
    [string] $repoPAth,

    #-- MsBuild vars
     # The full file path to msbuild.exe
    [string] $msbuildPath,
    # The full file path to the solution
    [string] $solutionPath,
    # The configuration to build
    [string] $configuration,

    #-- VSTest vars
    # The full file path to vstest.console.exe
    [string] $vstestPath,
    # The full file path to the test dynamic-link-library
    [string] $testDllPath,
    # The filter to apply
    [string] $filter,
    # The logger to use
    [string] $logger
)

"cd $repoPath"
& cd $repoPath

"git checkout master --force"
& git checkout master --force

"git pull"
& git pull

"git checkout qa"
& git checkout qa

"git merge master"
& git merge master

"$msbuildPath $solutionPath $configuration";
& $msbuildPath $solutionPath $configuration;

"$vsTestPath $testDllPath $filter $logger";
& $vsTestPath $testDllPath $filter $logger;

"git commit -a -m `"test results`""
& git commit -a -m "test results"

"git push"
& git push
