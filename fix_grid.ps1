$utf8 = New-Object System.Text.UTF8Encoding $false
$files = "product_supply.html", "product_drainage.html", "product_industrial.html"

foreach ($file in $files) {
    if (Test-Path $file) {
        $text = [IO.File]::ReadAllText($file, $utf8)
        $text = $text.Replace('style="margin-top: 40px; display: flex; flex-direction: column; gap: 60px;"', 'style="margin-top: 40px;"')
        [IO.File]::WriteAllText($file, $text, $utf8)
    }
}

