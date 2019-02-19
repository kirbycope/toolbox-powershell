# toolbox-powershell
A collection of PowerShell scripts

## Hello World!
 > The Write-Host cmdlet enables you to write messages to the Windows PowerShell console.
 <br>http://technet.microsoft.com/en-us/library/ee177031.aspx
 
1. Open PowerShell ISE
2. Click 'File' and then click 'New'
3. Type `Write-Host "Hello World!"`
4. Execute the script by pressing [F5]

> Hello World!

## Variables
 > When you write a script, particularly a system administration script, you rarely get to hard-code in all your values ahead of time; instead, you typically need to retrieve information, store that information in a variable or two, and then display the values of those variable.
<br>http://technet.microsoft.com/en-us/library/ee692790.aspx

PowerShell is influenced by Unix shells and Perl so variables are prefixed with a $sigil.

````powershell
$message = 'Hello World!'
Write-Host $message
````
> Hello World!

## Functions
 > A function is a list of Windows PowerShell statements that has a name that you assign. When you run a function, you type the function name. The statements in the list run as if you had typed them at the command prompt.
<br>http://technet.microsoft.com/en-us/library/hh847829.aspx

 > Windows PowerShell uses a verb-noun pair for the names of cmdlets and for their derived Microsoft .NET Framework classes. For example, the Get-Command cmdlet provided by Windows PowerShell is used to retrieve all the commands that are registered in Windows PowerShell. The verb part of the name identifies the action that the cmdlet performs. The noun part of the name identifies the entity on which the action is performed.
<br>http://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx

````powershell
$message = "Hello World!"
function Write-Message()
{
    Write-Host $message
}
# Call the function
Write-Message
````
 > "Hello World!"
 
## Passing Variables to Functions
Previously, `$message` was accessible because its scope was Global. You can pass variables and values to functions by appending those values to the function call. Also, your function must expect a value. In this example, we pass a string into the function that we declare as `$message`.

````powershell
function Write-Message([string]$message)
{
    Write-Host $message
}
# Call the function
Write-Message "Hello World!"
````
> Hello World!

## Error Handling
> Use Try, Catch, and Finally blocks to respond to or handle terminating errors in scripts. The Trap statement can also be used to handle terminating errors in scripts. For more information, see about_Trap.
<br>http://technet.microsoft.com/en-us/library/hh847793.aspx
````powershell
function Write-Message([string]$message)
{
    Write-Host $message
}
 
try
{
    # Call the function
    Write-Message "Hello World!"
}
catch [Exception]
{
    # Write exception to host
    Write-Host ("==> Caught Exception: {0}" -f $_.Exception.Message)
}
finally
{
    # Pause the script so that the result can be viewed before the console closes
    Pause
}
````
> Hello World!
