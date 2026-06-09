$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("index.html", $utf8)

$customNav = '
<nav id="navbar" style="background: #0f172a;">
    <div class="nav-container">
        <a href="portal.html" class="logo" style="color: white;"><span class="logo-icon">💧</span> B.A. TECH 포털</a>
        <ul class="nav-links">
            <li class="nav-item"><a href="portal.html" style="color: #cbd5e1;">대시보드</a></li>
            <li class="nav-item"><a href="portal_notices.html" style="color: #cbd5e1;">공지사항</a></li>
            <li class="nav-item"><a href="portal_calendar.html" style="color: #cbd5e1;">일정 관리</a></li>
            <li class="nav-item"><a href="portal_board.html" style="color: #cbd5e1;">게시판</a></li>
            <li class="nav-item"><a href="portal_archive.html" style="color: #cbd5e1;">자료실</a></li>
            <li><a href="index.html" style="border: 1px solid #cbd5e1; padding: 5px 15px; border-radius: 20px; color: #cbd5e1; margin-left: 15px;">홈페이지로</a></li>
        </ul>
        <div class="menu-toggle" id="mobile-menu"><span class="bar" style="background: white;"></span><span class="bar" style="background: white;"></span><span class="bar" style="background: white;"></span></div>
    </div>
</nav>
<style>
#navbar.scrolled { background: #0f172a !important; box-shadow: 0 4px 6px rgba(0,0,0,0.3); }
.nav-links li a:hover { color: white !important; }
</style>
'

