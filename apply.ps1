$utf8 = New-Object System.Text.UTF8Encoding $false
$main_nav = [IO.File]::ReadAllText("main_nav.txt", $utf8)
$sub_nav_template = [IO.File]::ReadAllText("sub_nav.txt", $utf8)

$files = Get-ChildItem -Filter *.html

foreach ($f in $files) {
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)
    
    $pattern = '(?s)<li class="nav-item">\s*<a href="intro\.html">.*?<a href="rd\.html">.*?</ul>\s*</li>'
    $text = [regex]::Replace($text, $pattern, $main_nav)

    $subNavFiles = @("intro.html", "sales_history.html", "organization.html", "certifications.html", "facilities.html", "portfolio.html", "map.html")
    if ($subNavFiles -contains $f.Name) {
        $subReplacement = $sub_nav_template
        $a_intro = if ($f.Name -eq "intro.html") { " active" } else { "" }
        $a_sales = if ($f.Name -eq "sales_history.html") { " active" } else { "" }
        $a_org = if ($f.Name -eq "organization.html") { " active" } else { "" }
        $a_cert = if ($f.Name -eq "certifications.html") { " active" } else { "" }
        $a_fac = if ($f.Name -eq "facilities.html") { " active" } else { "" }
        $a_port = if ($f.Name -eq "portfolio.html") { " active" } else { "" }
        $a_map = if ($f.Name -eq "map.html") { " active" } else { "" }

        $subReplacement = $subReplacement.Replace("{active_intro}", $a_intro)
        $subReplacement = $subReplacement.Replace("{active_sales}", $a_sales)
        $subReplacement = $subReplacement.Replace("{active_org}", $a_org)
        $subReplacement = $subReplacement.Replace("{active_cert}", $a_cert)
        $subReplacement = $subReplacement.Replace("{active_fac}", $a_fac)
        $subReplacement = $subReplacement.Replace("{active_port}", $a_port)
        $subReplacement = $subReplacement.Replace("{active_map}", $a_map)

        $text = [regex]::Replace($text, '(?s)<nav class="sub-nav">.*?</nav>', $subReplacement)
    }

    [IO.File]::WriteAllText($f.FullName, $text, $utf8)
}
