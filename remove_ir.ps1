$utf8 = New-Object System.Text.UTF8Encoding $false
$files = Get-ChildItem -Filter *.html

foreach ($f in $files) {
    if ($f.Name -eq "ir.html") {
        continue
    }
    
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)
    
    # Remove from GNB and Footer (which uses <li>)
    $text = $text -replace '(?m)^\s*<li><a href="ir.html">IR 자료실</a></li>\r?\n?', ''
    
    # Remove from sub-nav (which uses <a> directly)
    $text = $text -replace '(?m)^\s*<a href="ir.html" class="sub-nav-link.*?">IR 자료실</a>\r?\n?', ''
    
    [IO.File]::WriteAllText($f.FullName, $text, $utf8)
}

# Delete the file itself
if (Test-Path "ir.html") {
    Remove-Item "ir.html"
}

