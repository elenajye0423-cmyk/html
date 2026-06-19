$utf8 = New-Object System.Text.UTF8Encoding $false
$main_nav = [IO.File]::ReadAllText("main_nav.txt", $utf8)
$sub_intro = [IO.File]::ReadAllText("sub_nav_intro.txt", $utf8)
$sub_cap = [IO.File]::ReadAllText("sub_nav_cap.txt", $utf8)

$files = Get-ChildItem -Filter *.html

foreach ($f in $files) {
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)
    
    $pattern = '(?s)<li class="nav-item">\s*<a href="intro\.html">기업소개</a>.*?</ul>\s*</li>'
    $text = [regex]::Replace($text, $pattern, $main_nav)

    $introFiles = @("intro.html", "sales_history.html", "organization.html", "map.html")
    $capFiles = @("portfolio.html", "certifications.html", "facilities.html")

    if ($introFiles -contains $f.Name) {
        $sub = $sub_intro
        $a_intro = if ($f.Name -eq "intro.html") { " active" } else { "" }
        $a_sales = if ($f.Name -eq "sales_history.html") { " active" } else { "" }
        $a_org = if ($f.Name -eq "organization.html") { " active" } else { "" }
        $a_map = if ($f.Name -eq "map.html") { " active" } else { "" }

        $sub = $sub.Replace("{active_intro}", $a_intro)
        $sub = $sub.Replace("{active_sales}", $a_sales)
        $sub = $sub.Replace("{active_org}", $a_org)
        $sub = $sub.Replace("{active_map}", $a_map)

        $text = [regex]::Replace($text, '(?s)<nav class="sub-nav">.*?</nav>', $sub)
    } elseif ($capFiles -contains $f.Name) {
        $sub = $sub_cap
        $a_port = if ($f.Name -eq "portfolio.html") { " active" } else { "" }
        $a_cert = if ($f.Name -eq "certifications.html") { " active" } else { "" }
        $a_fac = if ($f.Name -eq "facilities.html") { " active" } else { "" }

        $sub = $sub.Replace("{active_port}", $a_port)
        $sub = $sub.Replace("{active_cert}", $a_cert)
        $sub = $sub.Replace("{active_fac}", $a_fac)

        $text = [regex]::Replace($text, '(?s)<nav class="sub-nav">.*?</nav>', $sub)
    }

    [IO.File]::WriteAllText($f.FullName, $text, $utf8)
}
