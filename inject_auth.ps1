$utf8 = New-Object System.Text.UTF8Encoding $false
$lines = [IO.File]::ReadAllLines("portal.html", $utf8)
$snippet = [IO.File]::ReadAllText("snippet_portal_auth.html", $utf8)

$newLines = New-Object System.Collections.Generic.List[string]

foreach ($line in $lines) {
    $newLines.Add($line)
    if ($line.Trim() -eq "<body>") {
        $newLines.Add($snippet)
    }
}

[IO.File]::WriteAllLines("portal.html", $newLines.ToArray(), $utf8)
Write-Host "Injected auth overlay successfully!"

