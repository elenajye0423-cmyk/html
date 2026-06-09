$utf8 = New-Object System.Text.UTF8Encoding $false
$lines = [IO.File]::ReadAllLines("inquiry.html", $utf8)

$btnSnippet = [IO.File]::ReadAllText("snippet_btn.html", $utf8)
$scriptSnippet = [IO.File]::ReadAllText("snippet_inquiry_scripts.html", $utf8)

$newLines = New-Object System.Collections.Generic.List[string]

# Keep lines 0 to 69 (inclusive)
for ($i = 0; $i -lt 70; $i++) {
    $newLines.Add($lines[$i])
}

# Insert button snippet
$newLines.Add($btnSnippet)

# Keep lines 73 to 199 (inclusive)
for ($i = 73; $i -lt 200; $i++) {
    $newLines.Add($lines[$i])
}

# Insert the entire script block and modal to the end
$newLines.Add($scriptSnippet)

[IO.File]::WriteAllLines("inquiry.html", $newLines.ToArray(), $utf8)
Write-Host "Rebuilt inquiry.html successfully!"

