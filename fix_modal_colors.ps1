$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("inquiry.html", $utf8)

# Add explicit background and text color to the modal
$src = $src -replace '<dialog id="check-inquiry-modal" style="', '<dialog id="check-inquiry-modal" style="background: #ffffff; color: #1e293b; '

# Add explicit background to the input
$src = $src -replace 'id="search-email" placeholder="문의 시 등록한 이메일 주소 입력" style="', 'id="search-email" placeholder="문의 시 등록한 이메일 주소 입력" style="background: #ffffff; '

[IO.File]::WriteAllText("inquiry.html", $src, $utf8)

