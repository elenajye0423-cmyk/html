$files = Get-ChildItem -Path ".\" -Include *.html,*.txt -Recurse
foreach ($file in $files) {
    # Using UTF8 explicitly
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # Replace without relying on Korean text
    $newContent = $content -replace '(?m)^\s*<li><a href="technical\.html">.*?</a></li>\s*\r?\n?', ''
    $newContent = $newContent -replace '(?m)^\s*<a href="technical\.html" class="sub-nav-link[^"]*">.*?</a>\s*\r?\n?', ''
    
    if ($content -cne $newContent) {
        [IO.File]::WriteAllText($file.FullName, $newContent, (New-Object System.Text.UTF8Encoding $False))
        Write-Host "Updated $($file.Name)"
    }
}
