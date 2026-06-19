$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("portal.html", $utf8)

# Update portal.html Notice Panel & JS
$src = $src -replace '(?s)<ul class="data-list">\s*<li><a href="portal_notices.html">2026년 근로자의 날.*?</ul>', '<ul class="data-list" id="dash-notice-list"></ul>'

if ($src -notmatch 'loadDashNotices\(\)') {
    $dashNoticeJS = '
        function loadDashNotices() {
            const ul = document.getElementById("dash-notice-list");
            let customNotices = JSON.parse(localStorage.getItem("batech_custom_notices") || "[]");
            const defaultNotices = [
                { id: "n4_v2", title: "2026년 현충일 휴무 안내", date: "2026.06.01" },
                { id: "n3_v2", title: "2026년 부처님 오신 날 휴무 안내", date: "2026.05.20" },
                { id: "n2_v2", title: "2026년 어린이날 휴무 안내", date: "2026.05.02" },
                { id: "n1_v2", title: "2026년 근로자의 날 휴무 안내", date: "2026.04.25" }
            ];
            let allNotices = [...customNotices, ...defaultNotices];
            allNotices.sort((a,b) => new Date(b.date.replace(/\./g, "-")) - new Date(a.date.replace(/\./g, "-")));
            
            ul.innerHTML = "";
            allNotices.slice(0, 3).forEach(n => {
                let isNew = new Date().getTime() - new Date(n.date.replace(/\./g, "-")).getTime() < 86400000 * 7;
                let badge = isNew ? `<span class="badge new" style="margin-right:5px;">N</span>` : ``;
                ul.innerHTML += `<li><a href="portal_notices.html">${badge}${n.title}</a> <span class="meta">${n.date}</span></li>`;
            });
        }
'
    $src = $src -replace 'function loadDashScheds\(\) \{', "$dashNoticeJS`n        function loadDashScheds() {"
    $src = $src -replace 'loadDashScheds\(\);', "loadDashScheds();`n            loadDashNotices();"
}
[IO.File]::WriteAllText("portal.html", $src, $utf8)


# --- 2. Update portal_notices.html ---
$noticesSrc = [IO.File]::ReadAllText("portal_notices.html", $utf8)

# Replace the script block entirely
$newScript = '
    <script>
        const defaultNotices = [
            { id: "n4_v2", title: "2026년 현충일 휴무 안내", date: "2026.06.01", content: "안녕하십니까, 총무부입니다.\\n\\n6월 6일(토) 현충일 관련하여 국가유공자 및 보훈가족 여러분께 깊은 감사를 드립니다.\\n금년 현충일은 토요일이므로 대체휴무는 적용되지 않습니다." },
            { id: "n3_v2", title: "2026년 부처님 오신 날 휴무 안내", date: "2026.05.20", content: "안녕하십니까, 총무부입니다.\\n\\n5월 24일(일) 부처님 오신 날에 따른 대체 휴일(5월 25일 월요일) 안내입니다.\\n업무에 차질이 없으시길 바랍니다." },
            { id: "n2_v2", title: "2026년 어린이날 휴무 안내", date: "2026.05.02", content: "안녕하십니까, 총무부입니다.\\n\\n5월 5일(화) 어린이날 휴무 안내 드립니다.\\n가족과 함께 즐거운 시간 보내시길 바랍니다." },
            { id: "n1_v2", title: "2026년 근로자의 날 휴무 안내", date: "2026.04.25", content: "안녕하십니까, 총무부입니다.\\n\\n5월 1일(금) 근로자의 날을 맞이하여 전사 휴무를 실시합니다.\\n비상 연락망은 사내 포털 자료실을 참고해 주시기 바랍니다." }
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
            // 최신 날짜 순(내림차순) 정렬
            allNotices.sort((a,b) => new Date(b.date.replace(/\./g, "-")) - new Date(a.date.replace(/\./g, "-")));
            
            // Generate List
            allNotices.forEach(n => {
                let vCount = views[n.id] || 0;
                
                ul.innerHTML += `<li onclick="openNotice(\`${n.id}\`)">
                    <div class="title">${n.title}</div>
                    <div class="meta"><span id="view-span-${n.id}">👁️ ${vCount}</span> &nbsp;|&nbsp; ${n.date}</div>
                </li>`;
            });
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
$noticesSrc = $noticesSrc -replace '(?s)<script>.*?</script>', $newScript
[IO.File]::WriteAllText("portal_notices.html", $noticesSrc, $utf8)


