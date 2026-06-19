$utf8 = New-Object System.Text.UTF8Encoding $false
$inquirySrc = [IO.File]::ReadAllText("inquiry.html", $utf8)

# 1. Replace form tag
$oldFormTag = '<form action="https://formspree.io/f/xdoqbqol" method="POST">'
$newFormTag = '<form id="inquiry-form" onsubmit="submitInquiry(event)">'
$inquirySrc = $inquirySrc.Replace($oldFormTag, $newFormTag)

# 2. Inject JS right before </body>
$js = @"
<script>
function submitInquiry(e) {
    e.preventDefault();
    
    // Get form data
    const form = document.getElementById('inquiry-form');
    const formData = new FormData(form);
    
    const name = formData.get('name');
    const contact = formData.get('contact');
    const email = formData.get('email');
    const subject = formData.get('subject');
    const message = formData.get('message');
    
    // Create Date string YYYY-MM-DD HH:MM
    const now = new Date();
    const pad = (n) => String(n).padStart(2, '0');
    const dateStr = now.getFullYear() + '-' + pad(now.getMonth()+1) + '-' + pad(now.getDate()) + ' ' + pad(now.getHours()) + ':' + pad(now.getMinutes());
    
    // Create new inquiry object
    const newInquiry = {
        id: 'inq_' + Date.now(),
        status: 'wait',
        date: dateStr,
        name: name,
        contact: contact,
        email: email,
        type: '일반 문의',
        subject: subject,
        message: message
    };
    
    // Save to localStorage
    let inquiries = JSON.parse(localStorage.getItem('batech_inquiries') || '[]');
    inquiries.unshift(newInquiry);
    localStorage.setItem('batech_inquiries', JSON.stringify(inquiries));
    
    // Show success and clear
    alert('고객님의 문의가 성공적으로 접수되었습니다.\n담당자가 확인 후 입력하신 이메일(' + email + ')로 답변을 드리겠습니다.');
    form.reset();
}
</script>
</body>
"@

$inquirySrc = $inquirySrc -replace '</body>', $js

[IO.File]::WriteAllText("inquiry.html", $inquirySrc, $utf8)

