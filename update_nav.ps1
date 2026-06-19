$files = Get-ChildItem -Filter *.html
foreach ($f in $files) {
    $text = [IO.File]::ReadAllText($f.FullName)
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
            
    $text = $text -replace $pattern, $replacement
    [IO.File]::WriteAllText($f.FullName, $text)
}
