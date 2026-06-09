$utf8 = New-Object System.Text.UTF8Encoding $false

# 1. Read sources
$idxLines = [IO.File]::ReadAllLines("index.html", $utf8)
$bodyLines = [IO.File]::ReadAllLines("create_inquiry_body.html", $utf8)
$scriptLines = [IO.File]::ReadAllLines("snippet_inquiry_scripts.html", $utf8)

$newLines = New-Object System.Collections.Generic.List[string]

# 2. Add header and nav from index.html (lines 0 to 63)
for ($i = 0; $i -lt 64; $i++) {
    if ($i -eq 6) {
        $newLines.Add("    <title>온라인 문의 | (주)비에이텍</title>")
    } else {
        $newLines.Add($idxLines[$i])
    }
}

# 3. Add inquiry body
foreach ($line in $bodyLines) {
    $newLines.Add($line)
}

# 4. Add footer from index.html (lines 136 to 185)
for ($i = 136; $i -lt 186; $i++) {
    $newLines.Add($idxLines[$i])
}

# 5. Add perfectly clean JS scripts and Modal
foreach ($line in $scriptLines) {
    $newLines.Add($line)
}

# 6. Write back to inquiry.html
[IO.File]::WriteAllLines("inquiry.html", $newLines.ToArray(), $utf8)

Write-Host "inquiry.html has been completely reconstructed with pristine UTF-8 encoding!"





