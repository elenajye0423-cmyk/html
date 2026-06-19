const fs = require('fs');

// 1. Fix inquiry.html corruption and modal
let inquiry = fs.readFileSync('inquiry.html', 'utf8');

// Fix the button above the form
inquiry = inquiry.replace(/<div style="text-align: right; margin-bottom: 20px;">[\s\S]*?<\/button>\s*<\/div>/, `<div style="text-align: right; margin-bottom: 20px;">
    <button type="button" class="btn-primary" style="background: white; color: var(--primary-color); border: 2px solid var(--primary-color); font-weight: bold; padding: 10px 20px;" onclick="document.getElementById('check-inquiry-modal').showModal()">🔍 나의 문의내역 조회</button>
</div>`);

// Fix the modal and its corrupted text
inquiry = inquiry.replace(/<!-- Inquiry Check Modal -->[\s\S]*?<\/body>/, `<!-- Inquiry Check Modal -->
    <dialog id="check-inquiry-modal" style="background: #ffffff; color: #1e293b; border: none; border-radius: 16px; padding: 2.5rem; box-shadow: 0 10px 40px rgba(0,0,0,0.2); max-width: 600px; width: 100%; margin: 0; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); max-height: 85vh; overflow-y: auto;">
        <button onclick="this.closest('dialog').close()" style="position: absolute; top: 20px; right: 20px; background: transparent; border: none; font-size: 1.5rem; color: #94a3b8; cursor: pointer; padding: 5px; transition: 0.2s;" onmouseover="this.style.color='#ef4444'" onmouseout="this.style.color='#94a3b8'">&#10005;</button>
        <h2 style="margin-top: 0; color: #1e293b; margin-bottom: 20px;">나의 문의내역 조회</h2>
        
        <div style="display: flex; gap: 10px; margin-bottom: 30px;">
            <input type="email" id="search-email" placeholder="문의 시 등록한 이메일 주소 입력" style="background: #ffffff; flex: 1; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; color: #1e293b;">
            <button onclick="checkMyInquiry()" style="background: #2563eb; color: #ffffff; border: none; border-radius: 8px; padding: 12px 20px; font-weight: bold; cursor: pointer;">조회</button>
        </div>
        
        <div id="inquiry-results" style="display: flex; flex-direction: column; gap: 20px;">
            <div style="text-align: center; color: #94a3b8; padding: 30px;">이메일 주소를 입력하고 조회해주세요.</div>
        </div>
    </dialog>
</body>`);

// Fix corrupted Javascript strings in checkMyInquiry function
// Replace broken korean text with proper korean text
inquiry = inquiry.replace(/<div style="text-align: center; color: #ef4444; padding: 30px;">.*?<\/div>/g, '<div style="text-align: center; color: #ef4444; padding: 30px;">해당 이메일로 접수된 문의 내역이 없습니다.</div>');
inquiry = inquiry.replace(/<strong style="color: #1e293b; display: block; margin-bottom: 8px;">.*?<\/strong>/g, '<strong style="color: #1e293b; display: block; margin-bottom: 8px;">담당자 답변</strong>');
inquiry = inquiry.replace(/<span style="background: #dcfce7; color: #16a34a; padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: bold;">.*?<\/span>/g, '<span style="background: #dcfce7; color: #16a34a; padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: bold;">처리 완료</span>');
inquiry = inquiry.replace(/<span style="background: #ffedd5; color: #ea580c; padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: bold;">.*?<\/span>/g, '<span style="background: #ffedd5; color: #ea580c; padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: bold;">답변 대기</span>');

fs.writeFileSync('inquiry.html', inquiry, 'utf8');

// 2. Fix the fa-xmark globally to &#10005; (a native heavy multiplication x mark)
const files = fs.readdirSync('.');
files.forEach(file => {
    if(file.endsWith('.html')) {
        let content = fs.readFileSync(file, 'utf8');
        if(content.includes('<i class="fa-solid fa-xmark"></i>')) {
            content = content.replace(/<i class="fa-solid fa-xmark"><\/i>/g, '&#10005;');
            fs.writeFileSync(file, content, 'utf8');
            console.log('Fixed xmark in ' + file);
        }
    }
});
