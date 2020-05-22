function Parse-FeatureFiles([Object]$files) {
    # Define a variable to hold the test(s)
    $tests = @();
    # Loop over each file found
    for ($i = 0; $i -lt $files.Count; $i++) {
        # Get the name of the file
        $feature = $files[$i].Name.Replace(".feature", "");
        # Get the content of the file
        $content = Get-Content $files[$i].FullName;
        # Loop over each line of the file
        for ($j = 0; $j -lt $content.Count; $j++) {
            # PROPERTIES
            $scenario = "";
            $given = "";
            $and = "";
            $when = "";
            $then = "";
            $sceanrioOutline = $false;
            $examples = "";
            # Check if the current line contains "Scenario" (but is not a comment)
            if (($content[$j] -like "*Scenario*") -And ($content[$j] -notlike "*#*")) {
                # Check if a Scenario Outline
                if ($content[$j] -like "*Outline*") {
                    $sceanrioOutline = $true;
                    $scenario = $content[$j].Replace("Scenario Outline: ", "").Trim();
                }
                else {
                    $scenario = $content[$j].Replace("Scenario: ", "").Trim();
                }
                $maxIndex = 1;
                # Find the next empty line
                for ($k = 1; $k -lt 10; $k++) {
                    if ($content[$j+$k].Length -eq 0) { 
                        $maxIndex = $k;
                        break;
                    }
                }
                # Check the subsequent lines for the test steps
                for ($k = 1; $k -lt 5; $k++) {
                    if ($content[$j+$k] -like "*Given*") {
                        $given = $content[$j+$k].Replace("Given ", "").Trim();
                    }
                    elseif ($content[$j+$k] -like "*And*") {
                        $and = $content[$j+$k].Replace("And ", "").Trim();
                    }
                    elseif ($content[$j+$k] -like "*When*") {
                        $when = $content[$j+$k].Replace("When ", "").Trim();
                    }
                    elseif ($content[$j+$k] -like "*Then*") {
                        $then = $content[$j+$k].Replace("Then ", "").Trim();
                    }
                }
                # Check the subsequent lines for examples
                if ($sceanrioOutline -eq $true) {
                    if ($content[$j+$k] -like "*Examples*") {
                        $maxIndex = 2;
                        # Find the next empty line
                        for ($l = 2; $l -lt 10; $l++) {
                            if ($content[$j+$k+$l].Length -eq 0) { 
                                $maxIndex = $l;
                                break;
                            }
                        }
                        # Examples
                        $examples = $content[$j+$k+1].Trim() + "`r`n";
                        for ($l = 2; $l -lt $maxIndex; $l++) {
                            $examples = $examples + $content[$j+$k+$l].Trim() + "`r`n";
                        }
                    }
                }
            }
            # Add test if found
            if ($scenario.Length -gt 0) {
                $test = New-Object PSObject;
                $test | Add-Member -NotePropertyName "Feature" -NotePropertyValue $feature;
                $test | Add-Member -NotePropertyName "Scenario" -NotePropertyValue $scenario;
                $test | Add-Member -NotePropertyName "Given" -NotePropertyValue $given;
                $test | Add-Member -NotePropertyName "And" -NotePropertyValue $and;
                $test | Add-Member -NotePropertyName "When" -NotePropertyValue $when;
                $test | Add-Member -NotePropertyName "Then" -NotePropertyValue $then;
                $test | Add-Member -NotePropertyName "Examples" -NotePropertyValue $examples;
                $tests += $test;
            }
        }
    }
    # Return the parsed test(s)
    return $tests;
}

# Define the test directory
$testDirectory = "...\__tests__\functional\features";

# Get all .cs files in the Test directory
$files = Get-ChildItem -Path $testDirectory -Recurse -Include *.feature;

# Parse the .feature files
$tests = Parse-FeatureFiles $files;

# Save the tests to a CSV file
$tests | Export-Csv -Path "$testDirectory\automated-test-cases.csv" -NoTypeInformation -Force;

# Open the file
Invoke-Item "$testDirectory\automated-test-cases.csv";
