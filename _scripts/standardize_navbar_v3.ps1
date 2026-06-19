$navbarHtml = Get-Content -Path "navbar.txt" -Raw -Encoding UTF8

$htmlFiles = Get-ChildItem -Filter *.html

foreach ($file in $htmlFiles) {
    # Read the file as UTF-8
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Replace the navbar section
    $newContent = $content -replace '(?s)<nav id="navbar">.*?</nav>', $navbarHtml
    
    # Write back as UTF8 (Powershell 5.1 adds BOM, but browsers handle it fine. To prevent BOM, we can use out-file or [System.IO.File]::WriteAllText)
    [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
    
    Write-Host "Updated $($file.Name)"
}
Write-Host "All files updated with correct encoding."
