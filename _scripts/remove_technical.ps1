$files = Get-ChildItem -Path ".\" -Include *.html,*.txt -Recurse
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $newContent = $content -replace '(?m)^\s*<li><a href="technical\.html">기술자료실</a></li>\s*\r?\n?', ''
    $newContent = $newContent -replace '(?m)^\s*<a href="technical\.html" class="sub-nav-link[^"]*">기술자료실</a>\s*\r?\n?', ''
    if ($content -cne $newContent) {
        [IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
        Write-Host "Updated $($file.Name)"
    }
}
