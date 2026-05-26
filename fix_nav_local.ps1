$navbar = [System.IO.File]::ReadAllText('navbar.txt', [System.Text.Encoding]::UTF8)
$files = Get-ChildItem -Filter *.html
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

foreach ($file in $files) {
    if ($file.Name -eq 'management-viewer.html') { continue }
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($content -match '(?s)<nav id="navbar".*?</nav>') {
        $content = $content.Replace($Matches[0], $navbar)
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
        Write-Output "Fixed $($file.Name)"
    }
}
