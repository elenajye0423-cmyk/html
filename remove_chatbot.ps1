$utf8 = New-Object System.Text.UTF8Encoding $false
$files = Get-ChildItem -Filter *.html

foreach ($f in $files) {
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)
    $text = $text.Replace('<link rel="stylesheet" href="chatbot_widget.css">', '')
    $text = $text.Replace('<script src="chatbot_widget.js"></script>', '')
    [IO.File]::WriteAllText($f.FullName, $text, $utf8)
}
