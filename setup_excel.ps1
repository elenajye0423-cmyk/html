$utf8 = New-Object System.Text.UTF8Encoding $false
$portalSrc = [IO.File]::ReadAllText("portal.html", $utf8)

# 1. Update Excel Button
$portalSrc = $portalSrc -replace "onclick=`"alert\(`'엑셀 파일로 다운로드 됩니다\.`'\);`"", "onclick=`"downloadExcel()`""
$portalSrc = $portalSrc -replace 'onclick="alert\(`엑셀 파일로 다운로드 됩니다.`\);"', 'onclick="downloadExcel()"'

# 2. Update submitReply alerts
$oldAlerts = 'alert\("메일 발송 서버와 연동 중\.\.\."\);\s*alert\("고객에게 이메일이 발송되었습니다!"\);'
$newAlerts = "alert(`"메일 발송 준비가 완료되었습니다.\n확인을 누르시면 기본 메일 앱(아웃룩, 메일 등)이 열립니다.\n반드시 열린 메일 창에서 '보내기'를 눌러야 실제 발송이 완료됩니다.`");"
$portalSrc = [regex]::Replace($portalSrc, $oldAlerts, $newAlerts)

# 3. Add downloadExcel function
$excelFunc = @"
        function downloadExcel() {
            let inquiries = JSON.parse(localStorage.getItem("batech_inquiries") || "[]");
            if(inquiries.length === 0) return alert("다운로드할 데이터가 없습니다.");
            
            // BOM for Excel Korean support
            let csvContent = "\uFEFF상태,접수일시,고객명,연락처,이메일,문의유형,제목,내용\n";
            
            inquiries.forEach(inq => {
                let status = inq.status === "wait" ? "답변 대기" : "처리 완료";
                let row = [
                    status,
                    inq.date,
                    inq.name,
                    inq.contact,
                    inq.email,
                    inq.type,
                    `"` + (inq.subject || "").replace(/"/g, '""') + `"`,
                    `"` + (inq.message || "").replace(/"/g, '""') + `"`
                ].join(",");
                csvContent += row + "\n";
            });
            
            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = url;
            a.download = "비에이텍_고객문의내역.csv";
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }
"@

$portalSrc = $portalSrc -replace 'function submitReply\(\) \{', "$excelFunc`n`n        function submitReply() {"

[IO.File]::WriteAllText("portal.html", $portalSrc, $utf8)

