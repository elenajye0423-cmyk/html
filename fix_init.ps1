$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("portal.html", $utf8)

$oldInit = 'localStorage.setItem("batech_inquiries", JSON.stringify(dummy));'
$newInit = 'let existing = JSON.parse(localStorage.getItem("batech_inquiries") || "[]");
        let combined = existing.concat(dummy);
        localStorage.setItem("batech_inquiries", JSON.stringify(combined));'

$src = $src.Replace($oldInit, $newInit)
[IO.File]::WriteAllText("portal.html", $src, $utf8)
Write-Host "Fixed initialization logic"

