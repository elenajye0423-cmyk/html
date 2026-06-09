$utf8 = New-Object System.Text.UTF8Encoding $false
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)

$oldStr = @"
                    " + (inq.subject || "").replace(/"/g, '""') + ",
                    " + (inq.message || "").replace(/"/g, '""') + "
"@

$newStr = @"
                    '"' + (inq.subject || "").replace(/"/g, '""') + '"',
                    '"' + (inq.message || "").replace(/"/g, '""') + '"'
"@

$portalSrc = $portalSrc.Replace($oldStr, $newStr)

[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)

