$utf8 = New-Object System.Text.UTF8Encoding $false
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)
$jsSnippet = [IO.File]::ReadAllText("snippet_portal.js", $utf8)

# Replace everything from // CS Dashboard Logic down to the end of the script block
$portalSrc = [regex]::Replace($portalSrc, '(?s)// CS Dashboard Logic.*?}\);', $jsSnippet)

[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)
Write-Host "portal.html rebuilt successfully!"

