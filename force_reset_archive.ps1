$utf8 = New-Object System.Text.UTF8Encoding $false

$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

$archiveSrc = $archiveSrc -replace 'batech_archive_v2', 'batech_archive_v3'

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

