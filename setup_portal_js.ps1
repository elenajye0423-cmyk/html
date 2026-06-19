$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("index.html", $utf8)

$dashboardContent = '
    <style>
        .portal-layout { padding: 100px 0; background-color: #f8fafc; min-height: 100vh; }
        .portal-header { text-align: center; margin-bottom: 3rem; }
        .portal-header h1 { font-size: 2.5rem; color: #0f172a; margin-bottom: 0.5rem; font-weight: 800; }
        .portal-header p { color: #64748b; }
        .dashboard-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; max-width: 1200px; margin: 0 auto; padding: 0 1.5rem; }
        .dashboard-grid.bottom { grid-template-columns: 1fr 1fr 1fr; margin-top: 2rem; }
        .dashboard-grid.full { grid-template-columns: 1fr; margin-top: 2rem; }
        .panel { background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 1.5rem; border-top: 4px solid var(--primary-color); }
        .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; border-bottom: 2px solid #f1f5f9; padding-bottom: 0.8rem; }
        .panel-title { font-size: 1.25rem; font-weight: 700; color: #1e293b; display: flex; align-items: center; gap: 0.5rem; }
        .btn-sm { padding: 0.4rem 0.8rem; border-radius: 6px; font-size: 0.85rem; cursor: pointer; border: none; background: #e2e8f0; color: #475569; font-weight: 600; transition: 0.2s; }
        .btn-sm.primary { background: var(--primary-color); color: #fff; }
        .btn-sm:hover { filter: brightness(0.95); }
        .data-list { list-style: none; padding: 0; margin: 0; }
        .data-list li { padding: 0.8rem 0; border-bottom: 1px dashed #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .data-list li:last-child { border-bottom: none; }
        .data-list a { color: #334155; font-weight: 500; transition: 0.2s; text-decoration: none; cursor: pointer; }
        .data-list a:hover { color: var(--primary-color); }
        .data-list .meta { font-size: 0.85rem; color: #94a3b8; }
        .data-list .badge { background: #fef08a; color: #854d0e; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.75rem; font-weight: 700; }
        .badge.new { background: #fecaca; color: #991b1b; }
        .cal-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 2px; background: #e2e8f0; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; }
        .cal-header { background: #f8fafc; font-weight: 700; font-size: 0.8rem; text-align: center; padding: 0.5rem; color: #64748b; }
        .cal-day { background: #fff; height: 60px; padding: 0.3rem; font-size: 0.85rem; color: #334155; position: relative; }
        .cal-day.empty { background: #f8fafc; color: #cbd5e1; }
        .cal-event { background: #dbeafe; color: #1e40af; font-size: 0.7rem; padding: 0.15rem 0.3rem; border-radius: 3px; margin-top: 0.2rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; cursor: pointer; }
        .cal-event.meeting { background: #fce7f3; color: #9d174d; }
        .cal-event.custom { background: #dcfce7; color: #166534; }
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
                    <button class="btn-sm" onclick="document.getElementById(`notice-modal`).showModal()">전체보기</button>
                </div>
                <ul class="data-list">
                    <li><a onclick="alert(`공지 상세 내용 열람`);"><span class="badge new">필독</span> 2026년 하반기 전사 워크숍 일정 안내</a> <span class="meta">2026.06.01</span></li>
                    <li><a onclick="alert(`공지 상세 내용 열람`);">급수 펌프 신제품(BT-900) 메뉴얼 배포</a> <span class="meta">2026.05.28</span></li>
                    <li><a onclick="alert(`공지 상세 내용 열람`);">6월 임직원 생일자 축하 안내</a> <span class="meta">2026.05.25</span></li>
                    <li><a onclick="alert(`공지 상세 내용 열람`);">사내 보안 점검 및 비밀번호 변경 캠페인</a> <span class="meta">2026.05.20</span></li>
                    <li><a onclick="alert(`공지 상세 내용 열람`);">법정 의무 교육 이수 기한 안내</a> <span class="meta">2026.05.15</span></li>
                </ul>
            </div>

            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">📅 사내 일정 (6월)</div>
                    <button class="btn-sm" onclick="document.getElementById(`schedule-modal`).showModal()">일정 등록</button>
                </div>
                <div class="cal-grid" id="calendar-grid">
                    <div class="cal-header">일</div><div class="cal-header">월</div><div class="cal-header">화</div><div class="cal-header">수</div><div class="cal-header">목</div><div class="cal-header">금</div><div class="cal-header">토</div>
                </div>
                <p style="text-align: right; font-size: 0.8rem; color: #94a3b8; margin-top: 0.5rem; margin-bottom: 0;">※ 상세 일정은 클릭하여 확인하세요.</p>
            </div>
        </div>

        <div class="dashboard-grid bottom fade-in-up delay-2">
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">🗣️ 소통의 장 (익명)</div>
                    <button class="btn-sm primary" onclick="document.getElementById(`board-modal`).showModal()">글쓰기</button>
                </div>
                <ul class="data-list" id="board-list">
                    <li><a onclick="alert(`게시물 상세 내용을 조회합니다.`);">휴게실 커피 머신 원두 종류 좀...</a> <span class="meta">익명</span></li>
                    <li><a onclick="alert(`게시물 상세 내용을 조회합니다.`);">회식 장소 추천 받습니다!</a> <span class="meta">익명</span></li>
                    <li><a onclick="alert(`게시물 상세 내용을 조회합니다.`);">요즘 날씨가 너무 덥네요 다들 화이팅</a> <span class="meta">익명</span></li>
                    <li><a onclick="alert(`게시물 상세 내용을 조회합니다.`);">이번 워크숍 장소 너무 기대됩니다ㅎㅎ</a> <span class="meta">익명</span></li>
                </ul>
            </div>

            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">📂 사내 자료실</div>
                    <button class="btn-sm" onclick="alert(`파일 업로드 권한이 없습니다.`);">자료 업로드</button>
                </div>
                <ul class="data-list">
                    <li><a onclick="alert(`파일이 다운로드 됩니다.`);">📄 연차/반차 휴가 신청서 양식</a> <span class="meta">인사팀</span></li>
                    <li><a onclick="alert(`파일이 다운로드 됩니다.`);">📄 회사 공식 로고 파일 (AI, PNG)</a> <span class="meta">홍보팀</span></li>
                    <li><a onclick="alert(`파일이 다운로드 됩니다.`);">📄 법인카드 지출 결의서 양식</a> <span class="meta">재무팀</span></li>
                    <li><a onclick="alert(`파일이 다운로드 됩니다.`);">📄 2026년도 취업규칙 개정안</a> <span class="meta">인사팀</span></li>
                </ul>
            </div>

            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">🔔 나의 알림 및 결재</div>
                </div>
                <ul class="data-list">
                    <li><a href="#">[결재 대기] 6월 기술팀 비품 구매 기안</a> <span class="meta" style="color: #ea580c; font-weight: 700;">1건</span></li>
                    <li><a href="#">[결재 대기] 외근 교통비 청구의 건</a> <span class="meta" style="color: #ea580c; font-weight: 700;">1건</span></li>
                    <li><a href="#">[수신함] 안전보건교육 이수증 제출 요청</a> <span class="meta">2시간 전</span></li>
                    <li><a href="#">[수신함] 금주 금요일 구내식당 메뉴 안내</a> <span class="meta">1일 전</span></li>
                </ul>
            </div>
        </div>

        <div class="dashboard-grid full fade-in-up delay-3">
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">✉️ 고객 문의 관리 (CS Dashboard)</div>
                    <button class="btn-sm" onclick="alert(`엑셀 파일로 문의 내역이 다운로드 됩니다.`);">엑셀 다운로드</button>
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
                        <tbody id="cs-table-body">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modals -->
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

    <dialog id="schedule-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 400px; width: 100%;">
        <h3 style="margin-top: 0; margin-bottom: 1.5rem; color: #1e293b;">사내 일정 등록</h3>
        <input type="number" id="sched-date" min="1" max="30" placeholder="6월 일자 (예: 15)" style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #e2e8f0; border-radius: 8px;">
        <input type="text" id="sched-title" placeholder="일정 제목" style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #e2e8f0; border-radius: 8px;">
        <div style="text-align: right; gap: 10px; display: flex; justify-content: flex-end; margin-top: 1rem;">
            <button class="btn-sm" onclick="document.getElementById(`schedule-modal`).close()">취소</button>
            <button class="btn-sm primary" onclick="addSchedule()">등록</button>
        </div>
    </dialog>

    <dialog id="notice-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 600px; width: 100%;">
        <h3 style="margin-top: 0; margin-bottom: 1.5rem; color: #1e293b;">전체 사내 공지사항</h3>
        <ul class="data-list" style="max-height: 300px; overflow-y: auto;">
            <li><a href="#">2026년 하반기 전사 워크숍 일정 안내</a> <span class="meta">2026.06.01</span></li>
            <li><a href="#">급수 펌프 신제품(BT-900) 메뉴얼 배포</a> <span class="meta">2026.05.28</span></li>
            <li><a href="#">6월 임직원 생일자 축하 안내</a> <span class="meta">2026.05.25</span></li>
            <li><a href="#">사내 보안 점검 및 비밀번호 변경 캠페인</a> <span class="meta">2026.05.20</span></li>
            <li><a href="#">법정 의무 교육 이수 기한 안내</a> <span class="meta">2026.05.15</span></li>
            <li><a href="#">5월 회식 안내</a> <span class="meta">2026.05.10</span></li>
            <li><a href="#">근로자의 날 휴무 안내</a> <span class="meta">2026.04.28</span></li>
        </ul>
        <div style="text-align: right; margin-top: 1.5rem;">
            <button class="btn-sm primary" onclick="document.getElementById(`notice-modal`).close()">닫기</button>
        </div>
    </dialog>
    
    <dialog id="board-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 400px; width: 100%;">
        <h3 style="margin-top: 0; margin-bottom: 1.5rem; color: #1e293b;">익명 글쓰기</h3>
        <input type="text" id="board-title" placeholder="글 제목" style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #e2e8f0; border-radius: 8px;">
        <div style="text-align: right; gap: 10px; display: flex; justify-content: flex-end; margin-top: 1rem;">
            <button class="btn-sm" onclick="document.getElementById(`board-modal`).close()">취소</button>
            <button class="btn-sm primary" onclick="addBoard()">등록</button>
        </div>
    </dialog>

    <script>
        let currentReplyId = null;

        function loadInquiries() {
            const tbody = document.getElementById("cs-table-body");
            tbody.innerHTML = "";
            let inquiries = JSON.parse(localStorage.getItem("batech_inquiries") || "[]");
            
            // Render real data
            inquiries.forEach(inq => {
                const tr = document.createElement("tr");
                const statClass = inq.status === "wait" ? "status-wait" : "status-done";
                const statText = inq.status === "wait" ? "답변 대기" : "처리 완료";
                const btn = inq.status === "wait" 
                    ? `<button class="btn-sm primary" onclick="openReply(\`${inq.id}\`)">답글 작성</button>`
                    : `<button class="btn-sm" onclick="alert(\`완료된 문의 내용을 조회합니다.\`)">내역 보기</button>`;
                
                tr.innerHTML = `
                    <td><span class="\${statClass}">\${statText}</span></td>
                    <td>\${inq.date}</td>
                    <td>\${inq.name} (\${inq.contact || `개인`})</td>
                    <td>\${inq.type}</td>
                    <td>\${inq.subject}</td>
                    <td>\${btn}</td>
                `;
                tbody.appendChild(tr);
            });

            // Fake data appended
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
                
                // Trigger actual mail client
                const mailto = `mailto:\${inq.email}?subject=Re: \${encodeURIComponent(inq.subject)}&body=\${encodeURIComponent(content)}`;
                window.location.href = mailto;
                
                document.getElementById("reply-modal").close();
                loadInquiries();
            }
        }

        function renderCalendar() {
            const grid = document.getElementById("calendar-grid");
            // Header
            grid.innerHTML = `<div class="cal-header">일</div><div class="cal-header">월</div><div class="cal-header">화</div><div class="cal-header">수</div><div class="cal-header">목</div><div class="cal-header">금</div><div class="cal-header">토</div><div class="cal-day empty">31</div>`;
            
            let customScheds = JSON.parse(localStorage.getItem("batech_scheds") || "{}");
            
            // Hardcoded events for June 1-13
            const hEvents = {
                1: [{t:"정례조회", c:""}],
                4: [{t:"영업팀 회의", c:"meeting"}],
                11: [{t:"기술팀 세미나", c:"meeting"}],
                12: [{t:"워크숍 출발", c:""}]
            };

            for(let i=1; i<=30; i++) {
                let eventsHTML = "";
                if(hEvents[i]) {
                    hEvents[i].forEach(e => { eventsHTML += `<div class="cal-event \${e.c}" onclick="alert(\`상세 일정: \${e.t}\`)">\${e.t}</div>`; });
                }
                if(customScheds[i]) {
                    customScheds[i].forEach(e => { eventsHTML += `<div class="cal-event custom" onclick="alert(\`직접 등록한 일정: \${e}\`)">\${e}</div>`; });
                }
                grid.innerHTML += `<div class="cal-day">\${i} \${eventsHTML}</div>`;
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
            
            document.getElementById("schedule-modal").close();
            renderCalendar();
            document.getElementById("sched-date").value = "";
            document.getElementById("sched-title").value = "";
        }
        
        function addBoard() {
            const title = document.getElementById("board-title").value;
            if(!title) { alert("제목을 입력해주세요."); return; }
            
            const ul = document.getElementById("board-list");
            const li = document.createElement("li");
            li.innerHTML = `<a onclick="alert(\`게시물 상세 내용을 조회합니다.\`);">\${title}</a> <span class="meta">익명 (방금 전)</span>`;
            ul.insertBefore(li, ul.firstChild);
            
            document.getElementById("board-modal").close();
            document.getElementById("board-title").value = "";
        }

        // Init
        document.addEventListener("DOMContentLoaded", () => {
            loadInquiries();
            renderCalendar();
        });
    </script>
'

$baseSrc = $src -replace '(?s)(</nav>).*?(<footer>)', "`$1`r`n$dashboardContent`r`n`$2"
$baseSrc = $baseSrc -replace '<title>.*?\| \(주\)비에이텍</title>', '<title>사내 포털 | (주)비에이텍</title>'
$baseSrc = $baseSrc -replace '<title>비에이텍 \(B.A. TECH\) - 워터펌프 시스템 전문 기업</title>', '<title>사내 포털 | (주)비에이텍</title>'

[IO.File]::WriteAllText("portal.html", $baseSrc, $utf8)

