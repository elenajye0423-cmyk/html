$utf8 = New-Object System.Text.UTF8Encoding $false

$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

# Remove the broken orphan block
$badBlock = @'
                                
                
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
                localStorage.setItem("batech_archive_v2", JSON.stringify(archives));
            }
        }
'@

$archiveSrc = $archiveSrc.Replace($badBlock, '')

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

