$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("portal.html", $utf8)

$oldParams = 'const templateParams = {
            to_email: inq.email,
            subject: "Re: " + inq.subject,
            message: content
        };'

$newParams = 'const templateParams = {
            to_email: inq.email,
            email: inq.email,
            user_email: inq.email,
            reply_to: inq.email,
            recipient: inq.email,
            subject: "Re: " + inq.subject,
            message: content
        };'

$src = $src.Replace($oldParams, $newParams)
[IO.File]::WriteAllText("portal.html", $src, $utf8)
Write-Host "Patched portal.html EmailJS parameters"

