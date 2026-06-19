$utf8 = New-Object System.Text.UTF8Encoding $false

# --- 1. portal_calendar.html ---
$calSrc = [IO.File]::ReadAllText("portal_calendar.html", $utf8)

# Remove password hints
$calSrc = $calSrc -replace '암호\(1234\)', '암호'

# Update to v4 and fix default events
$calSrc = $calSrc -replace 'batech_scheds_v3', 'batech_scheds_v4'
$calSrc = $calSrc -replace '"영업팀 회의"', '"총무부 주간 회의"'
$calSrc = $calSrc -replace '"기술팀 세미나"', '"품질보증부 세미나"'

[IO.File]::WriteAllText("portal_calendar.html", $calSrc, $utf8)


# --- 2. portal.html ---
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)

$portalSrc = $portalSrc -replace 'batech_scheds_v3', 'batech_scheds_v4'
$portalSrc = $portalSrc -replace '"영업팀 회의"', '"총무부 주간 회의"'
$portalSrc = $portalSrc -replace '"기술팀 세미나"', '"품질보증부 세미나"'

[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)


# --- 3. portal_notices.html ---
$noticeSrc = [IO.File]::ReadAllText("portal_notices.html", $utf8)

# Fix dialog centering
$noticeSrc = $noticeSrc -replace '<dialog id="notice-detail" style=".*?(max-width:.*?)">', '<dialog id="notice-detail" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 700px; width: 100%; margin: auto; max-height: 85vh; overflow-y: auto; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);">'

[IO.File]::WriteAllText("portal_notices.html", $noticeSrc, $utf8)


