$utf8 = New-Object System.Text.UTF8Encoding $false

# --- 1. portal_calendar.html ---
$calSrc = [IO.File]::ReadAllText("portal_calendar.html", $utf8)

$viewModal = @'
    <!-- View Schedule Modal -->
    <dialog id="view-schedule-modal" style="border: none; border-radius: 12px; padding: 2.5rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 450px; width: 100%; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); margin: 0;">
        <h2 id="view-sched-title" style="margin-top: 0; margin-bottom: 0.5rem; color: #1e293b; font-size: 1.5rem;"></h2>
        <div style="font-size: 0.9rem; color: #64748b; margin-bottom: 1.5rem; border-bottom: 1px solid #e2e8f0; padding-bottom: 1rem;">
            일정 날짜: <strong id="view-sched-date" style="color: var(--primary-color);"></strong>
        </div>
        <div id="view-sched-memo" style="color: #334155; line-height: 1.6; min-height: 80px; white-space: pre-wrap; background: #f8fafc; padding: 15px; border-radius: 8px; border: 1px solid #e2e8f0; margin-bottom: 1.5rem;"></div>
        
        <div style="text-align: right; display: flex; justify-content: space-between; align-items: center; gap: 10px;">
            <button class="btn-sm" style="background: #e2e8f0; color: #475569;" onclick="document.getElementById(`view-schedule-modal`).close()">닫기</button>
            <button class="btn-sm" style="background: #fff; border: 1px solid #cbd5e1; color: #64748b;" onclick="openEditFromView()">수정 및 삭제하기</button>
        </div>
    </dialog>
'@

# Inject view modal before edit modal
$calSrc = $calSrc -replace '<!-- Edit/View Schedule Modal -->', "$viewModal`r`n`r`n    <!-- Edit/View Schedule Modal -->"

# Update Edit Modal HTML & Dialog styles
$calSrc = $calSrc -replace '<dialog id="edit-schedule-modal".*?>', '<dialog id="edit-schedule-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 450px; width: 100%; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); margin: 0;">'
$calSrc = $calSrc -replace '<dialog id="add-schedule-modal".*?>', '<dialog id="add-schedule-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 450px; width: 100%; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); margin: 0;">'

# JS updates for view logic
$jsUpdates = @'
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
'@

$calSrc = $calSrc -replace '(?s)function openEdit\(dateStr, idx, encodedTitle, encodedMemo\) \{.*?(?=\s*function saveEditSchedule)', "$jsUpdates`r`n"
[IO.File]::WriteAllText("portal_calendar.html", $calSrc, $utf8)


# --- 2. portal_board.html ---
$boardSrc = [IO.File]::ReadAllText("portal_board.html", $utf8)
$boardSrc = $boardSrc -replace '\.modal \{.*\}', '.modal { border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 600px; width: 100%; margin: 0; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); max-height: 85vh; overflow-y: auto; }'
[IO.File]::WriteAllText("portal_board.html", $boardSrc, $utf8)


# --- 3. portal_notices.html ---
$noticeSrc = [IO.File]::ReadAllText("portal_notices.html", $utf8)
$noticeSrc = $noticeSrc -replace '<dialog id="notice-detail".*?>', '<dialog id="notice-detail" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 700px; width: 100%; margin: 0; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); max-height: 85vh; overflow-y: auto;">'
$noticeSrc = $noticeSrc -replace '<dialog id="notice-pwd-modal".*?>', '<dialog id="notice-pwd-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 400px; width: 100%; margin: 0; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);">'
[IO.File]::WriteAllText("portal_notices.html", $noticeSrc, $utf8)

# --- 4. portal.html (Dashboard reply modal) ---
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)
$portalSrc = $portalSrc -replace '<dialog id="reply-modal".*?>', '<dialog id="reply-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 500px; width: 100%; margin: 0; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);">'
[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)


