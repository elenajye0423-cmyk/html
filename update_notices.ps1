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
    </style>
    <div class="page-header">
        <h1>사내 공지사항</h1>
        <p>사내 주요 소식 및 안내사항을 확인하세요.</p>
    </div>
    <div class="container">
        <div class="toolbar">
            <a href="portal.html" style="color: var(--primary-color); font-weight: bold; text-decoration: none;">&larr; 대시보드로 돌아가기</a>
            <button class="btn-sm primary" onclick="tryWriteNotice()">+ 공지사항 등록</button>
        </div>
        <ul class="notice-list" id="notice-ul"></ul>
    </div>

    <!-- Notice Detail Modal -->
    <dialog id="notice-detail" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 600px; width: 100%;">
        <h2 id="nd-title" style="margin-top: 0; margin-bottom: 0.5rem; color: #1e293b; font-size: 1.5rem;"></h2>
        <div style="font-size: 0.85rem; color: #64748b; margin-bottom: 1.5rem; border-bottom: 1px solid #e2e8f0; padding-bottom: 1rem;">
            작성자: 총무부 &nbsp;|&nbsp; 등록일: <span id="nd-date"></span> &nbsp;|&nbsp; <span id="nd-views-txt"></span>
        </div>
        <div id="nd-body" style="font-size: 1rem; color: #334155; line-height: 1.6; margin-bottom: 2rem; white-space: pre-wrap; min-height: 150px;">
        </div>
        <div style="text-align: right;">
            <button class="btn-sm primary" onclick="document.getElementById(`notice-detail`).close()">닫기</button>
        </div>
    </dialog>

    <script>
        const defaultNotices = [
            { id: "n1", title: "2026년 근로자의 날 휴무 안내", date: "2026.04.25", content: "안녕하십니까, 총무부입니다.\\n\\n5월 1일(금) 근로자의 날을 맞이하여 전사 휴무를 실시합니다.\\n비상 연락망은 사내 포털 자료실을 참고해 주시기 바랍니다." },
            { id: "n2", title: "2026년 어린이날 휴무 안내", date: "2026.05.02", content: "안녕하십니까, 총무부입니다.\\n\\n5월 5일(화) 어린이날 휴무 안내 드립니다.\\n가족과 함께 즐거운 시간 보내시길 바랍니다." },
            { id: "n3", title: "2026년 부처님 오신 날 휴무 안내", date: "2026.05.20", content: "안녕하십니까, 총무부입니다.\\n\\n5월 24일(일) 부처님 오신 날에 따른 대체 휴일(5월 25일 월요일) 안내입니다.\\n업무에 차질이 없으시길 바랍니다." },
            { id: "n4", title: "2026년 현충일 휴무 안내", date: "2026.06.01", content: "안녕하십니까, 총무부입니다.\\n\\n6월 6일(토) 현충일 관련하여 국가유공자 및 보훈가족 여러분께 깊은 감사를 드립니다.\\n금년 현충일은 토요일이므로 대체휴무는 적용되지 않습니다." }
        ];

        function tryWriteNotice() {
            const pwd = prompt("공지사항 등록 권한이 필요합니다. 관리자 암호를 입력하세요:");
            if (pwd === "1109") {
                window.location.href = "portal_notice_write.html";
            } else if (pwd !== null) {
                alert("암호가 일치하지 않습니다.");
            }
        }

        function loadNotices() {
            const ul = document.getElementById("notice-ul");
            ul.innerHTML = "";
            let views = JSON.parse(localStorage.getItem("batech_notice_views") || "{}");
            let customNotices = JSON.parse(localStorage.getItem("batech_custom_notices") || "[]");
            
            let allNotices = [...customNotices, ...defaultNotices];
            
            // Generate List
            allNotices.forEach(n => {
                let vCount = views[n.id] || 0;
                // Add initial fake views if 0
                if(vCount === 0 && n.id.startsWith("n")) {
                    vCount = Math.floor(Math.random() * 200) + 50;
                    views[n.id] = vCount;
                }
                
                ul.innerHTML += `<li onclick="openNotice(\`${n.id}\`)">
                    <div class="title">${n.title}</div>
                    <div class="meta"><span id="view-span-${n.id}">👁️ ${vCount}</span> &nbsp;|&nbsp; ${n.date}</div>
                </li>`;
            });
            localStorage.setItem("batech_notice_views", JSON.stringify(views));
        }

        function openNotice(id) {
            let customNotices = JSON.parse(localStorage.getItem("batech_custom_notices") || "[]");
            let allNotices = [...customNotices, ...defaultNotices];
            let n = allNotices.find(x => x.id === id);
            
            if(n) {
                // Increment view
                let views = JSON.parse(localStorage.getItem("batech_notice_views") || "{}");
                views[n.id] = (views[n.id] || 0) + 1;
                localStorage.setItem("batech_notice_views", JSON.stringify(views));
                
                // Update UI instantly
                document.getElementById(`view-span-${n.id}`).innerText = `👁️ ${views[n.id]}`;
                document.getElementById("nd-views-txt").innerText = `조회수: ${views[n.id]}`;
                
                document.getElementById("nd-title").innerText = n.title;
                document.getElementById("nd-date").innerText = n.date;
                document.getElementById("nd-body").innerText = n.content || "상세 내용이 없습니다.";
                document.getElementById("notice-detail").showModal();
            }
        }

        document.addEventListener("DOMContentLoaded", loadNotices);
    </script>
'
$noticesHTML = BuildPage "사내 공지사항 | (주)비에이텍" $noticesContent
[IO.File]::WriteAllText("portal_notices.html", $noticesHTML, $utf8)

# --- 2. portal_notice_write.html (New Form Page) ---
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
        <h1>공지사항 등록</h1>
        <p>전사 임직원에게 전달할 새로운 공지사항을 등록합니다.</p>
    </div>
    <div class="container" style="min-height: 50vh;">
        <div class="write-container">
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
                <textarea id="nw-content" class="form-control" style="height: 300px; resize: none;" placeholder="본문 내용을 상세히 입력하세요..."></textarea>
            </div>
            <button class="btn-primary" onclick="submitNotice()">공지사항 등록하기</button>
            <button class="btn-cancel" onclick="window.location.href=`portal_notices.html`">취소</button>
        </div>
    </div>

    <script>
        function submitNotice() {
            const title = document.getElementById("nw-title").value;
            const content = document.getElementById("nw-content").value;
            
            if(!title || !content) {
                alert("제목과 내용을 모두 입력해주세요.");
                return;
            }

            // Get current date
            const today = new Date();
            const dateStr = today.getFullYear() + "." + String(today.getMonth()+1).padStart(2, `0`) + "." + String(today.getDate()).padStart(2, `0`);
            const uniqueId = "cn_" + new Date().getTime();

            let customNotices = JSON.parse(localStorage.getItem("batech_custom_notices") || "[]");
            customNotices.unshift({
                id: uniqueId,
                title: title,
                date: dateStr,
                content: content
            });
            localStorage.setItem("batech_custom_notices", JSON.stringify(customNotices));

            alert("공지사항이 성공적으로 등록되었습니다.");
            window.location.href = "portal_notices.html";
        }
    </script>
'
$writeHTML = BuildPage "공지사항 등록 | (주)비에이텍" $writeContent
[IO.File]::WriteAllText("portal_notice_write.html", $writeHTML, $utf8)

