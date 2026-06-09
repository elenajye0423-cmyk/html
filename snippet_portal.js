// CS Dashboard Logic
let currentReplyId = null;

function loadInquiries() {
    const tbody = document.getElementById("cs-table-body");
    tbody.innerHTML = "";
    
    // Auto-init dummy inquiries if none exist
    if(!localStorage.getItem("batech_inquiries_init")) {
        let dummy = [
            { id: "inq_dummy1", status: "wait", date: "2026-06-08 14:20", name: "김*민", contact: "한국건설", type: "제품 문의", subject: "부스터 펌프 대용량 모델 견적 요청드립니다.", email: "test@example.com" },
            { id: "inq_dummy2", status: "done", date: "2026-06-07 16:40", name: "이*훈", contact: "개인", type: "기타 문의", subject: "펌프 소음 관련 매뉴얼 문의", email: "test2@example.com", reply: "해당 모델의 방음 커버 장착 매뉴얼을 메일로 송부드렸습니다." }
        ];
        localStorage.setItem("batech_inquiries", JSON.stringify(dummy));
        localStorage.setItem("batech_inquiries_init", "true");
    }

    let inquiries = JSON.parse(localStorage.getItem("batech_inquiries") || "[]");
    
    if(inquiries.length === 0) {
        tbody.innerHTML = `<tr><td colspan="6" style="text-align: center; padding: 20px;">등록된 고객 문의가 없습니다.</td></tr>`;
        return;
    }
    
    inquiries.forEach(inq => {
        const tr = document.createElement("tr");
        const statClass = inq.status === "wait" ? "status-wait" : "status-done";
        const statText = inq.status === "wait" ? "답변 대기" : "처리 완료";
        const btn = inq.status === "wait" 
            ? `<button class="btn-sm primary" onclick="openReply('${inq.id}')">답글 작성</button>`
            : `<button class="btn-sm" onclick="alert('완료된 문의 내용을 조회합니다.')">내역 보기</button>`;
        
        tr.innerHTML = `<td><span class="${statClass}">${statText}</span></td><td>${inq.date}</td><td>${inq.name} (${inq.contact || '개인'})</td><td>${inq.type}</td><td>${inq.subject}</td><td>${btn}</td>`;
        tbody.appendChild(tr);
    });
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

function downloadExcel() {
    let inquiries = JSON.parse(localStorage.getItem("batech_inquiries") || "[]");
    if(inquiries.length === 0) return alert("다운로드할 데이터가 없습니다.");
    
    // Simulate real download
    const csvContent = "data:text/csv;charset=utf-8,\uFEFF" + 
        "상태,등록일시,고객명,분류,제목\n" +
        inquiries.map(e => `${e.status},${e.date},${e.name},${e.type},${e.subject}`).join("\n");
        
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", "고객문의내역.csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

function submitReply() {
    const content = document.getElementById("reply-content").value;
    if(!content) { alert("답변 내용을 입력해주세요."); return; }
    
    let inquiries = JSON.parse(localStorage.getItem("batech_inquiries") || "[]");
    let inq = inquiries.find(i => i.id === currentReplyId);
    if(inq) {
        inq.status = "done";
        inq.reply = content;
        localStorage.setItem("batech_inquiries", JSON.stringify(inquiries));
        
        const btn = document.querySelector("#reply-modal .btn-sm.primary");
        const oldText = btn.innerText;
        btn.innerText = "발송 중...";
        btn.disabled = true;
        
        const templateParams = {
            to_email: inq.email,
            subject: "Re: " + inq.subject,
            message: content
        };
        
        emailjs.send('service_zsr87xp', 'template_bfq3jqh', templateParams)
            .then(function(response) {
                alert("고객에게 성공적으로 이메일이 자동 전송되었습니다!");
                document.getElementById("reply-modal").close();
                btn.innerText = oldText;
                btn.disabled = false;
                loadInquiries();
            }, function(error) {
                alert("메일 전송에 실패했습니다. 설정을 확인해주세요: " + JSON.stringify(error));
                inq.status = "wait";
                localStorage.setItem("batech_inquiries", JSON.stringify(inquiries));
                btn.innerText = oldText;
                btn.disabled = false;
                loadInquiries();
            });
    }
}

function loadBoardPreview() {
    const ul = document.getElementById("dash-board-list");
    let posts = JSON.parse(localStorage.getItem("batech_board_v4") || "[]");
    if(posts.length === 0) {
        posts = [
            { id: 1, title: "[필독] 사내 보안 규정 가이드라인", author: "보안팀", date: "2026.06.01", views: 142 },
            { id: 2, title: "상반기 우수사원 포상 안내", author: "인사팀", date: "2026.06.03", views: 89 },
            { id: 3, title: "구내식당 식단표 (6월 2주차)", author: "총무팀", date: "2026.06.05", views: 256 },
            { id: 4, title: "주차장 바닥 공사로 인한 주차 통제 안내", author: "총무팀", date: "2026.06.08", views: 112 }
        ];
        localStorage.setItem("batech_board_v4", JSON.stringify(posts));
        localStorage.setItem("batech_board_init_v4", "true");
    }
    
    ul.innerHTML = "";
    posts.slice(0, 4).forEach(p => {
        ul.innerHTML += `<li><a href="portal_board.html">${p.title}</a> <span class="meta">${p.author}</span></li>`;
    });
}

function loadDashNotices() {
    const ul = document.getElementById("dash-notice-list");
    let notices = JSON.parse(localStorage.getItem("batech_notices_db") || "[]");
    if(notices.length === 0) {
        notices = [
            { id: 1, title: "[긴급] 전사 시스템 점검 안내 (6/12 00:00~04:00)", author: "IT팀", date: "2026.06.08", views: 45 },
            { id: 2, title: "2026년 하계 휴가 일정 등록의 건", author: "인사팀", date: "2026.06.05", views: 128 },
            { id: 3, title: "신규 입사자 OJT 교육 일정 (6/10~6/14)", author: "교육팀", date: "2026.06.02", views: 67 }
        ];
        localStorage.setItem("batech_notices_db", JSON.stringify(notices));
        localStorage.setItem("batech_notices_init", "true");
    }

    notices.sort((a,b) => new Date(b.date.replace(/\./g, "-")) - new Date(a.date.replace(/\./g, "-")));
    ul.innerHTML = "";
    notices.slice(0, 3).forEach(n => {
        let isNew = new Date().getTime() - new Date(n.date.replace(/\./g, "-")).getTime() < 86400000 * 7;
        let badge = isNew ? `<span class="badge new" style="margin-right:5px;">N</span>` : ``;
        ul.innerHTML += `<li><a href="portal_notices.html?view_id=${n.id}">${badge}${n.title}</a> <span class="meta">${n.date}</span></li>`;
    });
}

function loadDashScheds() {
    const ul = document.getElementById("dash-sched-list");
    let scheds = JSON.parse(localStorage.getItem("batech_scheds_v5") || "{}");
    if(Object.keys(scheds).length === 0) {
        scheds = {
            "2026-06-12": [{ title: "시스템 점검" }],
            "2026-06-15": [{ title: "경영전략회의" }],
            "2026-06-20": [{ title: "임직원 워크샵" }]
        };
        localStorage.setItem("batech_scheds_v5", JSON.stringify(scheds));
    }
    
    let holidays = {
        "2026-06-03": "지방선거", "2026-06-06": "현충일", "2026-08-15": "광복절", "2026-09-24": "추석", 
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
}

document.addEventListener("DOMContentLoaded", () => {
    loadInquiries();
    loadBoardPreview();
    loadDashScheds();
    loadDashNotices();
});
