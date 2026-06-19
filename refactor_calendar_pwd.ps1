$utf8 = New-Object System.Text.UTF8Encoding $false

# --- portal_calendar.html ---
$calSrc = [IO.File]::ReadAllText("portal_calendar.html", $utf8)

# Remove the red password fields from both modals
$calSrc = $calSrc -replace '(?s)<div class="form-group" style="background: #fef2f2; padding: 15px; border-radius: 8px; border: 1px solid #fecaca;">.*?</div>', ''

# Inject the new password modal
$pwdModal = @'
    <!-- Password Prompt Modal -->
    <dialog id="calendar-pwd-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 400px; width: 100%; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); margin: 0;">
        <h3 style="margin-top: 0; margin-bottom: 1rem; color: #1e293b;">보안 암호 확인</h3>
        <p style="font-size: 0.9rem; color: #64748b; margin-bottom: 1.5rem;" id="pwd-modal-desc">해당 작업을 수행하려면 관리자 암호가 필요합니다.</p>
        <input type="password" id="action-pwd" class="input-box" placeholder="암호 (1234)" style="margin-bottom: 1rem;" onkeypress="if(event.key === 'Enter') submitPwd()">
        <div style="text-align: right; display: flex; justify-content: flex-end; gap: 10px;">
            <button class="btn-sm" onclick="document.getElementById(`calendar-pwd-modal`).close()">취소</button>
            <button class="btn-sm primary" onclick="submitPwd()">확인</button>
        </div>
    </dialog>
'@

$calSrc = $calSrc -replace '<!-- Add Schedule Modal -->', "$pwdModal`r`n`r`n    <!-- Add Schedule Modal -->"

# Now we need to rewrite the JS part handling the additions
$newJs = @'
        let pendingAction = null;

        function promptPwd(actionType) {
            pendingAction = actionType;
            let desc = "";
            if(actionType === "add") desc = "일정 등록을 위해 관리자 암호가 필요합니다.";
            if(actionType === "edit") desc = "일정 수정을 위해 관리자 암호가 필요합니다.";
            if(actionType === "delete") desc = "일정 삭제를 위해 관리자 암호가 필요합니다.";
            
            document.getElementById("pwd-modal-desc").innerText = desc;
            document.getElementById("action-pwd").value = "";
            document.getElementById("calendar-pwd-modal").showModal();
        }

        function submitPwd() {
            let pwd = document.getElementById("action-pwd").value;
            if(pwd !== "1234") {
                alert("보안 암호가 올바르지 않습니다.");
                return;
            }
            
            document.getElementById("calendar-pwd-modal").close();
            
            if(pendingAction === "add") executeAdd();
            if(pendingAction === "edit") executeEdit();
            if(pendingAction === "delete") executeDelete();
        }

        function addSchedule() {
            const dateStr = document.getElementById("add-sched-date").value;
            const title = document.getElementById("add-sched-title").value;
            if(!dateStr || !title) return alert("날짜와 제목을 모두 입력해주세요. (필수)");
            
            promptPwd("add");
        }
        
        function executeAdd() {
            const dateStr = document.getElementById("add-sched-date").value;
            const title = document.getElementById("add-sched-title").value;
            const memo = document.getElementById("add-sched-memo").value;
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v5") || "{}");
            if(!customScheds[dateStr]) customScheds[dateStr] = [];
            customScheds[dateStr].push({ title: title, memo: memo, type: "custom" });
            localStorage.setItem("batech_scheds_v5", JSON.stringify(customScheds));
            
            let addedDate = new Date(dateStr);
            currentCalDate = new Date(addedDate.getFullYear(), addedDate.getMonth(), 1);
            
            renderCalendar();
            document.getElementById("add-schedule-modal").close();
            alert("새 일정이 성공적으로 등록되었습니다!");
        }

        function saveEditSchedule() {
            let nTitle = document.getElementById("edit-sched-title").value;
            if(!nTitle) return alert("제목을 입력하세요. (필수)");
            
            promptPwd("edit");
        }
        
        function executeEdit() {
            let dStr = document.getElementById("edit-orig-date").value;
            let idx = document.getElementById("edit-orig-idx").value;
            let nTitle = document.getElementById("edit-sched-title").value;
            let nMemo = document.getElementById("edit-sched-memo").value;
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v5") || "{}");
            if(customScheds[dStr] && customScheds[dStr][idx]) {
                customScheds[dStr][idx].title = nTitle;
                customScheds[dStr][idx].memo = nMemo;
                localStorage.setItem("batech_scheds_v5", JSON.stringify(customScheds));
                renderCalendar();
                document.getElementById("edit-schedule-modal").close();
                alert("일정이 성공적으로 수정되었습니다.");
            }
        }

        function deleteSchedule() {
            if(confirm("정말 이 일정을 삭제하시겠습니까? (삭제 전 암호를 묻습니다)")) {
                promptPwd("delete");
            }
        }
        
        function executeDelete() {
            let dStr = document.getElementById("edit-orig-date").value;
            let idx = document.getElementById("edit-orig-idx").value;
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v5") || "{}");
            if(customScheds[dStr]) {
                customScheds[dStr].splice(idx, 1);
                localStorage.setItem("batech_scheds_v5", JSON.stringify(customScheds));
                renderCalendar();
                document.getElementById("edit-schedule-modal").close();
                alert("일정이 삭제되었습니다.");
            }
        }
'@

$calSrc = $calSrc -replace '(?s)function addSchedule\(\) \{.*?(?=document\.addEventListener\("DOMContentLoaded", renderCalendar\);)', "$newJs`r`n        "
[IO.File]::WriteAllText("portal_calendar.html", $calSrc, $utf8)

