$utf8 = New-Object System.Text.UTF8Encoding $false

# --- 1. portal_calendar.html ---
$calSrc = [IO.File]::ReadAllText("portal_calendar.html", $utf8)

$newScript = @'
    <script>
        let currentCalDate = new Date(2026, 5, 1); // 2026년 6월

        function migrateOldData() {
            if(!localStorage.getItem("batech_scheds_v5")) {
                let v5 = {};
                let v4 = JSON.parse(localStorage.getItem("batech_scheds_v4") || "{}");
                for(let dStr in v4) {
                    let customEvents = v4[dStr].filter(e => e.type === "custom");
                    if(customEvents.length > 0) v5[dStr] = customEvents;
                }
                localStorage.setItem("batech_scheds_v5", JSON.stringify(v5));
            }
        }

        function renderCalendar() {
            migrateOldData();
            const year = currentCalDate.getFullYear();
            const month = currentCalDate.getMonth();
            document.getElementById("cal-month-title").innerText = `${year}년 ${month+1}월`;
            
            const firstDay = new Date(year, month, 1).getDay();
            const daysInMonth = new Date(year, month+1, 0).getDate();
            const grid = document.getElementById("full-calendar");
            
            let html = `<div class="cal-header">일</div><div class="cal-header">월</div><div class="cal-header">화</div><div class="cal-header">수</div><div class="cal-header">목</div><div class="cal-header">금</div><div class="cal-header">토</div>`;
            
            for(let i=0; i<firstDay; i++) {
                html += `<div class="cal-day empty"></div>`;
            }
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v5") || "{}");
            
            let holidays = {
                "2026-01-01": "신정", "2026-02-16": "설날", "2026-02-17": "설날", "2026-02-18": "설날",
                "2026-03-01": "삼일절", "2026-05-05": "어린이날", "2026-05-24": "부처님오신날", "2026-05-25": "대체공휴일",
                "2026-06-06": "현충일", "2026-08-15": "광복절", "2026-09-24": "추석", "2026-09-25": "추석", "2026-09-26": "추석",
                "2026-10-03": "개천절", "2026-10-09": "한글날", "2026-12-25": "기독탄신일"
            };

            let today = new Date();
            for(let i=1; i<=daysInMonth; i++) {
                let dStr = `${year}-${String(month+1).padStart(2,"0")}-${String(i).padStart(2,"0")}`;
                let isToday = (today.getFullYear() === year && today.getMonth() === month && today.getDate() === i) ? "today" : "";
                
                let eventsHTML = "";
                if(holidays[dStr]) {
                    eventsHTML += `<div class="cal-event" style="background:#fee2e2; color:#991b1b; font-weight:700;">🇰🇷 ${holidays[dStr]}</div>`;
                }

                if(customScheds[dStr]) {
                    customScheds[dStr].forEach((e, idx) => {
                        if(e.type === "custom") {
                            let t = encodeURIComponent(e.title);
                            let m = encodeURIComponent(e.memo || "");
                            eventsHTML += `<div class="cal-event custom" onclick="openEdit(\`${dStr}\`, ${idx}, \`${t}\`, \`${m}\`)">${e.title}</div>`;
                        }
                    });
                }
                
                let dateColor = isToday ? "color: #ca8a04;" : (new Date(year, month, i).getDay() === 0 || holidays[dStr] ? "color: #ef4444;" : "");
                html += `<div class="cal-day ${isToday}"><strong style="${dateColor}">${i}</strong>${eventsHTML}</div>`;
            }
            grid.innerHTML = html;
        }

        function changeMonth(delta) {
            currentCalDate.setMonth(currentCalDate.getMonth() + delta);
            renderCalendar();
        }

        function openAddModal() {
            let tzOffset = (new Date()).getTimezoneOffset() * 60000; 
            let localISOTime = (new Date(Date.now() - tzOffset)).toISOString().slice(0, 10);
            document.getElementById("add-sched-date").value = localISOTime;
            document.getElementById("add-sched-title").value = "";
            document.getElementById("add-sched-memo").value = "";
            document.getElementById("add-sched-pwd").value = "";
            document.getElementById("add-schedule-modal").showModal();
        }

        function addSchedule() {
            const dateStr = document.getElementById("add-sched-date").value;
            const title = document.getElementById("add-sched-title").value;
            const memo = document.getElementById("add-sched-memo").value;
            const pwd = document.getElementById("add-sched-pwd").value;
            
            if(!dateStr || !title) return alert("날짜와 제목을 모두 입력해주세요. (필수)");
            if(pwd !== "1234") return alert("보안 암호가 올바르지 않습니다.");
            
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

        function openEdit(dateStr, idx, encodedTitle, encodedMemo) {
            document.getElementById("edit-orig-date").value = dateStr;
            document.getElementById("edit-sched-date").value = dateStr;
            document.getElementById("edit-orig-idx").value = idx;
            document.getElementById("edit-sched-title").value = decodeURIComponent(encodedTitle);
            document.getElementById("edit-sched-memo").value = decodeURIComponent(encodedMemo);
            document.getElementById("edit-sched-pwd").value = "";
            document.getElementById("edit-schedule-modal").showModal();
        }

        function saveEditSchedule() {
            let dStr = document.getElementById("edit-orig-date").value;
            let idx = document.getElementById("edit-orig-idx").value;
            let nTitle = document.getElementById("edit-sched-title").value;
            let nMemo = document.getElementById("edit-sched-memo").value;
            let pwd = document.getElementById("edit-sched-pwd").value;
            
            if(!nTitle) return alert("제목을 입력하세요. (필수)");
            if(pwd !== "1234") return alert("보안 암호가 올바르지 않습니다.");
            
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
            let dStr = document.getElementById("edit-orig-date").value;
            let idx = document.getElementById("edit-orig-idx").value;
            let pwd = document.getElementById("edit-sched-pwd").value;
            
            if(pwd !== "1234") return alert("보안 암호가 올바르지 않습니다.");
            
            if(confirm("정말 이 일정을 삭제하시겠습니까?")) {
                let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v5") || "{}");
                if(customScheds[dStr]) {
                    customScheds[dStr].splice(idx, 1);
                    localStorage.setItem("batech_scheds_v5", JSON.stringify(customScheds));
                    renderCalendar();
                    document.getElementById("edit-schedule-modal").close();
                    alert("일정이 삭제되었습니다.");
                }
            }
        }

        document.addEventListener("DOMContentLoaded", renderCalendar);
    </script>
'@

$calSrc = $calSrc -replace '(?s)<script>.*?(?=<footer>)', "$newScript`r`n"
[IO.File]::WriteAllText("portal_calendar.html", $calSrc, $utf8)

# --- 2. portal_board.html ---
$boardSrc = [IO.File]::ReadAllText("portal_board.html", $utf8)
$boardSrc = $boardSrc -replace '\.modal \{.*\}', '.modal { border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 600px; width: 100%; margin: auto; max-height: 85vh; overflow-y: auto; }'
[IO.File]::WriteAllText("portal_board.html", $boardSrc, $utf8)


