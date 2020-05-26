# Allow the current user to run this script
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned;

# Set the source here
[string]$source = "foo";

# Set the shift value here (positive to cipher, negative to decipher)
[Int16]$shift = 0;

# Function: Cipher/Decipher the given source using the given shift value.
function Cipher-String([string]$source, [Int16]$shift)
{
    $maxChar = [Convert]::ToInt32($char.MaxValue);
    $minChar = [Convert]::ToInt32($char.MinValue);
    $buffer = $source.ToCharArray();
    for ($i = 0; $i -lt $buffer.Length; $i++)
    {
        $shifted = [convert]::ToInt32($buffer[$i]) + $shift;
        if ($shifted -gt $maxChar)
        {
            $shifted -= $maxChar;
        }
        elseif ($shifted -lt $minChar)
        {
            $shifted += $maxChar;
        }
        $buffer[$i] = [convert]::ToChar($shifted);
    }
    return $buffer -join ""
}

# Encrypt the string
$caesar = Cipher-String $source $shift;

#Write result to host
Write-Host "Caesar Value: $caesar";
