$Username = "";
$Password = "";
$path = "C:\temp\attach.txt";

function Send-ToEmail([string]$email, [string]$attachmentpath){

    $message = new-object Net.Mail.MailMessage;
    $message.From = "dalmus@gmail.com";
    $message.To.Add($email);
    $message.Subject = "Testign smtp";
    $message.Body = "This will be a message";
    #$attachment = New-Object Net.Mail.Attachment($attachmentpath);
    #$message.Attachments.Add($attachment);

    $smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
    write-host "Mail Sent" ; 
    $attachment.Dispose();
 }
Send-ToEmail  -email "manuel.monge@l-p-a.com" -attachmentpath $path;