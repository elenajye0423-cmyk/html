$utf8 = New-Object System.Text.UTF8Encoding $false

# 1. Update portal.html
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)
$portalSrc = $portalSrc -replace 'inq\.status = "done";', "inq.status = `"done`";`n                inq.reply = content;"
[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)

# 2. Update inquiry.html
$inquirySrc = [IO.File]::ReadAllText("inquiry.html", $utf8)

# Add button above the form
$formStart = '<form id="inquiry-form"'
$btnHtml = @"
<div style="text-align: right; margin-bottom: 20px;">
    <button type="button" class="btn-primary" style="background: white; color: var(--primary-color); border: 2px solid var(--primary-color); font-weight: bold; padding: 10px 20px;" onclick="document.getElementById('check-inquiry-modal').showModal()">🔍 나의 문의내역 조회</button>
</div>
<form id="inquiry-form"
"@
$inquirySrc = $inquirySrc.Replace($formStart, $btnHtml)

# Add Modal and JS
$modalHtml = @"
    <!-- Inquiry Check Modal -->
    <dialog id="check-inquiry-modal" style="border: none; border-radius: 16px; padding: 2.5rem; box-shadow: 0 10px 40px rgba(0,0,0,0.2); max-width: 600px; width: 100%; margin: 0; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); max-height: 85vh; overflow-y: auto;">
        <button onclick="this.closest('dialog').close()" style="position: absolute; top: 20px; right: 20px; background: transparent; border: none; font-size: 1.5rem; color: #94a3b8; cursor: pointer; padding: 5px; transition: 0.2s;" onmouseover="this.style.color='#ef4444'" onmouseout="this.style.color='#94a3b8'"><i class="fa-solid fa-xmark"></i></button>
        <h2 style="margin-top: 0; color: #1e293b; margin-bottom: 20px;">나의 문의내역 조회</h2>
        
        <div style="display: flex; gap: 10px; margin-bottom: 30px;">
            <input type="email" id="search-email" placeholder="문의 시 등록한 이메일 주소 입력" style="flex: 1; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px;">
            <button onclick="checkMyInquiry()" class="btn-primary" style="padding: 12px 20px;">조회</button>
        </div>
        
        <div id="inquiry-results" style="display: flex; flex-direction: column; gap: 20px;">
            <div style="text-align: center; color: #94a3b8; padding: 30px;">이메일 주소를 입력하고 조회해주세요.</div>
        </div>
    </dialog>
"@

$jsFunc = @"
function checkMyInquiry() {
    const email = document.getElementById('search-email').value.trim();
    const resultsDiv = document.getElementById('inquiry-results');
    
    if(!email) {
        alert("이메일 주소를 입력해주세요.");
        return;
    }
    
    let inquiries = JSON.parse(localStorage.getItem('batech_inquiries') || '[]');
    let myInquiries = inquiries.filter(i => i.email === email);
    
    if(myInquiries.length === 0) {
        resultsDiv.innerHTML = `<div style="text-align: center; color: #ef4444; padding: 30px;">해당 이메일로 접수된 문의 내역이 없습니다.</div>`;
        return;
    }
    
    let html = "";
    myInquiries.forEach(inq => {
        const isDone = inq.status === 'done';
        const statusBadge = isDone 
            ? `<span style="background: #dcfce7; color: #16a34a; padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: bold;">처리 완료</span>`
            : `<span style="background: #ffedd5; color: #ea580c; padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: bold;">답변 대기</span>`;
            
        let replyHtml = "";
        if(isDone && inq.reply) {
            replyHtml = `
                <div style="margin-top: 15px; padding: 15px; background: #f8fafc; border-left: 4px solid #3b82f6; border-radius: 0 8px 8px 0;">
                    <strong style="color: #1e293b; display: block; margin-bottom: 8px;">담당자 답변</strong>
                    <div style="color: #475569; font-size: 0.95rem; white-space: pre-wrap;">`+inq.reply+`</div>
                </div>
            `;
        }
        
        html += `
            <div style="border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 15px;">
                    <div>${statusBadge}</div>
                    <div style="color: #94a3b8; font-size: 0.9rem;">${inq.date}</div>
                </div>
                <h3 style="margin: 0 0 10px 0; font-size: 1.1rem; color: #0f172a;">${inq.subject}</h3>
                <p style="margin: 0; color: #64748b; font-size: 0.95rem;">${inq.message}</p>
                ${replyHtml}
            </div>
        `;
    });
    
    resultsDiv.innerHTML = html;
}
</script>
"@

$inquirySrc = $inquirySrc -replace '</script>', "$jsFunc"
$inquirySrc = $inquirySrc -replace '</body>', "$modalHtml`n</body>"

[IO.File]::WriteAllText("inquiry.html", $inquirySrc, $utf8)

