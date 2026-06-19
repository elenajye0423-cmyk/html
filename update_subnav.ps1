$files = "intro.html", "sales_history.html", "organization.html", "certifications.html", "facilities.html", "portfolio.html", "map.html"

foreach ($f in $files) {
    $path = Join-Path (Get-Location) $f
    $text = [IO.File]::ReadAllText($path)
    $active_intro = if ($f -eq "intro.html") { " active" } else { "" }
    $active_sales = if ($f -eq "sales_history.html") { " active" } else { "" }
    $active_org = if ($f -eq "organization.html") { " active" } else { "" }
    $active_cert = if ($f -eq "certifications.html") { " active" } else { "" }
    $active_fac = if ($f -eq "facilities.html") { " active" } else { "" }
    $active_port = if ($f -eq "portfolio.html") { " active" } else { "" }
    $active_map = if ($f -eq "map.html") { " active" } else { "" }

    $replacement = "<nav class=`"sub-nav`">`r`n    <div class=`"sub-nav-container`">`r`n        <a href=`"intro.html`" class=`"sub-nav-link$active_intro`">기업개요</a>`r`n        <a href=`"sales_history.html`" class=`"sub-nav-link$active_sales`">연혁</a>`r`n        <a href=`"organization.html`" class=`"sub-nav-link$active_org`">조직도 및 업무분장</a>`r`n        <a href=`"certifications.html`" class=`"sub-nav-link$active_cert`">인증현황</a>`r`n        <a href=`"facilities.html`" class=`"sub-nav-link$active_fac`">주요시설</a>`r`n        <a href=`"portfolio.html`" class=`"sub-nav-link$active_port`">주요 실적</a>`r`n        <a href=`"map.html`" class=`"sub-nav-link$active_map`">찾아오시는 길</a>`r`n    </div>`r`n</nav>"

    $text = [regex]::Replace($text, '(?s)<nav class="sub-nav">.*?</nav>', $replacement)
    [IO.File]::WriteAllText($path, $text)
}
