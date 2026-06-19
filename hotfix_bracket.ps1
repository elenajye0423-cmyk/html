$utf8 = New-Object System.Text.UTF8Encoding $false
$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

$search = @'
                localStorage.setItem("batech_archive_v3", JSON.stringify(defaults));
            }




        function renderArchiveList() {
'@

$replace = @'
                localStorage.setItem("batech_archive_v3", JSON.stringify(defaults));
            }
        }

        function renderArchiveList() {
'@

$archiveSrc = $archiveSrc.Replace($search, $replace)

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