function BuildPage {
    param($title, $content)
    $baseSrc = $src -replace '(?s)(</nav>).*?(<footer>)', "`$1`r`n$content`r`n`$2"
    $baseSrc = $baseSrc -replace '(?s)<nav id="navbar">.*?</nav>', $customNav
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
        .data-list .badge { background: #fef08a; color: #854d0e; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.75rem; font-weight: 700; margin-right: 5px;}
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
                    <li><a href="portal_notices.html">2026년 근로자의 날 휴무 안내</a> <span class="meta">2026.04.28</span></li>
                    <li><a href="portal_notices.html">2026년 설날 연휴 휴무 안내</a> <span class="meta">2026.02.10</span></li>
                    <li><a href="portal_notices.html">2025년 크리스마스 휴무 안내</a> <span class="meta">2025.12.20</span></li>
                </ul>
            </div>

            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">📅 사내 일정 요약 (6월)</div>
                    <a href="portal_calendar.html" class="btn-sm primary">일정 관리</a>
                </div>
                <ul class="data-list" id="dash-sched-list" style="padding-top: 10px;"></ul>
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
                    <li><a href="portal_archive.html">📙 NotebookLM 업무 활용법 카드뉴스</a> <span class="meta">전략기획팀</span></li>
                    <li><a href="portal_archive.html">📄 연차/반차 휴가 신청서 양식</a> <span class="meta">인사팀</span></li>
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
                
                tr.innerHTML = `<td><span class="${statClass}">${statText}</span></td><td>${inq.date}</td><td>${inq.name} (${inq.contact || `개인`})</td><td>${inq.type}</td><td>${inq.subject}</td><td>${btn}</td>`;
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
                const mailto = `mailto:${inq.email}?subject=Re: ${encodeURIComponent(inq.subject)}&body=${encodeURIComponent(content)}`;
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
                    ul.innerHTML += `<li><a href="portal_board.html">${p.title}</a> <span class="meta">${p.author}</span></li>`;
                });
            } else {
                ul.innerHTML = `<li><a href="portal_board.html">아직 등록된 게시물이 없습니다. 첫 글을 작성해 보세요.</a></li>`;
            }
        }
        
        function loadDashScheds() {
            const ul = document.getElementById("dash-sched-list");
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds") || "{}");
            const hEvents = { 1: ["정례조회"], 4: ["영업팀 회의"], 11: ["기술팀 세미나"], 12: ["워크숍 출발"] };
            
            let allEvents = [];
            for(let i=1; i<=30; i++) {
                if(hEvents[i]) hEvents[i].forEach(e => allEvents.push({day: i, title: e}));
                if(customScheds[i]) customScheds[i].forEach(e => allEvents.push({day: i, title: e}));
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

        document.addEventListener("DOMContentLoaded", () => {
            loadInquiries();
            loadMemo();
            loadBoardPreview();
            loadDashScheds();
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
        .notice-list .title { font-size: 1.1rem; font-weight: 600; color: #1e293b; flex-grow: 1; }
        .notice-list .meta { color: #64748b; font-size: 0.9rem; min-width: 150px; text-align: right; }
        .badge { background: #fecaca; color: #991b1b; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.75rem; font-weight: 700; margin-right: 10px; }
        .container { min-height: 50vh; }
        dialog::backdrop { background: rgba(0,0,0,0.5); backdrop-filter: blur(2px); }
        .btn-sm { padding: 0.4rem 0.8rem; border-radius: 6px; font-size: 0.85rem; cursor: pointer; border: none; background: #e2e8f0; color: #475569; font-weight: 600; transition: 0.2s; text-decoration: none; display: inline-block; }
        .btn-sm.primary { background: var(--primary-color); color: #fff; }
    </style>
    <div class="page-header">
        <h1>사내 공지사항</h1>
        <p>사내 주요 소식 및 안내사항을 확인하세요.</p>
    </div>
    <div class="container">
        <a href="portal.html" style="display:inline-block; margin-top:20px; color: var(--primary-color); font-weight: bold; text-decoration: none;">&larr; 대시보드로 돌아가기</a>
        <ul class="notice-list">
            <li onclick="openNotice(`2026년 근로자의 날 휴무 안내`, `2026.04.28`)">
                <div class="title">2026년 근로자의 날 휴무 안내</div>
                <div class="meta"><span>👁️ 152</span> &nbsp;|&nbsp; 2026.04.28</div>
            </li>
            <li onclick="openNotice(`2026년 설날 연휴 휴무 안내`, `2026.02.10`)">
                <div class="title">2026년 설날 연휴 휴무 안내</div>
                <div class="meta"><span>👁️ 304</span> &nbsp;|&nbsp; 2026.02.10</div>
            </li>
            <li onclick="openNotice(`2025년 크리스마스 휴무 안내`, `2025.12.20`)">
                <div class="title">2025년 크리스마스 휴무 안내</div>
                <div class="meta"><span>👁️ 280</span> &nbsp;|&nbsp; 2025.12.20</div>
            </li>
            <li onclick="openNotice(`2025년 광복절 연휴 및 대체휴무 안내`, `2025.08.10`)">
                <div class="title">2025년 광복절 연휴 및 대체휴무 안내</div>
                <div class="meta"><span>👁️ 411</span> &nbsp;|&nbsp; 2025.08.10</div>
            </li>
        </ul>
    </div>

    <!-- Notice Detail Modal -->
    <dialog id="notice-detail" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 600px; width: 100%;">
        <h2 id="nd-title" style="margin-top: 0; margin-bottom: 0.5rem; color: #1e293b; font-size: 1.5rem;"></h2>
        <div style="font-size: 0.85rem; color: #64748b; margin-bottom: 1.5rem; border-bottom: 1px solid #e2e8f0; padding-bottom: 1rem;">
            작성자: 경영지원팀 &nbsp;|&nbsp; 등록일: <span id="nd-date"></span>
        </div>
        <div id="nd-body" style="font-size: 1rem; color: #334155; line-height: 1.6; margin-bottom: 2rem; white-space: pre-wrap; min-height: 150px;">
        </div>
        <div style="text-align: right;">
            <button class="btn-sm primary" onclick="document.getElementById(`notice-detail`).close()">닫기</button>
        </div>
    </dialog>

    <script>
        function openNotice(title, date) {
            document.getElementById("nd-title").innerText = title;
            document.getElementById("nd-date").innerText = date;
            
            // Fake body content
            const body = "안녕하십니까, 경영지원팀입니다.\n\n" + title + "에 따른 회사의 전사 휴무 일정을 아래와 같이 안내해 드립니다.\n\n- 대상: 전 임직원\n- 비상 연락망은 사내 포털 자료실의 연락망을 참고해 주시기 바랍니다.\n\n임직원 여러분의 편안한 휴식을 기원합니다.\n감사합니다.";
            document.getElementById("nd-body").innerText = body;
            
            document.getElementById("notice-detail").showModal();
        }
    </script>
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
        .cal-event { background: #dbeafe; color: #1e40af; font-size: 0.8rem; padding: 0.3rem 0.5rem; border-radius: 4px; margin-top: 0.3rem; cursor: pointer; font-weight: 500; transition: filter 0.2s; }
        .cal-event:hover { filter: brightness(0.9); }
        .cal-event.meeting { background: #fce7f3; color: #9d174d; }
        .cal-event.custom { background: #dcfce7; color: #166534; }
        .btn-primary { background: var(--primary-color); color: #fff; border: none; padding: 10px 20px; border-radius: 8px; font-weight: bold; cursor: pointer; }
        .input-box { padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; margin-right: 10px; }
        .btn-sm { padding: 0.4rem 0.8rem; border-radius: 6px; font-size: 0.85rem; cursor: pointer; border: none; background: #e2e8f0; color: #475569; font-weight: 600; }
        .btn-sm.primary { background: var(--primary-color); color: #fff; }
        dialog::backdrop { background: rgba(0,0,0,0.5); backdrop-filter: blur(2px); }
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

    <dialog id="edit-schedule-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 400px; width: 100%;">
        <h3 style="margin-top: 0; margin-bottom: 1.5rem; color: #1e293b;">일정 상세 / 수정</h3>
        <input type="hidden" id="edit-orig-date">
        <input type="hidden" id="edit-orig-idx">
        <input type="text" id="edit-sched-title" class="input-box" style="width: 100%; margin-bottom: 15px;" placeholder="일정 제목">
        <div style="text-align: right; display: flex; justify-content: space-between; align-items: center; gap: 10px;">
            <button class="btn-sm" style="background: #fee2e2; color: #991b1b;" onclick="deleteSchedule()">삭제</button>
            <div style="display: flex; gap: 10px;">
                <button class="btn-sm" onclick="document.getElementById(`edit-schedule-modal`).close()">취소</button>
                <button class="btn-sm primary" onclick="saveEditSchedule()">변경 저장</button>
            </div>
        </div>
    </dialog>

    <script>
        function renderCalendar() {
            const grid = document.getElementById("full-calendar");
            grid.innerHTML = `<div class="cal-header">일</div><div class="cal-header">월</div><div class="cal-header">화</div><div class="cal-header">수</div><div class="cal-header">목</div><div class="cal-header">금</div><div class="cal-header">토</div><div class="cal-day empty">31</div>`;
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds") || "{}");
            const hEvents = { 1: [{t:"정례조회", c:""}], 4: [{t:"영업팀 회의", c:"meeting"}], 11: [{t:"기술팀 세미나", c:"meeting"}], 12: [{t:"워크숍 출발", c:""}] };

            for(let i=1; i<=30; i++) {
                let eventsHTML = "";
                if(hEvents[i]) {
                    hEvents[i].forEach(e => { eventsHTML += `<div class="cal-event ${e.c}" onclick="alert(\`기본 일정은 수정/삭제할 수 없습니다.\\n\\n상세: ${e.t}\`)">${e.t}</div>`; });
                }
                if(customScheds[i]) {
                    customScheds[i].forEach((e, idx) => { eventsHTML += `<div class="cal-event custom" onclick="openEdit(${i}, ${idx}, \`${e}\`)">${e}</div>`; });
                }
                grid.innerHTML += `<div class="cal-day"><strong>${i}</strong>${eventsHTML}</div>`;
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
            
            renderCalendar();
            document.getElementById("sched-date").value = "";
            document.getElementById("sched-title").value = "";
        }

        function openEdit(date, idx, title) {
            document.getElementById("edit-orig-date").value = date;
            document.getElementById("edit-orig-idx").value = idx;
            document.getElementById("edit-sched-title").value = title;
            document.getElementById("edit-schedule-modal").showModal();
        }

        function saveEditSchedule() {
            let d = document.getElementById("edit-orig-date").value;
            let idx = document.getElementById("edit-orig-idx").value;
            let nTitle = document.getElementById("edit-sched-title").value;
            if(!nTitle) return alert("제목을 입력하세요.");
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds") || "{}");
            if(customScheds[d] && customScheds[d][idx] !== undefined) {
                customScheds[d][idx] = nTitle;
                localStorage.setItem("batech_scheds", JSON.stringify(customScheds));
                renderCalendar();
                document.getElementById("edit-schedule-modal").close();
            }
        }

        function deleteSchedule() {
            if(!confirm("이 일정을 삭제하시겠습니까?")) return;
            let d = document.getElementById("edit-orig-date").value;
            let idx = document.getElementById("edit-orig-idx").value;
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds") || "{}");
            if(customScheds[d] && customScheds[d][idx] !== undefined) {
                customScheds[d].splice(idx, 1);
                localStorage.setItem("batech_scheds", JSON.stringify(customScheds));
                renderCalendar();
                document.getElementById("edit-schedule-modal").close();
            }
        }

        document.addEventListener("DOMContentLoaded", renderCalendar);
    </script>
'
$calendarHTML = BuildPage "사내 일정 관리 | (주)비에이텍" $calendarContent
[IO.File]::WriteAllText("portal_calendar.html", $calendarHTML, $utf8)

# --- 4. portal_archive.html ---
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
        dialog::backdrop { background: rgba(0,0,0,0.7); backdrop-filter: blur(3px); }
        .btn-sm { padding: 0.4rem 0.8rem; border-radius: 6px; font-size: 0.85rem; cursor: pointer; border: none; background: #e2e8f0; color: #475569; font-weight: 600; transition: 0.2s; }
        .btn-sm.primary { background: var(--primary-color); color: #fff; }
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
                <tr class="nb-highlight" onclick="document.getElementById(`nb-modal`).showModal();">
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
            </tbody>
        </table>
    </div>

    <!-- NotebookLM Modal Viewer -->
    <dialog id="nb-modal" style="border: none; border-radius: 12px; padding: 0; box-shadow: 0 10px 40px rgba(0,0,0,0.5); max-width: 900px; width: 95%; height: 90vh; overflow: hidden;">
        <div style="background: #0f172a; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; color: white;">
            <h3 style="margin: 0; font-size: 1.2rem;">📙 NotebookLM 업무 활용법</h3>
            <button class="btn-sm" style="background: rgba(255,255,255,0.2); color: white;" onclick="document.getElementById(`nb-modal`).close()">닫기 ✖</button>
        </div>
        <iframe src="notebooklm_cardnews.html" style="width: 100%; height: calc(100% - 60px); border: none;"></iframe>
    </dialog>

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

