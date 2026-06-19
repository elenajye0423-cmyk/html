$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("inquiry.html", $utf8)

# Force bulletproof styling for the '조회' button
$oldBtn = 'class="btn-primary" style="padding: 12px 20px;">조회</button>'
$newBtn = 'style="background: #2563eb; color: #ffffff; border: none; border-radius: 8px; padding: 12px 20px; font-weight: bold; cursor: pointer;">조회</button>'
$src = $src.Replace($oldBtn, $newBtn)

[IO.File]::WriteAllText("inquiry.html", $src, $utf8)

