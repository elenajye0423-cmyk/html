$utf8 = New-Object System.Text.UTF8Encoding $false

# 1. Rename the physical file to Korean
if (Test-Path "leave_form.doc") {
    Rename-Item "leave_form.doc" "연차_반차_휴가_신청서_양식.doc" -Force
}

# 2. Update portal_archive.html URL
$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)
$archiveSrc = $archiveSrc -replace 'url: "leave_form\.doc"', 'url: "연차_반차_휴가_신청서_양식.doc"'

# Also bump the version string in the localStorage check to force a reset to pick up the new URL 
# (though it might be better to just replace it directly in the DB if it exists)
$archiveSrc = $archiveSrc -replace 'batech_archive_v3', 'batech_archive_v4'

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

