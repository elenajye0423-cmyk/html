$utf8 = New-Object System.Text.UTF8Encoding $false
$lines = [IO.File]::ReadAllLines("portal.html", $utf8)
$snippet = [IO.File]::ReadAllText("snippet_portal.js", $utf8)

$newLines = New-Object System.Collections.Generic.List[string]

# Add lines before the script content (inclusive of <script> at index 161)
for ($i = 0; $i -le 161; $i++) {
    $newLines.Add($lines[$i])
}

# Add the pristine snippet content
$newLines.Add($snippet)

# Add lines after the script content (inclusive of </script> at index 537)
for ($i = 537; $i -lt $lines.Length; $i++) {
    $newLines.Add($lines[$i])
}

# Write back as UTF8 string array
[IO.File]::WriteAllLines("portal.html", $newLines.ToArray(), $utf8)
Write-Host "Replaced script via exact line indices."

