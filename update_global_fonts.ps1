$content = Get-Content ".\style.css" -Raw -Encoding UTF8

$oldHtml = 'html \{ scroll-behavior: smooth; scroll-padding-top: var\(--nav-height\); \}'
$newHtml = 'html { scroll-behavior: smooth; scroll-padding-top: var(--nav-height); font-size: clamp(11px, 1.3vw + 4px, 16px); }'
$content = $content -replace $oldHtml, $newHtml

$oldBody = 'body \{ font-family: ''Pretendard'', ''Noto Sans KR'', ''Inter'', sans-serif; color: var\(--text-main\); background-color: var\(--bg-main\); line-height: 1.8; overflow-x: hidden; font-size: 16px;'
$newBody = 'body { font-family: ''Pretendard'', ''Noto Sans KR'', ''Inter'', sans-serif; color: var(--text-main); background-color: var(--bg-main); line-height: 1.8; overflow-x: hidden; font-size: 1rem;'
$content = $content -replace $oldBody, $newBody

[IO.File]::WriteAllText(".\style.css", $content, (New-Object System.Text.UTF8Encoding $False))
Write-Host "Updated style.css"
