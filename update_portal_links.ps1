$utf8 = New-Object System.Text.UTF8Encoding $false
$files = Get-ChildItem -Filter *.html

foreach ($f in $files) {
    if ($f.Name -eq "portal_notice.html" -or $f.Name -eq "portal_forms.html") {
        continue
    }
    
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)
    
    # 1. Remove from GNB
    $text = $text -replace '(?s)\s*<li class="nav-item">\s*<a href="portal_notice\.html">사내 포털</a>\s*<ul class="dropdown">\s*<li><a href="portal_notice\.html">사내 공지사항</a></li>\s*<li><a href="portal_forms\.html">서식 \(템플릿 및 자료실\)</a></li>\s*</ul>\s*</li>', ''
    
    # 2. Add to Footer Quick Links (append after map.html)
    $text = $text -replace '<li><a href="map\.html">오시는 길</a></li>', '<li><a href="map.html">오시는 길</a></li>
                    <li><a href="portal.html" style="color: var(--primary-light);">🔒 사내 포털</a></li>'
    
    [IO.File]::WriteAllText($f.FullName, $text, $utf8)
}

# Delete the old files
if (Test-Path "portal_notice.html") { Remove-Item "portal_notice.html" }
if (Test-Path "portal_forms.html") { Remove-Item "portal_forms.html" }

