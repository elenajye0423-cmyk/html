$utf8 = New-Object System.Text.UTF8Encoding $false

$calSrc = [IO.File]::ReadAllText("portal_calendar.html", $utf8)

$calSrc = $calSrc -replace 'placeholder="암호 \(1234\)"', 'placeholder="관리자 암호 입력"'

[IO.File]::WriteAllText("portal_calendar.html", $calSrc, $utf8)

