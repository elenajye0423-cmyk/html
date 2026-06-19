$utf8 = New-Object System.Text.UTF8Encoding $false

# 1. Rename dummy files to force download (binary/doc)
if (Test-Path "leave_form.html") { Rename-Item "leave_form.html" "leave_form.doc" -Force }
if (Test-Path "dummy_file.txt") { Rename-Item "dummy_file.txt" "dummy_download.bin" -Force }

# 2. Update HTML
$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

# Clean wipe to V2 to guarantee 0 views and correct defaults
$newInit = @'
        function initArchive() {
            if(!localStorage.getItem("batech_archive_v2")) {
                localStorage.removeItem("batech_archive_v1"); // Nuke old data
                let defaults = [
                    { id: "a_nb", title: "[추천] NotebookLM 업무 활용법 카드뉴스", date: "2026.06.09", views: 0, files: [{name: "NotebookLM_업무활용법.pdf", url: "dummy_download.bin"}], content: "<h3 style='margin-bottom: 15px;'>1. 문서 분석 요약 자동화</h3><p style='margin-bottom: 10px;'>방대한 양의 문서를 쉽고 빠르게 요약하여 업무 효율성을 극대화합니다.</p><p>자세한 내용은 상단 첨부파일을 확인해주세요.</p>", isSpecial: true },
                    { id: "a_vac", title: "연차/반차 휴가 신청서 양식 (2026 갱신)", date: "2026.01.10", views: 0, files: [{name: "연차_반차_휴가_신청서_양식.doc", url: "leave_form.doc"}], content: "<h3 style='margin-bottom: 15px;'>2026년도 연차/반차 신청 안내</h3><p style='margin-bottom: 10px;'>새롭게 갱신된 2026년도 휴가 신청서 양식입니다.</p><p style='margin-bottom: 10px;'><strong>1. 신청기간:</strong> 사용 예정일 최소 3일 전까지 결재 완료 (기간 준수)</p><p style='margin-bottom: 10px;'><strong>2. 제출처:</strong> 소속 부서장 결재 후 총무부 서면 제출</p><br><p>상단의 첨부파일을 클릭하여 다운로드 받으신 후 작성 바랍니다.</p>" },
                    { id: "a_logo", title: "회사 공식 로고 원본 파일 (AI, PNG, JPG)", date: "2026.01.05", views: 0, files: [{name: "BATECH_Logo_AI.zip", url: "dummy_download.bin"}, {name: "BATECH_Logo_PNG_JPG.zip", url: "dummy_download.bin"}], content: "<p style='margin-bottom: 10px;'>비에이텍 공식 기업 로고 파일입니다.</p><p>대외 홍보물 및 공식 문서 작성 시 해당 로고를 사용해주시기 바랍니다.</p>" },
                    { id: "a_card", title: "법인카드 지출 결의서 양식 및 매뉴얼", date: "2025.12.20", views: 0, files: [{name: "지출결의서_양식_2026.xlsx", url: "dummy_download.bin"}, {name: "법인카드_사용_매뉴얼.pdf", url: "dummy_download.bin"}], content: "<p style='margin-bottom: 10px;'>법인카드 사용 후 제출해야 하는 지출 결의서 양식과 작성 매뉴얼입니다.</p><p>매월 5일까지 전월 사용분을 총무부로 제출해 주시기 바랍니다.</p>" }
                ];
                localStorage.setItem("batech_archive_v2", JSON.stringify(defaults));
            }
        }
'@

$archiveSrc = $archiveSrc -replace '(?s)function initArchive\(\) \{.*?\}', $newInit

# Remove old migration entirely
$archiveSrc = $archiveSrc -replace '(?s)function migrateArchiveData\(\) \{.*?\}', ''
$archiveSrc = $archiveSrc -replace 'migrateArchiveData\(\);', ''

# Completely rewrite openArchive to kill target="_blank"
$newOpenArchive = @'
        function openArchive(key) {
            let archives = JSON.parse(localStorage.getItem("batech_archive_v2") || "[]");
            const data = archives.find(x => x.id === key);
            if(!data) return;
            
            document.getElementById("read-arch-id").value = key;
            document.getElementById('arch-title').innerText = data.title;
            document.getElementById('arch-date').innerText = data.date;
            document.getElementById('arch-views').innerText = data.views;
            
            let filesHtml = "";
            const paperclipSvg = `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink: 0;"><path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48"></path></svg>`;
            if(data.files) {
                data.files.forEach(f => {
                    filesHtml += `
                        <a href="${f.url}" download="${f.name}" style="color: #333; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; font-size: 1.1rem; padding: 2px 0; transition: color 0.2s;" onmouseover="this.style.color='#2563eb'" onmouseout="this.style.color='#333'">
                            ${paperclipSvg} <span>${f.name}</span>
                        </a>
                    `;
                });
            }
            document.getElementById('arch-files').innerHTML = filesHtml;
            document.getElementById('arch-content').innerHTML = data.content;
            
            document.getElementById('archive-detail-modal').showModal();
            
            // Increment views
            let idx = archives.findIndex(x => x.id === key);
            archives[idx].views += 1;
            localStorage.setItem("batech_archive_v2", JSON.stringify(archives));
            renderArchiveList();
        }
'@

$archiveSrc = $archiveSrc -replace '(?s)function openArchive\(key\) \{.*?(?=document\.addEventListener)', "$newOpenArchive`r`n`r`n        "

# Update ALL references of batech_archive_v1 to v2 everywhere
$archiveSrc = $archiveSrc -replace 'batech_archive_v1', 'batech_archive_v2'

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

