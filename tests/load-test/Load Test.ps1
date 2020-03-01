# Set the number of threads we want to run concurrently
$threads = 5
# The script block is the code to be executed by each thread. Threads do not share data so if a library needs to be imported, then each thread needs to do so.
$ScriptBlock = {
    # Parameter - https://technet.microsoft.com/en-us/magazine/jj554301.aspx
    Param ( [int]$RunNumber )
    # Get the current working directory
    $pwd = pwd
    # Import the .Net Http Dynamic Link Library
    Add-Type -Path "$pwd\System.Net.Http.dll"
    # Instantiate a new http client, using the imported library
    $client = New-Object -TypeName System.Net.Http.Httpclient
    # Define the path to the CSV file that holds all the URLs to be tested
    $pathToCsv = "$pwd\URLs.csv"
    # Import the CSV (defined above)
    $csv = Import-csv -path $pathToCsv
    # Create an array to hold iteration results
    $threadResults = @()
    # For Loop to run through each row of data in the CSV
    foreach($line in $csv) {
        $startTime = Get-Date
        $email = ""
        $statusCode = ""
        # If the request is a POST, then we need to set a unique email address
        if ($line.Method -eq "POST")  {
            $mfdc = New-Object -TypeName System.Net.Http.MultipartFormDataContent
            $pathToFormDataCsv = "$pwd\Form-Data.csv"
            $formData = Import-csv -path $pathToFormDataCsv
            foreach ($row in $formData)
            {
                $key = $row.Key
                $value = New-Object -TypeName System.Net.Http.StringContent $row.Value
                if ($key -eq "email") {
                    $email = "tim+$RunNumber{0:G}@spiredigital.com" -f [int][double]::Parse((Get-Date -UFormat %s))
                    $value = New-Object -TypeName System.Net.Http.StringContent $email
                }
                $mfdc.Add($value, $key)
            }
            $response = $client.PostAsync($line.URL, $mfdc).Result
            # Get the status code
            $statusCode = $response.StatusCode
        }
        # Otherwise, just make the request
        else {
            $request = New-Object -TypeName System.Net.Http.HttpRequestMessage
            $request.RequestUri = $line.URL
            $request.Method = $line.Method
            $response = $client.SendAsync($request).Result
            # Get the status code
            $statusCode = $response.StatusCode
        }
        $endTime = Get-Date
        $runTime = New-TimeSpan -Start $startTime -End $endTime
        # Save the test data to a PowerShell object
        $iterationResult = New-Object PSObject
        $iterationResult | Add-Member -NotePropertyName "Thread" -NotePropertyValue $RunNumber
        $iterationResult | Add-Member -NotePropertyName "StatusCode" -NotePropertyValue $statusCode
        $iterationResult | Add-Member -NotePropertyName "URL" -NotePropertyValue $line.URL
        $iterationResult | Add-Member -NotePropertyName "Time" -NotePropertyValue $runTime
        # Add the new object to the test result
        $threadResults += $iterationResult
    }
    # Return the results array for this thread
    Return $threadResults
}
# Create a pool of powershell instances
$RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, $threads)
$RunspacePool.Open()
# Create an Jobs array and invoke each job as they are added to the array
$Jobs = @()
1..$threads | % {
    $Job = [powershell]::Create().AddScript($ScriptBlock).AddArgument($_)
    $Job.RunspacePool = $RunspacePool
    $Jobs += New-Object PSObject -Property @{
        RunNum = $_
        Pipe = $Job
        Result = $Job.BeginInvoke()
    }
}
# Clear screen
cls
# Write a status message to the console, until all jobs finish
Write-Host "Working.." -NoNewline
Do {
    Write-Host "." -NoNewline
    Start-Sleep -Seconds 1
} While ( $Jobs.Result.IsCompleted -contains $false)
Write-Host "All jobs completed!"
# Package all threads results into one object
$Results = @()
ForEach ($Job in $Jobs) {   
    $Results += $Job.Pipe.EndInvoke($Job.Result)
}
# Display the results in a table
$Results | Out-GridView