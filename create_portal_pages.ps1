$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("index.html", $utf8)

function BuildPage {
    param($title, $content)
    $baseSrc = $src -replace '(?s)(</nav>).*?(<footer>)', "`$1`r`n$content`r`n`$2"
    $baseSrc = $baseSrc -replace '<title>.*?\| \(주\)비에이텍</title>', "<title>$title</title>"
    $baseSrc = $baseSrc -replace '<title>비에이텍 \(B.A. TECH\) - 워터펌프 시스템 전문 기업</title>', "<title>$title</title>"
    return $baseSrc
}

# --- 1. portal.html (Main Dashboard) ---
$portalContent = '
    <style>
        .portal-layout { padding: 80px 0; background-color: #f8fafc; min-height: 100vh; }
        .portal-header { text-align: center; margin-bottom: 3rem; }
        .portal-header h1 { font-size: 2.5rem; color: #0f172a; margin-bottom: 0.5rem; font-weight: 800; }
        .portal-header p { color: #64748b; }
        .dashboard-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; max-width: 1200px; margin: 0 auto; padding: 0 1.5rem; }
        .dashboard-grid.bottom { grid-template-columns: 1fr 1fr 1fr; margin-top: 2rem; }
        .dashboard-grid.full { grid-template-columns: 1fr; margin-top: 2rem; }
        .panel { background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 1.5rem; border-top: 4px solid var(--primary-color); display: flex; flex-direction: column; }
        .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; border-bottom: 2px solid #f1f5f9; padding-bottom: 0.8rem; }
        .panel-title { font-size: 1.25rem; font-weight: 700; color: #1e293b; display: flex; align-items: center; gap: 0.5rem; }
        .btn-sm { padding: 0.4rem 0.8rem; border-radius: 6px; font-size: 0.85rem; cursor: pointer; border: none; background: #e2e8f0; color: #475569; font-weight: 600; transition: 0.2s; text-decoration: none; display: inline-block; }
        .btn-sm.primary { background: var(--primary-color); color: #fff; }
        .btn-sm:hover { filter: brightness(0.95); }
        .data-list { list-style: none; padding: 0; margin: 0; flex-grow: 1; }
        .data-list li { padding: 0.8rem 0; border-bottom: 1px dashed #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .data-list li:last-child { border-bottom: none; }
        .data-list a { color: #334155; font-weight: 500; transition: 0.2s; text-decoration: none; cursor: pointer; }
        .data-list a:hover { color: var(--primary-color); }
        .data-list .meta { font-size: 0.85rem; color: #94a3b8; }
        .data-list .badge { background: #fef08a; color: #854d0e; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.75rem; font-weight: 700; }
        .badge.new { background: #fecaca; color: #991b1b; }
        
        .data-table { width: 100%; border-collapse: collapse; font-size: 0.9rem; }
        .data-table th, .data-table td { padding: 0.8rem; text-align: left; border-bottom: 1px solid #e2e8f0; }
        .data-table th { background: #f8fafc; font-weight: 600; color: #475569; }
        .status-wait { color: #ea580c; font-weight: 600; background: #ffedd5; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.8rem; }
        .status-done { color: #16a34a; font-weight: 600; background: #dcfce7; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.8rem; }
        @media (max-width: 900px) { .dashboard-grid, .dashboard-grid.bottom { grid-template-columns: 1fr; } }
        dialog::backdrop { background: rgba(0,0,0,0.5); backdrop-filter: blur(2px); }
    </style>
    
    <div class="portal-layout">
        <div class="portal-header fade-in-up">
            <h1>사내 포털 대시보드</h1>
            <p>비에이텍 임직원 전용 업무 공간입니다. (보안 레벨: 내부용)</p>
        </div>

        <div class="dashboard-grid fade-in-up delay-1">
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">📢 사내 공지사항</div>
                    <a href="portal_notices.html" class="btn-sm">전체보기</a>
                </div>
                <ul class="data-list">
                    <li><a href="portal_notices.html"><span class="badge new">필독</span> 2026년 하반기 전사 워크숍 일정 안내</a> <span class="meta">2026.06.01</span></li>
                    <li><a href="portal_notices.html">급수 펌프 신제품(BT-900) 메뉴얼 배포</a> <span class="meta">2026.05.28</span></li>
                    <li><a href="portal_notices.html">6월 임직원 생일자 축하 안내</a> <span class="meta">2026.05.25</span></li>
                    <li><a href="portal_notices.html">사내 보안 점검 및 비밀번호 변경 캠페인</a> <span class="meta">2026.05.20</span></li>
                </ul>
            </div>

            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">📅 사내 일정 (6월)</div>
                    <a href="portal_calendar.html" class="btn-sm primary">일정 관리</a>
                </div>
                <div style="flex-grow: 1; display: flex; flex-direction: column; justify-content: center; align-items: center; background: #f1f5f9; border-radius: 8px; padding: 2rem; text-align: center;">
                    <div style="font-size: 3rem; margin-bottom: 1rem;">🗓️</div>
                    <p style="color: #64748b; font-weight: 500;">일정 등록 및 전체 캘린더 조회는<br>일정 관리 페이지에서 확인하세요.</p>
                </div>
            </div>
        </div>

        <div class="dashboard-grid bottom fade-in-up delay-2">
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">🗣️ 소통의 장 (익명)</div>
                    <a href="portal_board.html" class="btn-sm primary">전체보기 및 글쓰기</a>
                </div>
                <ul class="data-list" id="dash-board-list">
                    <li><a href="portal_board.html">게시판에서 확인하세요.</a></li>
                </ul>
            </div>

            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">📂 사내 자료실</div>
                    <a href="portal_archive.html" class="btn-sm primary">자료실 입장</a>
                </div>
                <ul class="data-list">
                    <li><a href="portal_archive.html">📄 연차/반차 휴가 신청서 양식</a> <span class="meta">인사팀</span></li>
                    <li><a href="portal_archive.html">📄 회사 공식 로고 파일 (AI, PNG)</a> <span class="meta">홍보팀</span></li>
                    <li><a href="portal_archive.html">📄 법인카드 지출 결의서 양식</a> <span class="meta">재무팀</span></li>
                </ul>
            </div>

            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">📌 개인 업무 관리</div>
                </div>
                <div style="display: flex; flex-direction: column; height: 100%;">
                    <div style="margin-bottom: 1rem;">
                        <textarea id="my-memo" style="width: 100%; height: 100px; padding: 10px; border: 1px solid #e2e8f0; border-radius: 8px; resize: none; background: #fef9c3;" placeholder="간단한 업무 메모를 남겨보세요..."></textarea>
                        <div style="text-align: right; margin-top: 5px;">
                            <button class="btn-sm" onclick="saveMemo()">저장</button>
                        </div>
                    </div>
                    <div style="border-top: 1px dashed #e2e8f0; padding-top: 1rem;">
                        <a href="#" onclick="alert(`인수인계 매뉴얼 문서를 다운로드 합니다.`);" style="display: block; text-decoration: none; color: #1e293b; background: #f8fafc; padding: 10px; border-radius: 8px; font-weight: 600; text-align: center; border: 1px solid #e2e8f0; transition: 0.2s;">
                            📁 인수인계 가이드라인 열람
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="dashboard-grid full fade-in-up delay-3">
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">✉️ 고객 문의 관리 (CS Dashboard)</div>
                    <button class="btn-sm" onclick="alert(`엑셀 파일로 다운로드 됩니다.`);">엑셀 다운로드</button>
                </div>
                <div style="overflow-x: auto;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>상태</th>
                                <th>접수일</th>
                                <th>고객명/회사명</th>
                                <th>문의 유형</th>
                                <th>제목</th>
                                <th>작업</th>
                            </tr>
                        </thead>
                        <tbody id="cs-table-body"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Reply Modal for CS Dashboard -->
    <dialog id="reply-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 500px; width: 100%;">
        <h3 style="margin-top: 0; margin-bottom: 1rem; color: #1e293b;">답글 작성 및 자동 메일 발송</h3>
        <p style="font-size: 0.9rem; color: #64748b; margin-bottom: 1.5rem;">작성 완료 시 고객의 이메일로 메일 발송 창이 열리며, 문의 상태가 완료 처리됩니다.</p>
        <div style="margin-bottom: 1rem; background: #f8fafc; padding: 1rem; border-radius: 8px;">
            <strong id="modal-customer" style="color: var(--primary-color);"></strong> 님의 문의:<br>
            <em id="modal-subject" style="color: #475569;"></em>
        </div>
        <textarea id="reply-content" style="width: 100%; height: 150px; padding: 10px; border: 1px solid #e2e8f0; border-radius: 8px; resize: none; margin-bottom: 1rem;" placeholder="답변 내용을 입력하세요..."></textarea>
        <div style="text-align: right; gap: 10px; display: flex; justify-content: flex-end;">
            <button class="btn-sm" onclick="document.getElementById(`reply-modal`).close()">취소</button>
            <button class="btn-sm primary" onclick="submitReply()">발송하기</button>
        </div>
    </dialog>

    <script>
        // CS Dashboard Logic
        let currentReplyId = null;

        function loadInquiries() {
            const tbody = document.getElementById("cs-table-body");
            tbody.innerHTML = "";
            let inquiries = JSON.parse(localStorage.getItem("batech_inquiries") || "[]");
            
            inquiries.forEach(inq => {
                const tr = document.createElement("tr");
                const statClass = inq.status === "wait" ? "status-wait" : "status-done";
                const statText = inq.status === "wait" ? "답변 대기" : "처리 완료";
                const btn = inq.status === "wait" 
                    ? `<button class="btn-sm primary" onclick="openReply(\`${inq.id}\`)">답글 작성</button>`
                    : `<button class="btn-sm" onclick="alert(\`완료된 문의 내용을 조회합니다.\`)">내역 보기</button>`;
                
                tr.innerHTML = `<td><span class="\${statClass}">\${statText}</span></td><td>\${inq.date}</td><td>\${inq.name} (\${inq.contact || `개인`})</td><td>\${inq.type}</td><td>\${inq.subject}</td><td>\${btn}</td>`;
                tbody.appendChild(tr);
            });

            tbody.innerHTML += `
                <tr><td><span class="status-wait">답변 대기</span></td><td>2026-06-08 14:20</td><td>김*민 (한국건설)</td><td>제품 문의</td><td>부스터 펌프 대용량 모델 견적 요청드립니다.</td><td><button class="btn-sm primary" onclick="alert(\`연동되지 않은 가상의 데이터입니다.\`)">답글 작성</button></td></tr>
                <tr><td><span class="status-done">처리 완료</span></td><td>2026-06-07 16:40</td><td>이*영 (개인)</td><td>기타 문의</td><td>펌프 소음 관련 매뉴얼 문의</td><td><button class="btn-sm" onclick="alert(\`완료된 가상 문의입니다.\`)">내역 보기</button></td></tr>
            `;
        }

        function openReply(id) {
            currentReplyId = id;
            let inquiries = JSON.parse(localStorage.getItem("batech_inquiries") || "[]");
            let inq = inquiries.find(i => i.id === id);
            if(inq) {
                document.getElementById("modal-customer").innerText = inq.name;
                document.getElementById("modal-subject").innerText = inq.subject;
                document.getElementById("reply-content").value = "";
                document.getElementById("reply-modal").showModal();
            }
        }

        function submitReply() {
            const content = document.getElementById("reply-content").value;
            if(!content) { alert("답변 내용을 입력해주세요."); return; }
            
            let inquiries = JSON.parse(localStorage.getItem("batech_inquiries") || "[]");
            let inq = inquiries.find(i => i.id === currentReplyId);
            if(inq) {
                inq.status = "done";
                localStorage.setItem("batech_inquiries", JSON.stringify(inquiries));
                alert("메일 발송 서버와 연동 중...");
                alert("고객에게 이메일이 발송되었습니다!");
                const mailto = `mailto:\${inq.email}?subject=Re: \${encodeURIComponent(inq.subject)}&body=\${encodeURIComponent(content)}`;
                window.location.href = mailto;
                document.getElementById("reply-modal").close();
                loadInquiries();
            }
        }

        function loadMemo() {
            const memo = localStorage.getItem("batech_memo") || "";
            document.getElementById("my-memo").value = memo;
        }

        function saveMemo() {
            const memo = document.getElementById("my-memo").value;
            localStorage.setItem("batech_memo", memo);
            alert("업무 메모가 저장되었습니다.");
        }
        
        function loadBoardPreview() {
            const ul = document.getElementById("dash-board-list");
            let posts = JSON.parse(localStorage.getItem("batech_board") || "[]");
            if(posts.length > 0) {
                ul.innerHTML = "";
                posts.slice(0, 4).forEach(p => {
                    ul.innerHTML += `<li><a href="portal_board.html">\${p.title}</a> <span class="meta">\${p.author}</span></li>`;
                });
            }
        }

        document.addEventListener("DOMContentLoaded", () => {
            loadInquiries();
            loadMemo();
            loadBoardPreview();
        });
    </script>
'
$portalHTML = BuildPage "사내 포털 대시보드 | (주)비에이텍" $portalContent
[IO.File]::WriteAllText("portal.html", $portalHTML, $utf8)

# --- 2. portal_notices.html ---
$noticesContent = '
    <style>
        .page-header { background: #0f172a; padding: 60px 0; text-align: center; color: white; }
        .page-header h1 { font-size: 2.5rem; font-weight: 800; }
        .notice-list { max-width: 800px; margin: 40px auto; list-style: none; padding: 0; }
        .notice-list li { border-bottom: 1px solid #e2e8f0; padding: 20px; display: flex; justify-content: space-between; align-items: center; transition: 0.2s; cursor: pointer; }
        .notice-list li:hover { background: #f8fafc; }
        .notice-list .title { font-size: 1.1rem; font-weight: 600; color: #1e293b; }
        .notice-list .meta { color: #64748b; font-size: 0.9rem; }
        .badge { background: #fecaca; color: #991b1b; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.75rem; font-weight: 700; margin-right: 10px; }
        .container { min-height: 50vh; }
    </style>
    <div class="page-header">
        <h1>사내 공지사항</h1>
        <p>사내 주요 소식 및 안내사항을 확인하세요.</p>
    </div>
    <div class="container">
        <a href="portal.html" style="display:inline-block; margin-top:20px; color: var(--primary-color); font-weight: bold; text-decoration: none;">&larr; 대시보드로 돌아가기</a>
        <ul class="notice-list">
            <li onclick="alert(`공지 상세내용입니다.`)"><div><span class="badge">필독</span><span class="title">2026년 하반기 전사 워크숍 일정 안내</span></div><span class="meta">2026.06.01</span></li>
            <li onclick="alert(`공지 상세내용입니다.`)"><div><span class="title">급수 펌프 신제품(BT-900) 메뉴얼 배포</span></div><span class="meta">2026.05.28</span></li>
            <li onclick="alert(`공지 상세내용입니다.`)"><div><span class="title">6월 임직원 생일자 축하 안내</span></div><span class="meta">2026.05.25</span></li>
            <li onclick="alert(`공지 상세내용입니다.`)"><div><span class="title">사내 보안 점검 및 비밀번호 변경 캠페인</span></div><span class="meta">2026.05.20</span></li>
            <li onclick="alert(`공지 상세내용입니다.`)"><div><span class="title">법정 의무 교육 이수 기한 안내</span></div><span class="meta">2026.05.15</span></li>
            <li onclick="alert(`공지 상세내용입니다.`)"><div><span class="title">5월 회식 장소 안내</span></div><span class="meta">2026.05.10</span></li>
            <li onclick="alert(`공지 상세내용입니다.`)"><div><span class="title">근로자의 날 휴무 안내</span></div><span class="meta">2026.04.28</span></li>
        </ul>
    </div>
'
$noticesHTML = BuildPage "사내 공지사항 | (주)비에이텍" $noticesContent
[IO.File]::WriteAllText("portal_notices.html", $noticesHTML, $utf8)

# --- 3. portal_calendar.html ---
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
        .cal-event { background: #dbeafe; color: #1e40af; font-size: 0.8rem; padding: 0.3rem 0.5rem; border-radius: 4px; margin-top: 0.3rem; cursor: pointer; font-weight: 500; }
        .cal-event.meeting { background: #fce7f3; color: #9d174d; }
        .cal-event.custom { background: #dcfce7; color: #166534; }
        .btn-primary { background: var(--primary-color); color: #fff; border: none; padding: 10px 20px; border-radius: 8px; font-weight: bold; cursor: pointer; }
        .input-box { padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; margin-right: 10px; }
    </style>
    <div class="page-header">
        <h1>사내 일정 (6월)</h1>
        <p>전사 스케줄 및 개인 일정을 등록/관리하세요.</p>
    </div>
    <div class="container cal-container">
        <a href="portal.html" style="display:inline-block; margin-bottom:20px; color: var(--primary-color); font-weight: bold; text-decoration: none;">&larr; 대시보드로 돌아가기</a>
        
        <div class="cal-controls">
            <div>
                <h3 style="margin:0; color:#1e293b;">새 일정 등록</h3>
            </div>
            <div>
                <input type="number" id="sched-date" class="input-box" min="1" max="30" placeholder="6월 일자 (예: 15)">
                <input type="text" id="sched-title" class="input-box" placeholder="일정 제목 입력" style="width: 250px;">
                <button class="btn-primary" onclick="addSchedule()">등록하기</button>
            </div>
        </div>

        <div class="cal-grid" id="full-calendar"></div>
    </div>

    <script>
        function renderCalendar() {
            const grid = document.getElementById("full-calendar");
            grid.innerHTML = `<div class="cal-header">일</div><div class="cal-header">월</div><div class="cal-header">화</div><div class="cal-header">수</div><div class="cal-header">목</div><div class="cal-header">금</div><div class="cal-header">토</div><div class="cal-day empty">31</div>`;
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds") || "{}");
            const hEvents = {
                1: [{t:"정례조회", c:""}],
                4: [{t:"영업팀 회의", c:"meeting"}],
                11: [{t:"기술팀 세미나", c:"meeting"}],
                12: [{t:"워크숍 출발", c:""}]
            };

            for(let i=1; i<=30; i++) {
                let eventsHTML = "";
                if(hEvents[i]) {
                    hEvents[i].forEach(e => { eventsHTML += `<div class="cal-event \${e.c}" onclick="alert(\`일정 확인: \${e.t}\`)">\${e.t}</div>`; });
                }
                if(customScheds[i]) {
                    customScheds[i].forEach(e => { eventsHTML += `<div class="cal-event custom" onclick="alert(\`직접 등록한 일정: \${e}\`)">\${e}</div>`; });
                }
                grid.innerHTML += `<div class="cal-day"><strong>\${i}</strong>\${eventsHTML}</div>`;
            }
        }

        function addSchedule() {
            const date = document.getElementById("sched-date").value;
            const title = document.getElementById("sched-title").value;
            if(!date || !title) { alert("날짜와 제목을 모두 입력해주세요."); return; }
            if(date < 1 || date > 30) { alert("올바른 날짜를 입력하세요 (1~30)."); return; }
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds") || "{}");
            if(!customScheds[date]) customScheds[date] = [];
            customScheds[date].push(title);
            localStorage.setItem("batech_scheds", JSON.stringify(customScheds));
            
            alert(date + "일에 일정이 등록되었습니다!");
            renderCalendar();
            document.getElementById("sched-date").value = "";
            document.getElementById("sched-title").value = "";
        }

        document.addEventListener("DOMContentLoaded", renderCalendar);
    </script>
'
$calendarHTML = BuildPage "사내 일정 관리 | (주)비에이텍" $calendarContent
[IO.File]::WriteAllText("portal_calendar.html", $calendarHTML, $utf8)

# --- 4. portal_board.html ---
$boardContent = '
    <style>
        .page-header { background: #0f172a; padding: 60px 0; text-align: center; color: white; }
        .page-header h1 { font-size: 2.5rem; font-weight: 800; }
        .board-container { max-width: 800px; margin: 40px auto; }
        .board-controls { background: #f8fafc; padding: 20px; border-radius: 12px; margin-bottom: 30px; display: flex; gap: 10px; border: 1px solid #e2e8f0; }
        .input-box { flex-grow: 1; padding: 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 1rem; }
        .btn-primary { background: var(--primary-color); color: #fff; border: none; padding: 12px 25px; border-radius: 8px; font-weight: bold; cursor: pointer; white-space: nowrap; }
        .board-list { list-style: none; padding: 0; margin: 0; }
        .board-list li { background: #fff; padding: 20px; border-radius: 8px; margin-bottom: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border-left: 4px solid var(--secondary-color); }
        .board-list .title { font-size: 1.1rem; font-weight: 600; color: #1e293b; margin-bottom: 5px; cursor: pointer; }
        .board-list .meta { font-size: 0.85rem; color: #64748b; }
    </style>
    <div class="page-header">
        <h1>소통의 장 (익명 게시판)</h1>
        <p>자유롭게 의견을 나누는 공간입니다. (모든 글은 철저히 익명으로 보호됩니다)</p>
    </div>
    <div class="container board-container" style="min-height: 50vh;">
        <a href="portal.html" style="display:inline-block; margin-bottom:20px; color: var(--primary-color); font-weight: bold; text-decoration: none;">&larr; 대시보드로 돌아가기</a>
        
        <div class="board-controls">
            <input type="text" id="new-post-title" class="input-box" placeholder="여기에 익명 글 제목을 작성하고 등록을 누르세요.">
            <button class="btn-primary" onclick="addPost()">등록하기</button>
        </div>

        <ul class="board-list" id="posts-container"></ul>
    </div>

    <script>
        const defaultPosts = [
            {title: "휴게실 커피 머신 원두 종류 좀 늘려주세요...", author: "익명"},
            {title: "회식 장소 추천 받습니다! (강원도 지역)", author: "익명"},
            {title: "요즘 날씨가 너무 덥네요 다들 화이팅입니다.", author: "익명"},
            {title: "이번 워크숍 장소 너무 기대됩니다ㅎㅎ", author: "익명"}
        ];

        function renderPosts() {
            const container = document.getElementById("posts-container");
            container.innerHTML = "";
            let posts = JSON.parse(localStorage.getItem("batech_board") || "[]");
            
            // Render user posts first
            posts.forEach(p => {
                container.innerHTML += `<li><div class="title" onclick="alert(\`게시물 상세 내용은 준비중입니다.\`)">\${p.title}</div><div class="meta">\${p.author}</div></li>`;
            });
            // Render default posts
            defaultPosts.forEach(p => {
                container.innerHTML += `<li><div class="title" onclick="alert(\`게시물 상세 내용은 준비중입니다.\`)">\${p.title}</div><div class="meta">\${p.author}</div></li>`;
            });
        }

        function addPost() {
            const title = document.getElementById("new-post-title").value;
            if(!title) { alert("글 내용을 입력해주세요."); return; }
            
            let posts = JSON.parse(localStorage.getItem("batech_board") || "[]");
            posts.unshift({ title: title, author: "익명 (방금 전)" });
            localStorage.setItem("batech_board", JSON.stringify(posts));
            
            document.getElementById("new-post-title").value = "";
            renderPosts();
            alert("게시글이 등록되었습니다.");
        }

        document.addEventListener("DOMContentLoaded", renderPosts);
    </script>
'
$boardHTML = BuildPage "익명 게시판 | (주)비에이텍" $boardContent
[IO.File]::WriteAllText("portal_board.html", $boardHTML, $utf8)

# --- 5. portal_archive.html ---
$archiveContent = '
    <style>
        .page-header { background: #0f172a; padding: 60px 0; text-align: center; color: white; }
        .page-header h1 { font-size: 2.5rem; font-weight: 800; }
        .archive-container { max-width: 900px; margin: 40px auto; min-height: 50vh; }
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .btn-primary { background: var(--primary-color); color: #fff; border: none; padding: 10px 20px; border-radius: 8px; font-weight: bold; cursor: pointer; }
        .archive-list { width: 100%; border-collapse: collapse; }
        .archive-list th, .archive-list td { padding: 15px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        .archive-list th { background: #f8fafc; font-weight: 700; color: #475569; }
        .archive-list tr:hover td { background: #f1f5f9; cursor: pointer; }
        .file-icon { font-size: 1.2rem; margin-right: 10px; }
        .nb-highlight { background: #eff6ff; border-left: 4px solid #3b82f6; }
    </style>
    <div class="page-header">
        <h1>사내 자료실</h1>
        <p>각종 서식, 매뉴얼, 교육 자료를 다운로드 할 수 있습니다.</p>
    </div>
    <div class="container archive-container">
        <div class="toolbar">
            <a href="portal.html" style="color: var(--primary-color); font-weight: bold; text-decoration: none;">&larr; 대시보드로 돌아가기</a>
            <button class="btn-primary" onclick="tryUpload()">+ 자료 업로드</button>
        </div>

        <table class="archive-list">
            <thead>
                <tr>
                    <th>파일명</th>
                    <th>분류</th>
                    <th>부서</th>
                    <th>등록일</th>
                </tr>
            </thead>
            <tbody>
                <tr class="nb-highlight" onclick="alert(\`[NotebookLM 활용법 카드뉴스] 파일이 열립니다.\`);">
                    <td><span class="file-icon">📙</span><strong>[추천] NotebookLM 업무 활용법 카드뉴스</strong></td>
                    <td>교육자료</td>
                    <td>전략기획팀</td>
                    <td>2026.06.09</td>
                </tr>
                <tr onclick="alert(\`파일 다운로드 시작\`);">
                    <td><span class="file-icon">📄</span>연차/반차 휴가 신청서 양식 (2026 갱신)</td>
                    <td>서식</td>
                    <td>인사팀</td>
                    <td>2026.01.10</td>
                </tr>
                <tr onclick="alert(\`파일 다운로드 시작\`);">
                    <td><span class="file-icon">🖼️</span>회사 공식 로고 원본 파일 (AI, PNG, JPG)</td>
                    <td>디자인</td>
                    <td>홍보팀</td>
                    <td>2026.01.05</td>
                </tr>
                <tr onclick="alert(\`파일 다운로드 시작\`);">
                    <td><span class="file-icon">📄</span>법인카드 지출 결의서 양식 및 매뉴얼</td>
                    <td>서식</td>
                    <td>재무팀</td>
                    <td>2025.12.20</td>
                </tr>
                <tr onclick="alert(\`파일 다운로드 시작\`);">
                    <td><span class="file-icon">📗</span>2026년도 취업규칙 개정안 전문</td>
                    <td>규정</td>
                    <td>인사팀</td>
                    <td>2025.12.15</td>
                </tr>
            </tbody>
        </table>
    </div>

    <script>
        function tryUpload() {
            const pwd = prompt("자료를 업로드하려면 관리자 암호를 입력하세요:");
            if (pwd === "1234") {
                alert("인증 성공! 자료 업로드 팝업이 열립니다.");
            } else if (pwd !== null) {
                alert("비밀번호가 일치하지 않습니다. 업로드 권한이 없습니다.");
            }
        }
    </script>
'
$archiveHTML = BuildPage "사내 자료실 | (주)비에이텍" $archiveContent
[IO.File]::WriteAllText("portal_archive.html", $archiveHTML, $utf8)

