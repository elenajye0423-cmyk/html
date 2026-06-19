$utf8 = New-Object System.Text.UTF8Encoding $false
$main_nav = [IO.File]::ReadAllText("main_nav.txt", $utf8)
$sub_intro = [IO.File]::ReadAllText("sub_nav_intro.txt", $utf8)
$sub_cap = [IO.File]::ReadAllText("sub_nav_cap.txt", $utf8)

$files = Get-ChildItem -Filter *.html

foreach ($f in $files) {
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)
    
    $startToken = '<a href="intro.html">기업소개</a>'
    $idxStart = $text.IndexOf($startToken)
    if ($idxStart -gt 0) {
        $liStart = $text.LastIndexOf('<li class="nav-item">', $idxStart)
        $ulEnd = $text.IndexOf('</ul>', $idxStart)
        $liEnd = $text.IndexOf('</li>', $ulEnd) + 5
        
        if ($liStart -ge 0 -and $liEnd -gt $liStart) {
            $oldBlock = $text.Substring($liStart, $liEnd - $liStart)
            $text = $text.Replace($oldBlock, $main_nav)
        }
    }

    $introFiles = @("intro.html", "sales_history.html", "organization.html", "map.html")
    $capFiles = @("portfolio.html", "certifications.html", "facilities.html")
    
    $navStartToken = '<nav class="sub-nav">'
    $navIdxStart = $text.IndexOf($navStartToken)
    if ($navIdxStart -ge 0) {
        $navIdxEnd = $text.IndexOf('</nav>', $navIdxStart) + 6
        $oldNavBlock = $text.Substring($navIdxStart, $navIdxEnd - $navIdxStart)
        
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

            $text = $text.Replace($oldNavBlock, $sub)
        } elseif ($capFiles -contains $f.Name) {
            $sub = $sub_cap
            $a_port = if ($f.Name -eq "portfolio.html") { " active" } else { "" }
            $a_cert = if ($f.Name -eq "certifications.html") { " active" } else { "" }
            $a_fac = if ($f.Name -eq "facilities.html") { " active" } else { "" }

            $sub = $sub.Replace("{active_port}", $a_port)
            $sub = $sub.Replace("{active_cert}", $a_cert)
            $sub = $sub.Replace("{active_fac}", $a_fac)

            $text = $text.Replace($oldNavBlock, $sub)
        }
    }

    [IO.File]::WriteAllText($f.FullName, $text, $utf8)
}

