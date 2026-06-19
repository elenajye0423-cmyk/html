$utf8 = New-Object System.Text.UTF8Encoding $false
$inquirySrc = [IO.File]::ReadAllText("inquiry.html", $utf8)

$btnSnippet = [IO.File]::ReadAllText("snippet_btn.html", $utf8)
$modalSnippet = [IO.File]::ReadAllText("snippet_modal.html", $utf8)

# Replace corrupted button above form
$inquirySrc = [regex]::Replace($inquirySrc, '(?s)<div style="text-align: right; margin-bottom: 20px;">.*?</div>', $btnSnippet)

# Replace corrupted modal block
$inquirySrc = [regex]::Replace($inquirySrc, '(?s)<!-- Inquiry Check Modal -->.*?</body>', $modalSnippet)

# Fix corrupted text inside JS function
$noResultMsg = [IO.File]::ReadAllText("snippet_js1.html", $utf8)
$inquirySrc = [regex]::Replace($inquirySrc, '(?s)<div style="text-align: center; color: #ef4444; padding: 30px;">.*?</div>', $noResultMsg)

$replyHeaderMsg = [IO.File]::ReadAllText("snippet_js2.html", $utf8)
$inquirySrc = [regex]::Replace($inquirySrc, '(?s)<strong style="color: #1e293b; display: block; margin-bottom: 8px;">.*?</strong>', $replyHeaderMsg)

$statusDoneMsg = [IO.File]::ReadAllText("snippet_js3.html", $utf8)
$inquirySrc = [regex]::Replace($inquirySrc, '(?s)<span style="background: #dcfce7; color: #16a34a; padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: bold;">.*?</span>', $statusDoneMsg)

$statusWaitMsg = [IO.File]::ReadAllText("snippet_js4.html", $utf8)
$inquirySrc = [regex]::Replace($inquirySrc, '(?s)<span style="background: #ffedd5; color: #ea580c; padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: bold;">.*?</span>', $statusWaitMsg)


# Fix ALL xmark instances across ALL HTML files
$files = Get-ChildItem -Filter *.html
foreach ($file in $files) {
    $content = [IO.File]::ReadAllText($file.FullName, $utf8)
    if ($content -match '<i class="fa-solid fa-xmark"></i>') {
        $content = $content -replace '<i class="fa-solid fa-xmark"></i>', '&#10005;'
        [IO.File]::WriteAllText($file.FullName, $content, $utf8)
        Write-Host "Replaced xmark in $($file.Name)"
    }
}

[IO.File]::WriteAllText("inquiry.html", $inquirySrc, $utf8)
Write-Host "Fixed inquiry.html successfully."

