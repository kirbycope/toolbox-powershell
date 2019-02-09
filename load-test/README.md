# Load Testing Using PowerShell

## Understanding the Basics
A virtual user will make a series of URL requests, often with wait times (called “Think Time”) peppered in to simulate an actual users interaction with the server). We will use the HttpClient for the virtual user’s session as it is [thread safe](http://stackoverflow.com/questions/11178220/is-httpclient-safe-to-use-concurrently). It needs to be thread safe because we will use PowerShell [RunSpaces](https://msdn.microsoft.com/en-us/library/system.management.automation.runspaces.runspace(v=vs.85).aspx) and [Jobs](https://technet.microsoft.com/en-us/library/dd878288(v=vs.85).aspx) to spin up concurrent users. The calculator for finding the number of concurrent users can be found at [webperfomance.com](http://www.webperformance.com/library/tutorials/CalculateNumberOfLoadtestUsers/). Note that the number of concurrent users you can actually use is limited by the hardware the script is executing on as we are spinning up multiple instances of PowerShell.

## Multi-Threading  PowerShell
The code for multi-threading comes from [TheSurleyAdmin.com](http://thesurlyadmin.com/2013/02/11/multithreading-powershell-scripts/). The code works like this: Each thread is started up and given the task within the `$ScriptBlock`. Once the jobs are all done, the results are spit out into a [GridView](https://technet.microsoft.com/en-us/library/ff730930.aspx?f=255&MSPPError=-2147217396).
````powershell
# http://thesurlyadmin.com/2013/02/11/multithreading-powershell-scripts/
cls
 
$Throttle = 5
$ScriptBlock = {
    Param (
        [int]$RunNumber
    )
    $RanNumber = Get-Random -Minimum 1 -Maximum 10
    Start-Sleep -Seconds $RanNumber
    $RunResult = New-Object PSObject -Property @{
        RunNumber = $RunNumber
        Sleep = $RanNumber
    }
    Return $RunResult
}
 
$RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, $Throttle)
$RunspacePool.Open()
$Jobs = @()
 
1..20 | % {
    $Job = ::Create().AddScript($ScriptBlock).AddArgument($_)
    $Job.RunspacePool = $RunspacePool
    $Jobs += New-Object PSObject -Property @{
        RunNum = $_
        Pipe = $Job
        Result = $Job.BeginInvoke()
    }
}
 
Write-Host "Waiting.." -NoNewline
Do {
    Write-Host "." -NoNewline
    Start-Sleep -Seconds 1
} While ( $Jobs.Result.IsCompleted -contains $false)
Write-Host "All jobs completed!"
 
$Results = @()
ForEach ($Job in $Jobs)
{   
    $Results += $Job.Pipe.EndInvoke($Job.Result)
}
 
$Results | Out-GridView
````

## Adding in the HttpClient
Now that we have our base, we’ll need to modify it to suit our needs. The first thing we’ll need to add is the HttpClient. Because we are firing up multiple instances of PowerShell, the import will need to happen in the `$ScriptBlock`.
````powershell
$ScriptBlock = {
    ...
    # Get the current working directory
    $pwd = pwd
    # Import the .Net Http Dynamic Link Library
    Add-Type -Path "$pwd\System.Net.Http.dll"
    # Instantiate a new http client, using the imported library
    $client = New-Object -TypeName System.Net.Http.Httpclient
    ...
}
````

## Driving the Test Using a Data-Bound CSV File
Instead of having a list of URLs in the script, I like to use a .csv file as the PowerShell cmdlet is amazingly simple to use. In this CSV I have just a few columns; ID, METHOD, and URL. Method was needed so that when a POST was encountered, I could create the body dynamically. More on that in a moment.
````
$ScriptBlock = {
    ...
    # Define the path to the CSV file that holds all the URLs to be tested
    $pathToCsv = "$pwd\URLs.csv"
    # Import the CSV (defined above)
    $csv = Import-csv -path $pathToCsv
    ...
}
````

## Handling POSTs
For my load test, the POSTs needed to have unique email addresses. For this I use one of my favorite tricks: the Gmail “+” trick and UnixTimeStamp. With Gmail you can add + to make a unique email address that routes back to the original. As an example, “tim+1@gmail.com” is actually “tim@gmail.com”. So after the “+” I just throw in a UnixTimeStamp. I found that this wasn’t unique enough so I also added the thread number to the string. Also, notice the use of `MultipartFormDataContent`. That is the bit that creates the form to be used as the POST’s body content.
````powershell
$ScriptBlock = {
    ...
    # For Loop to run through each row of data in the CSV
    foreach($line in $csv) {
        $startTime = Get-Date
        $email = ''
        $statusCode = ''
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
        ...
    }
}
````

## Handling Results
After each request, I log the time it took and add my test data to a [PowerShell Object](https://msdn.microsoft.com/en-us/library/system.management.automation.psobject%28v=vs.85%29.aspx) using `Add-Member` to add properties to the generic object. That object is returned as the result of the job. Then after all jobs are complete, the results are aggregated and spit out in a GridView (same as the original script from TheSurleyAdmin).
````powershell
$ScriptBlock = {
    ...
    # For Loop to run through each row of data in the CSV
    foreach($line in $csv) {
        ...
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
````
