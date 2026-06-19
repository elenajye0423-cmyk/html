$utf8 = New-Object System.Text.UTF8Encoding $false
$files = Get-ChildItem -Filter *.html

foreach ($f in $files) {
    if ($f.Name -eq "careers.html" -or $f.Name -eq "job_openings.html") {
        continue
    }
    
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)
    
    # Remove entire GNB careers menu block
    $text = $text -replace '(?s)\s*<li class="nav-item">\s*<a href="careers\.html">채용</a>\s*<ul class="dropdown">\s*<li><a href="careers\.html">인재상</a></li>\s*<li><a href="job_openings\.html">채용공고</a></li>\s*</ul>\s*</li>', ''
    
    # Remove from Footer
    $text = $text -replace '(?m)^\s*<li><a href="careers\.html">채용</a></li>\r?\n?', ''
    $text = $text -replace '(?m)^\s*<li><a href="job_openings\.html">채용공고</a></li>\r?\n?', ''
    
    [IO.File]::WriteAllText($f.FullName, $text, $utf8)
}

# Delete the files
if (Test-Path "careers.html") { Remove-Item "careers.html" }
if (Test-Path "job_openings.html") { Remove-Item "job_openings.html" }

