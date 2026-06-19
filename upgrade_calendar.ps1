$utf8 = New-Object System.Text.UTF8Encoding $false

# --- 1. portal_calendar.html ---
$calendarContent = @'
    <style>
        .page-header { background: #0f172a; padding: 60px 0; text-align: center; color: white; }
        .page-header h1 { font-size: 2.5rem; font-weight: 800; }
        .cal-container { max-width: 1000px; margin: 40px auto; background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .cal-controls { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; background: #f8fafc; padding: 20px; border-radius: 8px; border: 1px solid #e2e8f0; }
        .cal-nav { display: flex; align-items: center; gap: 15px; }
        .cal-nav button { background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #475569; transition: 0.2s; }
        .cal-nav button:hover { color: var(--primary-color); }
        .cal-nav h3 { margin: 0; font-size: 1.5rem; color: #1e293b; min-width: 150px; text-align: center; }
        .cal-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 2px; background: #cbd5e1; border: 1px solid #cbd5e1; border-radius: 8px; overflow: hidden; }
        .cal-header { background: #f1f5f9; font-weight: 700; font-size: 1rem; text-align: center; padding: 10px; color: #475569; }
        .cal-day { background: #fff; min-height: 100px; padding: 5px; font-size: 1rem; color: #334155; position: relative; }
        .cal-day.empty { background: #f8fafc; color: #cbd5e1; }
        .cal-day.today { background: #fef9c3; }
        .cal-event { background: #dbeafe; color: #1e40af; font-size: 0.8rem; padding: 0.3rem 0.5rem; border-radius: 4px; margin-top: 0.3rem; cursor: pointer; font-weight: 500; transition: filter 0.2s; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .cal-event:hover { filter: brightness(0.9); }
        .cal-event.meeting { background: #fce7f3; color: #9d174d; }
        .cal-event.custom { background: #dcfce7; color: #166534; }
        .btn-primary { background: var(--primary-color); color: #fff; border: none; padding: 10px 20px; border-radius: 8px; font-weight: bold; cursor: pointer; }
        .input-box { padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; width: 100%; box-sizing: border-box; }
        .btn-sm { padding: 0.4rem 0.8rem; border-radius: 6px; font-size: 0.85rem; cursor: pointer; border: none; background: #e2e8f0; color: #475569; font-weight: 600; }
        .btn-sm.primary { background: var(--primary-color); color: #fff; }
        dialog::backdrop { background: rgba(0,0,0,0.5); backdrop-filter: blur(2px); }
        .form-group { margin-bottom: 15px; }
        .form-label { display: block; font-weight: 600; margin-bottom: 5px; color: #1e293b; }
        .form-label .req { color: #dc2626; }
    </style>
    <div class="page-header">
        <h1>사내 일정 관리</h1>
        <p>전사 스케줄 및 개인 일정을 등록/관리하세요.</p>
    </div>
    <div class="container cal-container">
        <a href="portal.html" style="display:inline-block; margin-bottom:20px; color: var(--primary-color); font-weight: bold; text-decoration: none;">&larr; 대시보드로 돌아가기</a>
        
        <div class="cal-controls">
            <div class="cal-nav">
                <button onclick="changeMonth(-1)"><i class="fas fa-chevron-left"></i></button>
                <h3 id="cal-month-title">2026년 6월</h3>
                <button onclick="changeMonth(1)"><i class="fas fa-chevron-right"></i></button>
            </div>
            <div>
                <button class="btn-primary" onclick="openAddModal()">+ 새 일정 등록</button>
            </div>
        </div>

        <div class="cal-grid" id="full-calendar"></div>
    </div>

    <!-- Add Schedule Modal -->
    <dialog id="add-schedule-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 450px; width: 100%;">
        <h3 style="margin-top: 0; margin-bottom: 1.5rem; color: #1e293b;">새 일정 등록</h3>
        <div class="form-group">
            <label class="form-label">일정 날짜 <span class="req">*</span></label>
            <input type="date" id="add-sched-date" class="input-box" required>
        </div>
        <div class="form-group">
            <label class="form-label">일정 제목 <span class="req">*</span></label>
            <input type="text" id="add-sched-title" class="input-box" placeholder="일정 제목 입력" required>
        </div>
        <div class="form-group">
            <label class="form-label">메모 (상세내용)</label>
            <textarea id="add-sched-memo" class="input-box" style="height: 80px; resize: none;" placeholder="상세 일정을 메모하세요..."></textarea>
        </div>
        <div class="form-group" style="background: #fef2f2; padding: 15px; border-radius: 8px; border: 1px solid #fecaca;">
            <label class="form-label" style="color: #991b1b;">보안 암호 확인 <span class="req">*</span></label>
            <input type="password" id="add-sched-pwd" class="input-box" placeholder="일정 관리자 암호 입력" required>
            <small style="color: #ef4444; display: block; margin-top: 5px;">* 일정 등록을 위해 암호(1234)가 필요합니다.</small>
        </div>
        <div style="text-align: right; display: flex; justify-content: flex-end; gap: 10px;">
            <button class="btn-sm" onclick="document.getElementById(`add-schedule-modal`).close()">취소</button>
            <button class="btn-sm primary" onclick="addSchedule()">일정 등록</button>
        </div>
    </dialog>

    <!-- Edit/View Schedule Modal -->
    <dialog id="edit-schedule-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 450px; width: 100%;">
        <h3 style="margin-top: 0; margin-bottom: 1.5rem; color: #1e293b;">일정 상세 / 수정</h3>
        <input type="hidden" id="edit-orig-date">
        <input type="hidden" id="edit-orig-idx">
        <div class="form-group">
            <label class="form-label">일정 날짜 <span class="req">*</span></label>
            <input type="date" id="edit-sched-date" class="input-box" required disabled style="background:#f1f5f9;">
        </div>
        <div class="form-group">
            <label class="form-label">일정 제목 <span class="req">*</span></label>
            <input type="text" id="edit-sched-title" class="input-box" required>
        </div>
        <div class="form-group">
            <label class="form-label">메모 (상세내용)</label>
            <textarea id="edit-sched-memo" class="input-box" style="height: 80px; resize: none;"></textarea>
        </div>
        <div class="form-group" style="background: #fef2f2; padding: 15px; border-radius: 8px; border: 1px solid #fecaca;">
            <label class="form-label" style="color: #991b1b;">보안 암호 확인 <span class="req">*</span></label>
            <input type="password" id="edit-sched-pwd" class="input-box" placeholder="수정/삭제를 위한 암호 입력" required>
            <small style="color: #ef4444; display: block; margin-top: 5px;">* 일정 수정/삭제를 위해 암호(1234)가 필요합니다.</small>
        </div>
        <div style="text-align: right; display: flex; justify-content: space-between; align-items: center; gap: 10px;">
            <button class="btn-sm" style="background: #fee2e2; color: #991b1b;" onclick="deleteSchedule()">일정 삭제</button>
            <div style="display: flex; gap: 10px;">
                <button class="btn-sm" onclick="document.getElementById(`edit-schedule-modal`).close()">닫기</button>
                <button class="btn-sm primary" onclick="saveEditSchedule()">변경 저장</button>
            </div>
        </div>
    </dialog>

    <script>
        let currentCalDate = new Date(2026, 5, 1); // 2026년 6월

        function migrateOldData() {
            if(!localStorage.getItem("batech_scheds_v3")) {
                let v3 = {
                    "2026-06-01": [{title:"정례조회", memo:"", type:"default"}],
                    "2026-06-04": [{title:"영업팀 회의", memo:"", type:"meeting"}],
                    "2026-06-11": [{title:"기술팀 세미나", memo:"", type:"meeting"}],
                    "2026-06-12": [{title:"워크숍 출발", memo:"", type:"default"}]
                };
                let v2 = JSON.parse(localStorage.getItem("batech_scheds_v2") || "{}");
                for(let day in v2) {
                    let dStr = "2026-06-" + String(day).padStart(2, "0");
                    if(!v3[dStr]) v3[dStr] = [];
                    v2[day].forEach(e => { v3[dStr].push({title: e.title, memo: e.memo, type:"custom"}); });
                }
                localStorage.setItem("batech_scheds_v3", JSON.stringify(v3));
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
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v3") || "{}");
            
            let today = new Date();
            for(let i=1; i<=daysInMonth; i++) {
                let dStr = `${year}-${String(month+1).padStart(2,"0")}-${String(i).padStart(2,"0")}`;
                let isToday = (today.getFullYear() === year && today.getMonth() === month && today.getDate() === i) ? "today" : "";
                
                let eventsHTML = "";
                if(customScheds[dStr]) {
                    customScheds[dStr].forEach((e, idx) => {
                        let t = encodeURIComponent(e.title);
                        let m = encodeURIComponent(e.memo || "");
                        if(e.type === "custom") {
                            eventsHTML += `<div class="cal-event custom" onclick="openEdit(\`${dStr}\`, ${idx}, \`${t}\`, \`${m}\`)">${e.title}</div>`;
                        } else {
                            eventsHTML += `<div class="cal-event ${e.type === "meeting" ? "meeting" : ""}" onclick="alert(\`기본 회사 일정은 수정/삭제할 수 없습니다.\\n\\n상세: ${e.title}\`)">${e.title}</div>`;
                        }
                    });
                }
                
                let dateColor = isToday ? "color: #ca8a04;" : "";
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
            if(pwd !== "1234") return alert("보안 암호(1234)가 올바르지 않습니다.");
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v3") || "{}");
            if(!customScheds[dateStr]) customScheds[dateStr] = [];
            customScheds[dateStr].push({ title: title, memo: memo, type: "custom" });
            localStorage.setItem("batech_scheds_v3", JSON.stringify(customScheds));
            
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
            if(pwd !== "1234") return alert("보안 암호(1234)가 올바르지 않습니다.");
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v3") || "{}");
            if(customScheds[dStr] && customScheds[dStr][idx]) {
                customScheds[dStr][idx].title = nTitle;
                customScheds[dStr][idx].memo = nMemo;
                localStorage.setItem("batech_scheds_v3", JSON.stringify(customScheds));
                renderCalendar();
                document.getElementById("edit-schedule-modal").close();
                alert("일정이 성공적으로 수정되었습니다.");
            }
        }

        function deleteSchedule() {
            let dStr = document.getElementById("edit-orig-date").value;
            let idx = document.getElementById("edit-orig-idx").value;
            let pwd = document.getElementById("edit-sched-pwd").value;
            
            if(pwd !== "1234") return alert("보안 암호(1234)가 올바르지 않습니다.");
            
            if(confirm("정말 이 일정을 삭제하시겠습니까?")) {
                let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v3") || "{}");
                if(customScheds[dStr]) {
                    customScheds[dStr].splice(idx, 1);
                    localStorage.setItem("batech_scheds_v3", JSON.stringify(customScheds));
                    renderCalendar();
                    document.getElementById("edit-schedule-modal").close();
                    alert("일정이 삭제되었습니다.");
                }
            }
        }

        document.addEventListener("DOMContentLoaded", renderCalendar);
    </script>
'@
$baseSrc = [IO.File]::ReadAllText("index.html", $utf8)
$calendarHTML = $baseSrc -replace '(?s)(</nav>).*?(<footer>)', "`$1`r`n$calendarContent`r`n`$2"
$calendarHTML = $calendarHTML -replace '(?s)<nav id="navbar">.*?</nav>', '<nav id="navbar" style="background: #0f172a;"><div class="nav-container"><a href="portal.html" class="logo" style="color: white;"><span class="logo-icon">💧</span> B.A. TECH 포털</a><ul class="nav-links"><li class="nav-item"><a href="portal.html" style="color: #cbd5e1;">대시보드</a></li><li class="nav-item"><a href="portal_notices.html" style="color: #cbd5e1;">공지사항</a></li><li class="nav-item"><a href="portal_calendar.html" style="color: #cbd5e1;">일정 관리</a></li><li class="nav-item"><a href="portal_board.html" style="color: #cbd5e1;">게시판</a></li><li class="nav-item"><a href="portal_archive.html" style="color: #cbd5e1;">자료실</a></li><li><a href="index.html" style="border: 1px solid #cbd5e1; padding: 5px 15px; border-radius: 20px; color: #cbd5e1; margin-left: 15px;">홈페이지로</a></li></ul><div class="menu-toggle" id="mobile-menu"><span class="bar" style="background: white;"></span><span class="bar" style="background: white;"></span><span class="bar" style="background: white;"></span></div></div></nav><style>#navbar.scrolled { background: #0f172a !important; box-shadow: 0 4px 6px rgba(0,0,0,0.3); } .nav-links li a:hover { color: white !important; }</style>'
$calendarHTML = $calendarHTML -replace '<title>.*?\| \(주\)비에이텍</title>', "<title>사내 일정 관리 | (주)비에이텍</title>"
$calendarHTML = $calendarHTML -replace '<title>비에이텍 \(B.A. TECH\) - 워터펌프 시스템 전문 기업</title>', "<title>사내 일정 관리 | (주)비에이텍</title>"
[IO.File]::WriteAllText("portal_calendar.html", $calendarHTML, $utf8)


# --- 2. portal.html Dashboard Sync for v3 (Dynamic Dates) ---
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)

$portalJs = @'
        function loadDashScheds() {
            const ul = document.getElementById("dash-sched-list");
            let scheds = JSON.parse(localStorage.getItem("batech_scheds_v3") || "{}");
            
            if(Object.keys(scheds).length === 0) {
                scheds = {
                    "2026-06-01": [{title:"정례조회"}], "2026-06-04": [{title:"영업팀 회의"}], 
                    "2026-06-11": [{title:"기술팀 세미나"}], "2026-06-12": [{title:"워크숍 출발"}]
                };
            }
            
            let allEvents = [];
            for(let dateStr in scheds) {
                let d = new Date(dateStr);
                scheds[dateStr].forEach(e => {
                    allEvents.push({ date: d, dateStr: dateStr, title: e.title });
                });
            }
            
            let today = new Date();
            today.setHours(0,0,0,0);
            
            let upcoming = allEvents.filter(e => e.date >= today).sort((a,b) => a.date - b.date);
            if(upcoming.length === 0) upcoming = allEvents.sort((a,b) => a.date - b.date).slice(-4);
            
            ul.innerHTML = "";
            upcoming.slice(0, 4).forEach(e => {
                let dMonth = e.date.getMonth() + 1;
                let dDate = e.date.getDate();
                let isToday = (e.date.getTime() === today.getTime());
                let badge = isToday ? `<span class="badge new">오늘</span>` : `<span class="badge" style="background:#e0f2fe;color:#0284c7;">${dMonth}월 ${dDate}일</span>`;
                ul.innerHTML += `<li><a href="portal_calendar.html">${badge} ${e.title}</a></li>`;
            });
            if(ul.innerHTML === "") {
                ul.innerHTML = `<li><a href="portal_calendar.html">다가오는 일정이 없습니다.</a></li>`;
            }
        }
'@

$portalSrc = $portalSrc -replace '(?s)function loadDashScheds\(\) \{.*?(?=\s*document\.addEventListener)', "$portalJs`n"
[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)


