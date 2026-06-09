$utf8 = New-Object System.Text.UTF8Encoding $false

# Read
$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

# 1. Update initArchive defaults
$archiveSrc = $archiveSrc -replace 'views: 154', 'views: 0'
$archiveSrc = $archiveSrc -replace 'views: 342', 'views: 0'
$archiveSrc = $archiveSrc -replace 'views: 89', 'views: 0'
$archiveSrc = $archiveSrc -replace 'views: 215', 'views: 0'

# 2. Fix the broken migrateArchiveData and add view reset
$cleanScript = @'
        function migrateArchiveData() {
            let archives = JSON.parse(localStorage.getItem("batech_archive_v1") || "[]");
            let modified = false;
            archives.forEach(a => {
                // Reset fake views to 0
                if (a.views === 154 || a.views === 342 || a.views === 89 || a.views === 215) {
                    a.views = 0;
                    modified = true;
                }
                
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
                        if(f.url === "#" || f.url === "notebooklm_cardnews.html") {
                            f.url = "dummy_file.txt";
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

# Replace the broken function block.
# We will target everything between `<script>` and `function renderArchiveList() {` except `initArchive()`.
# Safer: Replace from `function migrateArchiveData() {` down to `function renderArchiveList() {`
$archiveSrc = $archiveSrc -replace '(?s)function migrateArchiveData\(\) \{.*?function renderArchiveList\(\) \{', "$cleanScript`r`n`r`n        function renderArchiveList() {"

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

