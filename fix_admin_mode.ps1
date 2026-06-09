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

# --- 1. portal_notices.html ---
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
        .toolbar { display: flex; justify-content: space-between; align-items: center; max-width: 800px; margin: 20px auto 0 auto; }
        
        .styled-notice { padding: 20px; background: #f8fafc; border-radius: 8px; border-left: 4px solid var(--primary-color); color: #334155; line-height: 1.8; font-size: 1rem; }
        .styled-notice p { margin-bottom: 10px; }
        .styled-notice p:last-child { margin-bottom: 0; }
    </style>
    <div class="page-header">
        <h1>사내 공지사항</h1>
        <p>사내 주요 소식 및 안내사항을 확인하세요.</p>
    </div>
    <div class="container">
        <div class="toolbar">
            <a href="portal.html" style="color: var(--primary-color); font-weight: bold; text-decoration: none;">&larr; 대시보드로 돌아가기</a>
            <div style="display:flex; gap:10px;">
                <button class="btn-sm" id="btn-admin-mode" onclick="toggleAdmin()">🔒 관리자 로그인</button>
                <button class="btn-sm primary" id="btn-write-notice" style="display: none;" onclick="window.location.href=`portal_notice_write.html`">+ 공지사항 등록</button>
            </div>
        </div>
        <ul class="notice-list" id="notice-ul"></ul>
    </div>

    <!-- Notice Detail Modal -->
    <dialog id="notice-detail" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 700px; width: 100%;">
        <h2 id="nd-title" style="margin-top: 0; margin-bottom: 0.5rem; color: #1e293b; font-size: 1.5rem;"></h2>
        <div style="font-size: 0.85rem; color: #64748b; margin-bottom: 1.5rem; border-bottom: 1px solid #e2e8f0; padding-bottom: 1rem;">
            작성자: 총무부 &nbsp;|&nbsp; 등록일: <span id="nd-date"></span> &nbsp;|&nbsp; <span id="nd-views-txt"></span>
        </div>
        
        <div id="nd-body" class="styled-notice" style="margin-bottom: 2rem; min-height: 150px;"></div>
        
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <button class="btn-sm" id="btn-notice-delete" style="background:#fee2e2; color:#991b1b; margin-right:5px; display:none;" onclick="deleteNotice()">삭제</button>
                <button class="btn-sm" id="btn-notice-edit" style="background:#e0f2fe; color:#0284c7; display:none;" onclick="editNotice()">수정</button>
            </div>
            <button class="btn-sm primary" onclick="document.getElementById(`notice-detail`).close()">닫기</button>
        </div>
        <input type="hidden" id="nd-current-id">
    </dialog>

    <script>
        function toggleAdmin() {
            if(sessionStorage.getItem("batech_admin") === "true") {
                sessionStorage.removeItem("batech_admin");
                alert("관리자 모드가 해제되었습니다.");
                location.reload();
            } else {
                const pwd = prompt("관리자 암호를 입력하세요:");
                if(pwd === "1109") {
                    sessionStorage.setItem("batech_admin", "true");
                    alert("관리자 모드로 전환되었습니다.");
                    location.reload();
                } else if(pwd !== null) {
                    alert("암호가 일치하지 않습니다.");
                }
            }
        }

        function checkAdmin() {
            if(sessionStorage.getItem("batech_admin") === "true") {
                document.getElementById("btn-admin-mode").innerText = "🔓 관리자 로그아웃";
                document.getElementById("btn-admin-mode").style.background = "#fee2e2";
                document.getElementById("btn-admin-mode").style.color = "#991b1b";
                document.getElementById("btn-write-notice").style.display = "inline-block";
            }
        }

        function initDB() {
            if(!localStorage.getItem("batech_notices_init")) {
                const initData = [
                    { id: "n4_v3", title: "2026년 현충일 휴무 안내", date: "2026.06.01", content: "<p>안녕하십니까, 총무부입니다.</p><p>6월 6일(토) 현충일 관련하여 국가유공자 및 보훈가족 여러분께 깊은 감사를 드립니다.</p><p>금년 현충일은 주말(토요일)과 겹치는 관계로, 관련 법령에 의거하여 별도의 대체휴무일이 지정되지 않았음을 안내해 드립니다.</p><p>임직원 여러분의 양해를 부탁드리며, 호국영령의 뜻을 기리는 의미 있는 하루가 되시길 바랍니다.</p>" },
                    { id: "n3_v3", title: "2026년 부처님 오신 날 휴무 안내", date: "2026.05.20", content: "<p>안녕하십니까, 총무부입니다.</p><p>5월 24일(일) 부처님 오신 날에 따른 대체 휴일(5월 25일 월요일) 안내입니다.</p><p>연휴 기간 동안 사내 보안 및 화재 예방에 각별히 신경 써 주시기 바랍니다.</p>" },
                    { id: "n2_v3", title: "2026년 어린이날 휴무 안내", date: "2026.05.02", content: "<p>안녕하십니까, 총무부입니다.</p><p>5월 5일(화) 어린이날 휴무 안내 드립니다.</p><p>가족과 함께 즐거운 시간 보내시길 바랍니다.</p>" },
                    { id: "n1_v3", title: "2026년 근로자의 날 휴무 안내", date: "2026.04.25", content: "<p>안녕하십니까, 총무부입니다.</p><p>5월 1일(금) 근로자의 날을 맞이하여 전사 휴무를 실시합니다.</p><p>비상 연락망은 사내 포털 자료실을 참고해 주시기 바랍니다.</p>" }
                ];
                localStorage.setItem("batech_notices_db", JSON.stringify(initData));
                localStorage.setItem("batech_notices_init", "true");
                localStorage.removeItem("batech_custom_notices"); 
            }
        }

        function loadNotices() {
            const ul = document.getElementById("notice-ul");
            ul.innerHTML = "";
            let views = JSON.parse(localStorage.getItem("batech_notice_views") || "{}");
            let notices = JSON.parse(localStorage.getItem("batech_notices_db") || "[]");
            
            notices.sort((a,b) => new Date(b.date.replace(/\./g, "-")) - new Date(a.date.replace(/\./g, "-")));
            
            notices.forEach(n => {
                let vCount = views[n.id] || 0;
                ul.innerHTML += `<li onclick="openNotice(\`${n.id}\`)">
                    <div class="title">${n.title}</div>
                    <div class="meta"><span id="view-span-${n.id}">👁️ ${vCount}</span> &nbsp;|&nbsp; ${n.date}</div>
                </li>`;
            });
        }

        function openNotice(id) {
            let notices = JSON.parse(localStorage.getItem("batech_notices_db") || "[]");
            let n = notices.find(x => x.id === id);
            
            if(n) {
                let views = JSON.parse(localStorage.getItem("batech_notice_views") || "{}");
                views[n.id] = (views[n.id] || 0) + 1;
                localStorage.setItem("batech_notice_views", JSON.stringify(views));
                
                document.getElementById(`view-span-${n.id}`).innerText = `👁️ ${views[n.id]}`;
                document.getElementById("nd-views-txt").innerText = `조회수: ${views[n.id]}`;
                
                document.getElementById("nd-title").innerText = n.title;
                document.getElementById("nd-date").innerText = n.date;
                document.getElementById("nd-current-id").value = n.id;
                
                let content = n.content || "상세 내용이 없습니다.";
                if(!content.includes("<p>") && !content.includes("<br>")) {
                    content = content.replace(/\n/g, "<br>");
                }
                document.getElementById("nd-body").innerHTML = content;
                
                const isAdmin = sessionStorage.getItem("batech_admin") === "true";
                document.getElementById("btn-notice-delete").style.display = isAdmin ? "inline-block" : "none";
                document.getElementById("btn-notice-edit").style.display = isAdmin ? "inline-block" : "none";
                
                document.getElementById("notice-detail").showModal();
            }
        }

        function deleteNotice() {
            let id = document.getElementById("nd-current-id").value;
            if(!id) return;
            if(confirm("정말 이 공지사항을 삭제하시겠습니까? 복구할 수 없습니다.")) {
                let notices = JSON.parse(localStorage.getItem("batech_notices_db") || "[]");
                notices = notices.filter(n => n.id !== id);
                localStorage.setItem("batech_notices_db", JSON.stringify(notices));
                
                document.getElementById("notice-detail").close();
                loadNotices();
                alert("성공적으로 삭제되었습니다.");
            }
        }

        function editNotice() {
            let id = document.getElementById("nd-current-id").value;
            if(!id) return;
            window.location.href = `portal_notice_write.html?edit_id=${id}`;
        }

        document.addEventListener("DOMContentLoaded", () => {
            initDB();
            checkAdmin();
            loadNotices();
        });
    </script>
'
$noticesHTML = BuildPage "사내 공지사항 | (주)비에이텍" $noticesContent
[IO.File]::WriteAllText("portal_notices.html", $noticesHTML, $utf8)

# --- 3. portal_notice_write.html ---
$writeContent = '
    <style>
        .page-header { background: #0f172a; padding: 60px 0; text-align: center; color: white; }
        .page-header h1 { font-size: 2.5rem; font-weight: 800; }
        .write-container { max-width: 800px; margin: 40px auto; background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 1rem; font-family: inherit; }
        .btn-primary { background: var(--primary-color); color: #fff; border: none; padding: 12px 25px; border-radius: 8px; font-weight: bold; cursor: pointer; width: 100%; font-size: 1.1rem; }
        .btn-cancel { background: #e2e8f0; color: #475569; border: none; padding: 12px 25px; border-radius: 8px; font-weight: bold; cursor: pointer; width: 100%; font-size: 1.1rem; margin-top: 10px; }
    </style>
    <div class="page-header">
        <h1 id="page-title">공지사항 등록</h1>
        <p>전사 임직원에게 전달할 주요 안내사항을 작성합니다.</p>
    </div>
    <div class="container" style="min-height: 50vh;">
        <div class="write-container">
            <input type="hidden" id="edit-id" value="">
            <div class="form-group">
                <label class="form-label">공지 제목</label>
                <input type="text" id="nw-title" class="form-control" placeholder="예: 2026년 추석 연휴 휴무 안내">
            </div>
            <div class="form-group">
                <label class="form-label">작성 부서</label>
                <input type="text" class="form-control" value="총무부" disabled style="background: #f1f5f9;">
            </div>
            <div class="form-group">
                <label class="form-label">공지 내용</label>
                <textarea id="nw-content" class="form-control" style="height: 300px; resize: none;" placeholder="본문 내용을 상세히 입력하세요... HTML 태그(<p>, <br> 등)를 사용할 수 있습니다."></textarea>
            </div>
            <button class="btn-primary" id="btn-submit" onclick="submitNotice()">공지사항 등록하기</button>
            <button class="btn-cancel" onclick="window.location.href=`portal_notices.html`">취소</button>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            if(sessionStorage.getItem("batech_admin") !== "true") {
                alert("비정상적인 접근입니다. 관리자 권한이 없습니다.");
                window.location.href = "portal_notices.html";
                return;
            }

            const params = new URLSearchParams(window.location.search);
            const editId = params.get("edit_id");
            if(editId) {
                document.getElementById("page-title").innerText = "공지사항 수정";
                document.getElementById("btn-submit").innerText = "수정 내용 저장하기";
                document.getElementById("edit-id").value = editId;
                
                let notices = JSON.parse(localStorage.getItem("batech_notices_db") || "[]");
                let n = notices.find(x => x.id === editId);
                if(n) {
                    document.getElementById("nw-title").value = n.title;
                    let textContent = n.content.replace(/<p>/g, "").replace(/<\/p>/g, "\n\n").replace(/<br\s*[\/]?>/g, "\n").trim();
                    document.getElementById("nw-content").value = textContent;
                }
            }
        });

        function submitNotice() {
            const title = document.getElementById("nw-title").value;
            let content = document.getElementById("nw-content").value;
            
            if(!title || !content) {
                alert("제목과 내용을 모두 입력해주세요.");
                return;
            }

            let formattedContent = "<p>" + content.replace(/\n\n/g, "</p><p>").replace(/\n/g, "<br>") + "</p>";

            let notices = JSON.parse(localStorage.getItem("batech_notices_db") || "[]");
            const editId = document.getElementById("edit-id").value;

            if(editId) {
                let idx = notices.findIndex(x => x.id === editId);
                if(idx !== -1) {
                    notices[idx].title = title;
                    notices[idx].content = formattedContent;
                }
                alert("공지사항이 성공적으로 수정되었습니다.");
            } else {
                const today = new Date();
                const dateStr = today.getFullYear() + "." + String(today.getMonth()+1).padStart(2, `0`) + "." + String(today.getDate()).padStart(2, `0`);
                const uniqueId = "cn_" + new Date().getTime();
                
                notices.unshift({
                    id: uniqueId,
                    title: title,
                    date: dateStr,
                    content: formattedContent
                });
                alert("공지사항이 성공적으로 등록되었습니다.");
            }
            
            localStorage.setItem("batech_notices_db", JSON.stringify(notices));
            window.location.href = "portal_notices.html";
        }
    </script>
'
$writeHTML = BuildPage "공지사항 등록/수정 | (주)비에이텍" $writeContent
[IO.File]::WriteAllText("portal_notice_write.html", $writeHTML, $utf8)

