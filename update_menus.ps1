$files = Get-ChildItem -Filter *.html
$utf8 = New-Object System.Text.UTF8Encoding $false

foreach ($f in $files) {
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)
    
    # 1. Main Nav Replace
    $pattern = '(?s)<li class="nav-item">\s*<a href="intro\.html">기업소개</a>\s*<ul class="dropdown">\s*<li><a href="intro\.html">기업개요</a></li>\s*<li><a href="sales_history\.html">연혁</a></li>\s*<li><a href="organization\.html">조직도 및 업무분장</a></li>\s*<li><a href="portfolio\.html">주요 실적</a></li>\s*<li><a href="map\.html">찾아오시는 길</a></li>\s*</ul>\s*</li>\s*<li class="nav-item">\s*<a href="rd\.html">기술 및 인프라</a>\s*<ul class="dropdown">\s*<li><a href="certifications\.html">인증현황</a></li>\s*<li><a href="facilities\.html">주요시설</a></li>\s*</ul>\s*</li>'
    
    $replacement = '            <li class="nav-item">
                <a href="intro.html">기업소개</a>
                <ul class="dropdown">
                    <li><a href="intro.html">기업개요</a></li>
                    <li><a href="sales_history.html">연혁</a></li>
                    <li><a href="organization.html">조직도 및 업무분장</a></li>
                    <li><a href="certifications.html">인증현황</a></li>
                    <li><a href="facilities.html">주요시설</a></li>
                    <li><a href="portfolio.html">주요 실적</a></li>
                    <li><a href="map.html">찾아오시는 길</a></li>
                </ul>
            </li>'
            
    $text = [regex]::Replace($text, $pattern, $replacement)

    # 2. Sub-nav Replace (only if the file is one of the 7)
    $subNavFiles = @("intro.html", "sales_history.html", "organization.html", "certifications.html", "facilities.html", "portfolio.html", "map.html")
    if ($subNavFiles -contains $f.Name) {
        $active_intro = if ($f.Name -eq "intro.html") { " active" } else { "" }
        $active_sales = if ($f.Name -eq "sales_history.html") { " active" } else { "" }
        $active_org = if ($f.Name -eq "organization.html") { " active" } else { "" }
        $active_cert = if ($f.Name -eq "certifications.html") { " active" } else { "" }
        $active_fac = if ($f.Name -eq "facilities.html") { " active" } else { "" }
        $active_port = if ($f.Name -eq "portfolio.html") { " active" } else { "" }
        $active_map = if ($f.Name -eq "map.html") { " active" } else { "" }

        $subReplacement = "<nav class=`"sub-nav`">`r`n    <div class=`"sub-nav-container`">`r`n        <a href=`"intro.html`" class=`"sub-nav-link$active_intro`">기업개요</a>`r`n        <a href=`"sales_history.html`" class=`"sub-nav-link$active_sales`">연혁</a>`r`n        <a href=`"organization.html`" class=`"sub-nav-link$active_org`">조직도 및 업무분장</a>`r`n        <a href=`"certifications.html`" class=`"sub-nav-link$active_cert`">인증현황</a>`r`n        <a href=`"facilities.html`" class=`"sub-nav-link$active_fac`">주요시설</a>`r`n        <a href=`"portfolio.html`" class=`"sub-nav-link$active_port`">주요 실적</a>`r`n        <a href=`"map.html`" class=`"sub-nav-link$active_map`">찾아오시는 길</a>`r`n    </div>`r`n</nav>"

        $text = [regex]::Replace($text, '(?s)<nav class="sub-nav">.*?</nav>', $subReplacement)
    }

    [IO.File]::WriteAllText($f.FullName, $text, $utf8)
}
