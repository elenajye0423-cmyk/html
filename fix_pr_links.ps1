$utf8 = New-Object System.Text.UTF8Encoding $false
$files = Get-ChildItem -Filter *.html

foreach ($f in $files) {
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)
    
    # Fix GNB and Footer links
    $text = $text.Replace('href="video.html#video"', 'href="video.html"')
    $text = $text.Replace('href="video.html#brochure"', 'href="brochure.html"')
    $text = $text.Replace('href="video.html#cardnews"', 'href="cardnews.html"')
    
    [IO.File]::WriteAllText($f.FullName, $text, $utf8)
}

