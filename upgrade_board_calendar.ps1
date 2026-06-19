$utf8 = New-Object System.Text.UTF8Encoding $false

# --- 1. portal_calendar.html ---
$calSrc = [IO.File]::ReadAllText("portal_calendar.html", $utf8)

# Upgrade to v5, remove defaults, add holidays
$calSrc = $calSrc -replace 'batech_scheds_v3', 'batech_scheds_v5'

$migrateFunction = @'
        function migrateOldData() {
            if(!localStorage.getItem("batech_scheds_v5")) {
                let v5 = {};
                let v3 = JSON.parse(localStorage.getItem("batech_scheds_v3") || "{}");
                for(let dStr in v3) {
                    let customEvents = v3[dStr].filter(e => e.type === "custom");
                    if(customEvents.length > 0) v5[dStr] = customEvents;
                }
                localStorage.setItem("batech_scheds_v5", JSON.stringify(v5));
            }
        }
'@

$calSrc = $calSrc -replace '(?s)function migrateOldData\(\) \{.*?\}', $migrateFunction

$renderLoop = @'
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
'@
$calSrc = $calSrc -replace '(?s)let today = new Date\(\);.*?html \+= `<div class="cal-day \$\{isToday\}">.*?</div>`;\s*\}', $renderLoop
[IO.File]::WriteAllText("portal_calendar.html", $calSrc, $utf8)


# --- 2. portal.html Dashboard Sync ---
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)

# Replace "소통의 장" text
$portalSrc = $portalSrc -replace '🗣️ 소통의 장 \(익명\)', '☕ 사내 익명 라운지'
$portalSrc = $portalSrc -replace 'batech_board', 'batech_board_v2'

