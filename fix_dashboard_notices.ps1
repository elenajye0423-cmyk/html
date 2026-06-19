$utf8 = New-Object System.Text.UTF8Encoding $false

# 1. Update portal.html
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)
$portalSrc = $portalSrc -replace 'href="portal_notices.html"\>\$\{badge\}\$\{n.title\}', 'href="portal_notices.html?view_id=${n.id}">${badge}${n.title}'
[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)

# 2. Update portal_notices.html
$noticesSrc = [IO.File]::ReadAllText("portal_notices.html", $utf8)
$noticesSrc = $noticesSrc -replace '(?s)document\.addEventListener\("DOMContentLoaded", \(\) => \{.*?\}\);', '
        document.addEventListener("DOMContentLoaded", () => {
            initDB();
            checkAdmin();
            loadNotices();
            
            // Check if we need to open a specific notice from Dashboard
            const params = new URLSearchParams(window.location.search);
            const viewId = params.get("view_id");
            if(viewId) {
                openNotice(viewId);
            }
        });
'
[IO.File]::WriteAllText("portal_notices.html", $noticesSrc, $utf8)

