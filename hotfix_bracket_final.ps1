$utf8 = New-Object System.Text.UTF8Encoding $false
$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

# Find the end of the if statement and add the closing bracket for the function
$archiveSrc = $archiveSrc -replace '(?s)localStorage\.setItem\("batech_archive_v3", JSON\.stringify\(defaults\)\);\s*\}\s*function renderArchiveList\(\) \{', "localStorage.setItem(`"batech_archive_v3`", JSON.stringify(defaults));`r`n            }`r`n        }`r`n`r`n        function renderArchiveList() {"

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

