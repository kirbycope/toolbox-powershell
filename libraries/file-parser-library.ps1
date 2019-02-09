function Parse-TestFiles([Object]$files) {
    # Define a variable to hold the test(s)
    $tests = @();
    # Loop over each file found
    for ($i = 0; $i -lt $files.Count; $i++) {
        # Get the content of the file
        $content = Get-Content $files[$i].FullName;
        $fileName = $files[$i].Name.Replace(".cs", "") -creplace '.(?=[^a-z])','$& ';
        # Loop over each line of the file
        for ($j = 0; $j -lt $content.Count; $j++) {
            $testName = "";
            $testPath = "";
            $description = "";
            # Look for "TestMethod" in the current line
            if ($content[$j] -like "*TestMethod*") {
                # loop over all following lines, until we find the test method declaration
                $testMethodNameFound = $false;
                for ($k = 1; $testMethodNameFound -eq $false; $k++) {
                    # Check for Description
                    if ($content[$j+$k] -like "*Description*") {
                        $description = $content[$j+$k].Replace("[Description(`"", "").Replace("`")]", "").Trim();
                    }

                    # Check for Test Name
                    if ($content[$j+$k] -like "*public void*") {
                        $testName = $content[$j+$k].Replace("public void ", "").Replace("`")]", "").Replace("()", "").Trim();
                        $testMethodNameFound = $true;
                        # Check for test path
                        if ($testName.StartsWith("HP")) {
                            $testPath = "Happy";
                        }
                        elseif ($testName.StartsWith("NG")) {
                            $testpath = "Negative";
                        }
                    }
                }
            }
            # Add test if found
            if ($testName.Length -gt 0) {
                $testMethod = New-Object PSObject;
                $testMethod | Add-Member -NotePropertyName "Page or View" -NotePropertyValue $fileName;
                $testMethod | Add-Member -NotePropertyName "Test Path" -NotePropertyValue $testPath;
                $testMethod | Add-Member -NotePropertyName "Description" -NotePropertyValue $description;
                $testMethod | Add-Member -NotePropertyName "Test Name" -NotePropertyValue $testName;
                $tests += $testMethod;
            }
        }
    }
    # Return the parsed test(s)
    return $tests;
}

function Parse-TestResults([String]$testResultsPath) {
    
    # Get the test results
    $results = ([XML](Get-Content -Path $testResultsPath)).TestRun.Results;

    # Get the test definitions
    $definitions = ([XML](Get-Content -Path $testResultsPath)).TestRun.TestDefinitions;

    # Create a variable to hold all parsed test results
    $testResults = @();
    # For each result...
    for ($i = 0; $i -lt $results.ChildNodes.Count; $i++) {
        $message = "";
        if ($resultsCount -eq 1) {
            # Get the test id
		    $testId = $results.UnitTestResult.testId;
		    # Get the test name
		    $testName = $results.UnitTestResult.testName;
		    # Get the test outcome
		    $outcome = $results.UnitTestResult.outcome;
		    # Get the failure message
		    if ($outcome -ne "Passed") {
			    $message = $results.UnitTestResult.Output.ErrorInfo.Message;
		    }
        }
	    else {
		    # Get the test id
		    $testId = $results.UnitTestResult[$i].testId;
		    # Get the test name
		    $testName = $results.UnitTestResult[$i].testName;
		    # Get the test outcome
		    $outcome = $results.UnitTestResult[$i].outcome;
		    # Get the failure message
		    if ($outcome -ne "Passed") {
			    $message = $results.UnitTestResult[$i].Output.ErrorInfo.Message;
		    }
	    }
        # Get the unit test (from the test definitions)
        $unitTest = $definitions.UnitTest | Where-Object {$_.id -eq $testId} | Select-Object;
        # Get the class name of the unit test
        $className = $unitTest.TestMethod.className;
        # Remove the namespace of the unit test
        $className = $className.Substring($className.IndexOf("Tests.") + 6);
        # Create the test result object and add it to the test results object
        $testResult = New-Object PSObject;
        $testResult | Add-Member -NotePropertyName "Outcome" -NotePropertyValue $outcome;
        $testResult | Add-Member -NotePropertyName "Test Name" -NotePropertyValue $testName;
        $testResult | Add-Member -NotePropertyName "Test Class" -NotePropertyValue $className;
        $testResult | Add-Member -NotePropertyName "Error Message" -NotePropertyValue $message;
        $testResults += $testResult;
    }
    # Return the parsed result(s)
    return $testResults;
}

function Get-LastModified([String]$directory) {
    # Return the path of the last file modified
    return (Get-ChildItem -Path $directory -File | sort LastWriteTime | select -last 1).FullName;
}
