$utf8 = New-Object System.Text.UTF8Encoding $false
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)

# 1. Update CSS
$portalSrc = $portalSrc -replace '\.dashboard-grid\.bottom \{ grid-template-columns: 1fr 1fr 1fr;', '.dashboard-grid.bottom { grid-template-columns: 1fr 1fr;'

# 2. Remove HTML block
$memoHtml = '(?s)\s*<div class="panel">\s*<div class="panel-header">\s*<div class="panel-title">📌 개인 업무 관리</div>.*?</div>\s*</div>\s*</div>'
$portalSrc = $portalSrc -replace $memoHtml, ''

# 3. Remove JS functions
$memoJs = '(?s)\s*function loadMemo\(\) \{.*?\}\s*function saveMemo\(\) \{.*?\}'
$portalSrc = $portalSrc -replace $memoJs, ''

# 4. Remove loadMemo(); call
$portalSrc = $portalSrc -replace '\s*loadMemo\(\);', ''

[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)

