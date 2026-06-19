$utf8 = New-Object System.Text.UTF8Encoding $false

$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)

# Replace the specific version of batech_board_ in loadBoardPreview
$portalSrc = $portalSrc -replace 'localStorage.getItem\("batech_board_v2"\)', 'localStorage.getItem("batech_board_v4")'

[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)

