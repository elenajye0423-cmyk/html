$utf8 = New-Object System.Text.UTF8Encoding $false

# --- 1. portal_calendar.html ---
$calSrc = [IO.File]::ReadAllText("portal_calendar.html", $utf8)

# Add missing 2026-06-03
$calSrc = $calSrc -replace '"2026-06-06": "현충일"', '"2026-06-03": "지방선거", "2026-06-06": "현충일"'

# Restore missing openEdit functions
$missingJs = @'
        let currentViewData = {};

        function openEdit(dateStr, idx, encodedTitle, encodedMemo) {
            currentViewData = { dStr: dateStr, idx: idx, t: encodedTitle, m: encodedMemo };
            document.getElementById("view-sched-title").innerText = decodeURIComponent(encodedTitle);
            document.getElementById("view-sched-date").innerText = dateStr;
            let m = decodeURIComponent(encodedMemo);
            document.getElementById("view-sched-memo").innerText = m ? m : "등록된 메모가 없습니다.";
            document.getElementById("view-schedule-modal").showModal();
        }

        function openEditFromView() {
            document.getElementById("view-schedule-modal").close();
            document.getElementById("edit-orig-date").value = currentViewData.dStr;
            document.getElementById("edit-sched-date").value = currentViewData.dStr;
            document.getElementById("edit-orig-idx").value = currentViewData.idx;
            document.getElementById("edit-sched-title").value = decodeURIComponent(currentViewData.t);
            document.getElementById("edit-sched-memo").value = decodeURIComponent(currentViewData.m);
            document.getElementById("edit-sched-pwd").value = "";
            document.getElementById("edit-schedule-modal").showModal();
        }

        let pendingAction = null;
'@

$calSrc = $calSrc -replace 'let pendingAction = null;', $missingJs
[IO.File]::WriteAllText("portal_calendar.html", $calSrc, $utf8)


# --- 2. portal.html ---
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)
$portalSrc = $portalSrc -replace '"2026-06-06": "현충일"', '"2026-06-03": "지방선거", "2026-06-06": "현충일"'
[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)


