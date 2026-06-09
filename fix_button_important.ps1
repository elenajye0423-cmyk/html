$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("inquiry.html", $utf8)
$old = 'style="background: white; color: #000000; border: 2px solid #000000; font-weight: bold; padding: 10px 20px;"'
$new = 'style="background: white !important; color: #000000 !important; border: 2px solid #000000 !important; font-weight: bold !important; padding: 10px 20px !important;"'
$src = $src.Replace($old, $new)
[IO.File]::WriteAllText("inquiry.html", $src, $utf8)
Write-Host "Patched button style with !important"

