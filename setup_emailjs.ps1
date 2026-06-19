$utf8 = New-Object System.Text.UTF8Encoding $false
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)

# 1. Inject EmailJS SDK
$emailJsScript = @"
    <!-- EmailJS SDK -->
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"></script>
    <script type="text/javascript">
       (function(){
          emailjs.init("aeEdyX2nzOuE7TPMn");
       })();
    </script>
</head>
"@
$portalSrc = $portalSrc -replace '</head>', $emailJsScript

# 2. Replace submitReply function
# Find the old submitReply function
$oldSubmitReply = '(?s)function submitReply\(\) \{.*?document\.getElementById\("reply-modal"\)\.close\(\);\s*loadInquiries\(\);\s*\}'

$newSubmitReply = @"
function submitReply() {
            const content = document.getElementById("reply-content").value;
            if(!content) { alert("답변 내용을 입력해주세요."); return; }
            
            let inquiries = JSON.parse(localStorage.getItem("batech_inquiries") || "[]");
            let inq = inquiries.find(i => i.id === currentReplyId);
            if(inq) {
                // Change status to done temporarily
                inq.status = "done";
                localStorage.setItem("batech_inquiries", JSON.stringify(inquiries));
                
                // Change button text to indicate loading
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
                        // Revert status
                        inq.status = "wait";
                        localStorage.setItem("batech_inquiries", JSON.stringify(inquiries));
                        btn.innerText = oldText;
                        btn.disabled = false;
                        loadInquiries();
                    });
            }
        }
"@

$portalSrc = [regex]::Replace($portalSrc, $oldSubmitReply, $newSubmitReply)

[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)

