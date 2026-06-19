$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("inquiry.html", $utf8)

# 1. Strip all corrupted checkMyInquiry functions
$src = [regex]::Replace($src, '(?s)function checkMyInquiry\(\) \{.*?resultsDiv\.innerHTML = html;\s*\}', '')

# 2. Add color: #1e293b; to the search-email input
$src = $src -replace 'border-radius: 8px;">', 'border-radius: 8px; color: #1e293b;">'

# 3. Inject the CORRECT checkMyInquiry function (using single quotes @' ... '@ to prevent backtick evaluation!)
$correctJS = @'
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
                    <div style="color: #475569; font-size: 0.95rem; white-space: pre-wrap;">${inq.reply}</div>
                </div>
            `;
        }
        
        html += `
            <div style="border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-bottom: 15px;">
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
'@

# Replace the LAST </script> before the modal with our function + </script>
$src = [regex]::Replace($src, '</script>\s*(?=<!-- Inquiry Check Modal -->)', "`n$correctJS`n")

[IO.File]::WriteAllText("inquiry.html", $src, $utf8)

