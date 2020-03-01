function Send-Email([Object[]] $emailToArray, [string] $subject, [string] $body)
{
    $mailMessage = New-Object Net.Mail.MailMessage;
    $mailMessage.From = "no-reply@example.com"
    foreach($emailAddress in $emailToArray)
    {
        $mailMessage.To.Add($emailAddress)
    }
    $mailMessage.Subject = $subject
    $mailMessage.Body = $body
    if ($body.Contains("<html>"))
    {
        $mailMessage.IsBodyHtml = $true
    }
    $smtp = new-object Net.Mail.SmtpClient("smtp.example.corp.root");
    $smtp.send($mailMessage);
}
