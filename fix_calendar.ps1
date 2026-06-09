$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("portal_calendar.html", $utf8)

$calendarContent = '
    <style>
        .page-header { background: #0f172a; padding: 60px 0; text-align: center; color: white; }
        .page-header h1 { font-size: 2.5rem; font-weight: 800; }
        .cal-container { max-width: 1000px; margin: 40px auto; background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .cal-controls { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; background: #f8fafc; padding: 20px; border-radius: 8px; border: 1px solid #e2e8f0; }
        .cal-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 2px; background: #cbd5e1; border: 1px solid #cbd5e1; border-radius: 8px; overflow: hidden; }
        .cal-header { background: #f1f5f9; font-weight: 700; font-size: 1rem; text-align: center; padding: 10px; color: #475569; }
        .cal-day { background: #fff; min-height: 100px; padding: 5px; font-size: 1rem; color: #334155; position: relative; }
        .cal-day.empty { background: #f8fafc; color: #cbd5e1; }
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
    </style>
    <div class="page-header">
        <h1>사내 일정 (6월)</h1>
        <p>전사 스케줄 및 개인 일정을 등록/관리하세요.</p>
    </div>
    <div class="container cal-container">
        <a href="portal.html" style="display:inline-block; margin-bottom:20px; color: var(--primary-color); font-weight: bold; text-decoration: none;">&larr; 대시보드로 돌아가기</a>
        
        <div class="cal-controls">
            <div>
                <h3 style="margin:0; color:#1e293b;">일정 캘린더</h3>
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
            <label class="form-label">날짜 선택 (6월)</label>
            <input type="number" id="add-sched-date" class="input-box" min="1" max="30" placeholder="예: 15">
        </div>
        <div class="form-group">
            <label class="form-label">일정 제목</label>
            <input type="text" id="add-sched-title" class="input-box" placeholder="일정 제목 입력">
        </div>
        <div class="form-group">
            <label class="form-label">메모 (상세내용)</label>
            <textarea id="add-sched-memo" class="input-box" style="height: 100px; resize: none;" placeholder="상세 일정을 메모하세요..."></textarea>
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
            <label class="form-label">일정 제목</label>
            <input type="text" id="edit-sched-title" class="input-box">
        </div>
        <div class="form-group">
            <label class="form-label">메모 (상세내용)</label>
            <textarea id="edit-sched-memo" class="input-box" style="height: 100px; resize: none;"></textarea>
        </div>
        <div style="text-align: right; display: flex; justify-content: space-between; align-items: center; gap: 10px;">
            <button class="btn-sm" style="background: #fee2e2; color: #991b1b;" onclick="deleteSchedule()">삭제</button>
            <div style="display: flex; gap: 10px;">
                <button class="btn-sm" onclick="document.getElementById(`edit-schedule-modal`).close()">닫기</button>
                <button class="btn-sm primary" onclick="saveEditSchedule()">변경 저장</button>
            </div>
        </div>
    </dialog>

    <script>
        function checkPassword(actionName) {
            const pwd = prompt(`일정을 ${actionName}하려면 암호(1234)를 입력하세요:`);
            if (pwd === "1234") return true;
            if (pwd !== null) alert("암호가 일치하지 않습니다.");
            return false;
        }

        function renderCalendar() {
            const grid = document.getElementById("full-calendar");
            grid.innerHTML = `<div class="cal-header">일</div><div class="cal-header">월</div><div class="cal-header">화</div><div class="cal-header">수</div><div class="cal-header">목</div><div class="cal-header">금</div><div class="cal-header">토</div><div class="cal-day empty">31</div>`;
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v2") || "{}");
            const hEvents = { 1: [{t:"정례조회", c:""}], 4: [{t:"영업팀 회의", c:"meeting"}], 11: [{t:"기술팀 세미나", c:"meeting"}], 12: [{t:"워크숍 출발", c:""}] };

            for(let i=1; i<=30; i++) {
                let eventsHTML = "";
                if(hEvents[i]) {
                    hEvents[i].forEach(e => { eventsHTML += `<div class="cal-event ${e.c}" onclick="alert(\`기본 일정은 수정/삭제할 수 없습니다.\\n\\n상세: ${e.t}\`)">${e.t}</div>`; });
                }
                if(customScheds[i]) {
                    customScheds[i].forEach((e, idx) => { 
                        // Encode string to prevent HTML breaking in function call
                        let t = encodeURIComponent(e.title);
                        let m = encodeURIComponent(e.memo || "");
                        eventsHTML += `<div class="cal-event custom" onclick="openEdit(${i}, ${idx}, \`${t}\`, \`${m}\`)">${e.title}</div>`; 
                    });
                }
                grid.innerHTML += `<div class="cal-day"><strong>${i}</strong>${eventsHTML}</div>`;
            }
        }

        function openAddModal() {
            document.getElementById("add-sched-date").value = "";
            document.getElementById("add-sched-title").value = "";
            document.getElementById("add-sched-memo").value = "";
            document.getElementById("add-schedule-modal").showModal();
        }

        function addSchedule() {
            const date = document.getElementById("add-sched-date").value;
            const title = document.getElementById("add-sched-title").value;
            const memo = document.getElementById("add-sched-memo").value;
            
            if(!date || !title) { alert("날짜와 제목을 모두 입력해주세요."); return; }
            if(date < 1 || date > 30) { alert("올바른 날짜를 입력하세요 (1~30)."); return; }
            
            if(!checkPassword("등록")) return;
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v2") || "{}");
            if(!customScheds[date]) customScheds[date] = [];
            customScheds[date].push({ title: title, memo: memo });
            localStorage.setItem("batech_scheds_v2", JSON.stringify(customScheds));
            
            renderCalendar();
            document.getElementById("add-schedule-modal").close();
            alert("일정이 성공적으로 등록되었습니다!");
        }

        function openEdit(date, idx, encodedTitle, encodedMemo) {
            document.getElementById("edit-orig-date").value = date;
            document.getElementById("edit-orig-idx").value = idx;
            document.getElementById("edit-sched-title").value = decodeURIComponent(encodedTitle);
            document.getElementById("edit-sched-memo").value = decodeURIComponent(encodedMemo);
            document.getElementById("edit-schedule-modal").showModal();
        }

        function saveEditSchedule() {
            if(!checkPassword("변경")) return;

            let d = document.getElementById("edit-orig-date").value;
            let idx = document.getElementById("edit-orig-idx").value;
            let nTitle = document.getElementById("edit-sched-title").value;
            let nMemo = document.getElementById("edit-sched-memo").value;
            
            if(!nTitle) return alert("제목을 입력하세요.");
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v2") || "{}");
            if(customScheds[d] && customScheds[d][idx] !== undefined) {
                customScheds[d][idx] = { title: nTitle, memo: nMemo };
                localStorage.setItem("batech_scheds_v2", JSON.stringify(customScheds));
                renderCalendar();
                document.getElementById("edit-schedule-modal").close();
                alert("일정이 수정되었습니다.");
            }
        }

        function deleteSchedule() {
            if(!checkPassword("삭제")) return;

            let d = document.getElementById("edit-orig-date").value;
            let idx = document.getElementById("edit-orig-idx").value;
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v2") || "{}");
            if(customScheds[d] && customScheds[d][idx] !== undefined) {
                customScheds[d].splice(idx, 1);
                localStorage.setItem("batech_scheds_v2", JSON.stringify(customScheds));
                renderCalendar();
                document.getElementById("edit-schedule-modal").close();
                alert("일정이 삭제되었습니다.");
            }
        }

        document.addEventListener("DOMContentLoaded", renderCalendar);
    </script>
'

$baseSrc = [IO.File]::ReadAllText("index.html", $utf8)
$calendarHTML = $baseSrc -replace '(?s)(</nav>).*?(<footer>)', "`$1`r`n$calendarContent`r`n`$2"
$calendarHTML = $calendarHTML -replace '(?s)<nav id="navbar">.*?</nav>', '<nav id="navbar" style="background: #0f172a;"><div class="nav-container"><a href="portal.html" class="logo" style="color: white;"><span class="logo-icon">💧</span> B.A. TECH 포털</a><ul class="nav-links"><li class="nav-item"><a href="portal.html" style="color: #cbd5e1;">대시보드</a></li><li class="nav-item"><a href="portal_notices.html" style="color: #cbd5e1;">공지사항</a></li><li class="nav-item"><a href="portal_calendar.html" style="color: #cbd5e1;">일정 관리</a></li><li class="nav-item"><a href="portal_board.html" style="color: #cbd5e1;">게시판</a></li><li class="nav-item"><a href="portal_archive.html" style="color: #cbd5e1;">자료실</a></li><li><a href="index.html" style="border: 1px solid #cbd5e1; padding: 5px 15px; border-radius: 20px; color: #cbd5e1; margin-left: 15px;">홈페이지로</a></li></ul><div class="menu-toggle" id="mobile-menu"><span class="bar" style="background: white;"></span><span class="bar" style="background: white;"></span><span class="bar" style="background: white;"></span></div></div></nav><style>#navbar.scrolled { background: #0f172a !important; box-shadow: 0 4px 6px rgba(0,0,0,0.3); } .nav-links li a:hover { color: white !important; }</style>'
$calendarHTML = $calendarHTML -replace '<title>.*?\| \(주\)비에이텍</title>', "<title>사내 일정 관리 | (주)비에이텍</title>"
$calendarHTML = $calendarHTML -replace '<title>비에이텍 \(B.A. TECH\) - 워터펌프 시스템 전문 기업</title>', "<title>사내 일정 관리 | (주)비에이텍</title>"
[IO.File]::WriteAllText("portal_calendar.html", $calendarHTML, $utf8)

# --- 2. Update portal.html for Dashboard Sync ---
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)
$portalSrc = $portalSrc -replace '(?s)function loadDashScheds\(\) \{.*?(?=\s*document\.addEventListener)', '
        function loadDashScheds() {
            const ul = document.getElementById("dash-sched-list");
            // Load from new V2 key which has objects instead of strings
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds_v2") || "{}");
            const hEvents = { 1: ["정례조회"], 4: ["영업팀 회의"], 11: ["기술팀 세미나"], 12: ["워크숍 출발"] };
            
            let allEvents = [];
            for(let i=1; i<=30; i++) {
                if(hEvents[i]) hEvents[i].forEach(e => allEvents.push({day: i, title: e}));
                if(customScheds[i]) customScheds[i].forEach(e => allEvents.push({day: i, title: e.title})); // e is now {title, memo}
            }
            
            // Assume today is 9th. Sort by day >= 9
            let upcoming = allEvents.filter(e => e.day >= 9).sort((a,b) => a.day - b.day);
            if(upcoming.length === 0) upcoming = allEvents.slice(-3);
            
            ul.innerHTML = "";
            upcoming.slice(0, 4).forEach(e => {
                let badge = e.day === 9 ? `<span class="badge new">오늘</span>` : `<span class="badge" style="background:#e0f2fe;color:#0284c7;">6월 ${e.day}일</span>`;
                ul.innerHTML += `<li><a href="portal_calendar.html">${badge} ${e.title}</a></li>`;
            });
            if(ul.innerHTML === "") {
                ul.innerHTML = `<li><a href="portal_calendar.html">다가오는 일정이 없습니다.</a></li>`;
            }
        }
'
[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)

