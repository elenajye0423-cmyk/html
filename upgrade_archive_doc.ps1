$utf8 = New-Object System.Text.UTF8Encoding $false

# --- portal_archive.html ---
$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

# Update initArchive
$archiveSrc = $archiveSrc -replace '인사총무팀', '총무부'
$archiveSrc = $archiveSrc -replace '연차_반차_휴가_신청서_양식\.html', '연차_반차_휴가_신청서_양식.doc'
$archiveSrc = $archiveSrc -replace 'url: "연차_반차_휴가_신청서_양식\.doc"', 'url: "leave_form.html"'

# Add a one-time migration to fix localStorage on page load
$migration = @'
        function migrateArchiveData() {
            let archives = JSON.parse(localStorage.getItem("batech_archive_v1") || "[]");
            let modified = false;
            archives.forEach(a => {
                if(a.content.includes("인사총무팀")) {
                    a.content = a.content.replace(/인사총무팀/g, "총무부");
                    modified = true;
                }
                if(a.files) {
                    a.files.forEach(f => {
                        if(f.name === "연차_반차_휴가_신청서_양식.html") {
                            f.name = "연차_반차_휴가_신청서_양식.doc";
                            f.url = "leave_form.html";
                            modified = true;
                        }
                    });
                }
            });
            if(modified) {
                localStorage.setItem("batech_archive_v1", JSON.stringify(archives));
            }
        }
'@

$archiveSrc = $archiveSrc -replace 'function renderArchiveList\(\) \{', "$migration`r`n`r`n        function renderArchiveList() {"
$archiveSrc = $archiveSrc -replace 'initArchive\(\);', "initArchive();`r`n            migrateArchiveData();"

# Remove target="_blank" so that the browser triggers download instead of opening new tab for .html files (since we want it to download as .doc)
$archiveSrc = $archiveSrc -replace 'target="\$\{f\.url\.endsWith\(''\.html''\) \? ''_blank'' : ''_self''\}"', ''

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

