$utf8 = New-Object System.Text.UTF8Encoding $false

$calSrc = [IO.File]::ReadAllText("portal_calendar.html", $utf8)

$calSrc = $calSrc -replace 'document\.getElementById\("add-sched-pwd"\)\.value = "";\s*', ''
$calSrc = $calSrc -replace 'document\.getElementById\("edit-sched-pwd"\)\.value = "";\s*', ''

[IO.File]::WriteAllText("portal_calendar.html", $calSrc, $utf8)