$dashScheds = @'
        function loadDashScheds() {
            const ul = document.getElementById("dash-sched-list");
            let scheds = JSON.parse(localStorage.getItem("batech_scheds_v5") || "{}");
            
            let holidays = {
                "2026-06-06": "현충일", "2026-08-15": "광복절", "2026-09-24": "추석", 
                "2026-09-25": "추석", "2026-09-26": "추석", "2026-10-03": "개천절", 
                "2026-10-09": "한글날", "2026-12-25": "성탄절"
            };

            let allEvents = [];
            for(let dateStr in scheds) {
                let d = new Date(dateStr);
                scheds[dateStr].forEach(e => {
                    allEvents.push({ date: d, dateStr: dateStr, title: e.title });
                });
            }
            for(let dateStr in holidays) {
                let d = new Date(dateStr);
                allEvents.push({ date: d, dateStr: dateStr, title: "🇰🇷 " + holidays[dateStr] });
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
$portalSrc = $portalSrc -replace '(?s)function loadDashScheds\(\) \{.*?(?=\s*document\.addEventListener)', "$dashScheds`n"
[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)


# --- 3. portal_board.html Rewrite ---
$boardContent = @'
    <style>
        .page-header { background: #0f172a; padding: 60px 0; text-align: center; color: white; }
        .page-header h1 { font-size: 2.5rem; font-weight: 800; }
        .board-container { max-width: 800px; margin: 40px auto; min-height: 50vh; }
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .btn-primary { background: var(--primary-color); color: #fff; border: none; padding: 12px 25px; border-radius: 8px; font-weight: bold; cursor: pointer; }
        .btn-sm { padding: 0.4rem 0.8rem; border-radius: 6px; font-size: 0.85rem; cursor: pointer; border: none; background: #e2e8f0; color: #475569; font-weight: 600; }
        .btn-sm.primary { background: var(--primary-color); color: #fff; }
        .board-list { list-style: none; padding: 0; margin: 0; }
        .board-list li { background: #fff; padding: 20px; border-radius: 8px; margin-bottom: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); border-left: 4px solid var(--secondary-color); cursor: pointer; transition: 0.2s; }
        .board-list li:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .board-list .title { font-size: 1.1rem; font-weight: 600; color: #1e293b; margin-bottom: 5px; }
        .board-list .meta { font-size: 0.85rem; color: #64748b; display: flex; justify-content: space-between; }
        
        dialog::backdrop { background: rgba(0,0,0,0.5); backdrop-filter: blur(2px); }
        .modal { border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 600px; width: 100%; margin: auto; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); max-height: 85vh; overflow-y: auto; }
        
        .form-group { margin-bottom: 15px; }
        .form-label { display: block; font-weight: 600; margin-bottom: 5px; color: #1e293b; }
        .input-box { width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box; font-family: inherit; }
        
        .comments-section { margin-top: 2rem; border-top: 1px solid #e2e8f0; padding-top: 1.5rem; }
        .comment-item { background: #f8fafc; padding: 10px 15px; border-radius: 8px; margin-bottom: 10px; }
        .comment-item .c-author { font-weight: 600; color: #334155; font-size: 0.85rem; margin-bottom: 4px; }
        .comment-item .c-text { color: #475569; font-size: 0.95rem; line-height: 1.4; }
        .comment-input-area { display: flex; gap: 10px; margin-top: 15px; }
    </style>
    <div class="page-header">
        <h1>사내 익명 라운지</h1>
        <p>어떤 이야기든 편하게 나눠보세요. 모든 글과 댓글은 철저히 익명으로 보호됩니다.</p>
    </div>
    <div class="container board-container">
        <div class="toolbar">
            <a href="portal.html" style="color: var(--primary-color); font-weight: bold; text-decoration: none;">&larr; 대시보드로 돌아가기</a>
            <button class="btn-primary" onclick="document.getElementById('write-modal').showModal()">+ 새 게시글 작성</button>
        </div>

        <ul class="board-list" id="posts-container"></ul>
    </div>

    <!-- Write Post Modal -->
    <dialog id="write-modal" class="modal">
        <h3 style="margin-top: 0; margin-bottom: 1.5rem; color: #1e293b;">익명 게시글 작성</h3>
        <div class="form-group">
            <label class="form-label">제목</label>
            <input type="text" id="post-title" class="input-box" placeholder="글 제목을 입력하세요">
        </div>
        <div class="form-group">
            <label class="form-label">내용</label>
            <textarea id="post-content" class="input-box" style="height: 150px; resize: none;" placeholder="자유롭게 의견을 작성해 주세요..."></textarea>
        </div>
        <div style="text-align: right; display: flex; justify-content: flex-end; gap: 10px;">
            <button class="btn-sm" onclick="document.getElementById('write-modal').close()">취소</button>
            <button class="btn-sm primary" onclick="submitPost()">게시물 등록</button>
        </div>
    </dialog>

    <!-- Read Post & Comments Modal -->
    <dialog id="read-modal" class="modal">
        <input type="hidden" id="read-post-id">
        <h2 id="read-title" style="margin-top: 0; margin-bottom: 0.5rem; color: #1e293b; font-size: 1.4rem;"></h2>
        <div style="font-size: 0.85rem; color: #64748b; margin-bottom: 1.5rem; border-bottom: 1px solid #e2e8f0; padding-bottom: 1rem;">
            작성자: <span id="read-author"></span> &nbsp;|&nbsp; <span id="read-date"></span>
        </div>
        <div id="read-content" style="color: #334155; line-height: 1.6; min-height: 100px; white-space: pre-wrap;"></div>
        
        <div class="comments-section">
            <h4 style="margin-top: 0; color: #1e293b;">댓글 (<span id="comment-count">0</span>)</h4>
            <div id="comments-list"></div>
            
            <div class="comment-input-area">
                <input type="text" id="new-comment" class="input-box" placeholder="따뜻한 익명 댓글을 남겨보세요..." onkeypress="if(event.key === 'Enter') addComment()">
                <button class="btn-sm primary" style="white-space: nowrap;" onclick="addComment()">댓글 등록</button>
            </div>
        </div>

        <div style="text-align: right; margin-top: 20px;">
            <button class="btn-sm" onclick="document.getElementById('read-modal').close()">닫기</button>
        </div>
    </dialog>

    <script>
        function initBoard() {
            if(!localStorage.getItem("batech_board_init")) {
                let defaultPosts = [
                    { id: "b2", title: "휴게실 안마의자 진짜 너무 좋습니다 ㅠㅠ", content: "최근에 들어온 안마의자 써보신 분 계신가요?\n점심시간에 15분 누워있었는데 피로가 싹 풀리네요.\n총무부 감사합니다!!", author: "익명", date: "2026.06.08", comments: [{author: "익명", text: "저도 내일 점심에 써봐야겠네요 ㅎㅎ"}, {author: "익명", text: "경쟁이 치열합니다 일찍 가셔야 해요"}] },
                    { id: "b1", title: "이번 주 금요일 회식 장소 투표 좀 해주세요", content: "이번 주 팀 회식인데 메뉴를 못 정하고 있습니다.\n1. 삼겹살\n2. 회\n3. 곱창\n\n댓글로 의견 좀 남겨주세요!", author: "익명", date: "2026.06.07", comments: [{author: "익명", text: "무조건 1번 삼겹살이죠"}, {author: "익명", text: "저는 2번 회 추천합니다!"}] }
                ];
                localStorage.setItem("batech_board_v2", JSON.stringify(defaultPosts));
                localStorage.setItem("batech_board_init", "true");
            }
        }

        function renderPosts() {
            const container = document.getElementById("posts-container");
            container.innerHTML = "";
            let posts = JSON.parse(localStorage.getItem("batech_board_v2") || "[]");
            
            posts.forEach(p => {
                container.innerHTML += `
                    <li onclick="openPost(\`${p.id}\`)">
                        <div class="title">${p.title} <span style="color:#ef4444; font-size:0.9rem;">[${p.comments ? p.comments.length : 0}]</span></div>
                        <div class="meta">
                            <span>${p.author}</span>
                            <span>${p.date}</span>
                        </div>
                    </li>`;
            });
        }

        function submitPost() {
            const title = document.getElementById("post-title").value;
            const content = document.getElementById("post-content").value;
            
            if(!title || !content) return alert("제목과 내용을 모두 입력해주세요.");
            
            const today = new Date();
            const dateStr = today.getFullYear() + "." + String(today.getMonth()+1).padStart(2, "0") + "." + String(today.getDate()).padStart(2, "0");
            
            let posts = JSON.parse(localStorage.getItem("batech_board_v2") || "[]");
            posts.unshift({
                id: "b_" + new Date().getTime(),
                title: title,
                content: content,
                author: "익명",
                date: dateStr,
                comments: []
            });
            localStorage.setItem("batech_board_v2", JSON.stringify(posts));
            
            document.getElementById("post-title").value = "";
            document.getElementById("post-content").value = "";
            document.getElementById("write-modal").close();
            
            renderPosts();
            alert("게시글이 성공적으로 등록되었습니다.");
        }

        function openPost(id) {
            let posts = JSON.parse(localStorage.getItem("batech_board_v2") || "[]");
            let p = posts.find(x => x.id === id);
            if(!p) return;
            
            document.getElementById("read-post-id").value = id;
            document.getElementById("read-title").innerText = p.title;
            document.getElementById("read-author").innerText = p.author;
            document.getElementById("read-date").innerText = p.date;
            document.getElementById("read-content").innerText = p.content;
            
            renderComments(p.comments || []);
            document.getElementById("read-modal").showModal();
        }

        function renderComments(comments) {
            document.getElementById("comment-count").innerText = comments.length;
            const list = document.getElementById("comments-list");
            list.innerHTML = "";
            if(comments.length === 0) {
                list.innerHTML = `<div style="color: #94a3b8; font-size: 0.9rem; padding: 10px 0;">첫 댓글을 남겨보세요!</div>`;
                return;
            }
            comments.forEach(c => {
                list.innerHTML += `
                    <div class="comment-item">
                        <div class="c-author">${c.author}</div>
                        <div class="c-text">${c.text}</div>
                    </div>`;
            });
        }

        function addComment() {
            const input = document.getElementById("new-comment");
            const text = input.value.trim();
            if(!text) return;
            
            const id = document.getElementById("read-post-id").value;
            let posts = JSON.parse(localStorage.getItem("batech_board_v2") || "[]");
            let pIndex = posts.findIndex(x => x.id === id);
            
            if(pIndex !== -1) {
                if(!posts[pIndex].comments) posts[pIndex].comments = [];
                posts[pIndex].comments.push({ author: "익명", text: text });
                localStorage.setItem("batech_board_v2", JSON.stringify(posts));
                
                input.value = "";
                renderComments(posts[pIndex].comments);
                renderPosts(); // Update comment count on list
            }
        }

        document.addEventListener("DOMContentLoaded", () => {
            initBoard();
            renderPosts();
        });
    </script>
'@
$baseSrc = [IO.File]::ReadAllText("index.html", $utf8)
$boardHTML = $baseSrc -replace '(?s)(</nav>).*?(<footer>)', "`$1`r`n$boardContent`r`n`$2"
$boardHTML = $boardHTML -replace '(?s)<nav id="navbar">.*?</nav>', '<nav id="navbar" style="background: #0f172a;"><div class="nav-container"><a href="portal.html" class="logo" style="color: white;"><span class="logo-icon">💧</span> B.A. TECH 포털</a><ul class="nav-links"><li class="nav-item"><a href="portal.html" style="color: #cbd5e1;">대시보드</a></li><li class="nav-item"><a href="portal_notices.html" style="color: #cbd5e1;">공지사항</a></li><li class="nav-item"><a href="portal_calendar.html" style="color: #cbd5e1;">일정 관리</a></li><li class="nav-item"><a href="portal_board.html" style="color: #cbd5e1;">게시판</a></li><li class="nav-item"><a href="portal_archive.html" style="color: #cbd5e1;">자료실</a></li><li><a href="index.html" style="border: 1px solid #cbd5e1; padding: 5px 15px; border-radius: 20px; color: #cbd5e1; margin-left: 15px;">홈페이지로</a></li></ul><div class="menu-toggle" id="mobile-menu"><span class="bar" style="background: white;"></span><span class="bar" style="background: white;"></span><span class="bar" style="background: white;"></span></div></div></nav><style>#navbar.scrolled { background: #0f172a !important; box-shadow: 0 4px 6px rgba(0,0,0,0.3); } .nav-links li a:hover { color: white !important; }</style>'
$boardHTML = $boardHTML -replace '<title>.*?\| \(주\)비에이텍</title>', "<title>사내 익명 라운지 | (주)비에이텍</title>"
$boardHTML = $boardHTML -replace '<title>비에이텍 \(B.A. TECH\) - 워터펌프 시스템 전문 기업</title>', "<title>사내 익명 라운지 | (주)비에이텍</title>"
[IO.File]::WriteAllText("portal_board.html", $boardHTML, $utf8)


