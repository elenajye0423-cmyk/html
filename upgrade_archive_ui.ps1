$utf8 = New-Object System.Text.UTF8Encoding $false

# --- portal_archive.html ---
$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

# Replace the table part
$newTable = @'
        <table class="archive-list">
            <thead>
                <tr>
                    <th>파일명</th>
                    <th>등록일</th>
                </tr>
            </thead>
            <tbody>
                <tr class="nb-highlight" onclick="openArchive('nb')">
                    <td><span class="file-icon">📙</span><strong>[추천] NotebookLM 업무 활용법 카드뉴스</strong></td>
                    <td>2026.06.09</td>
                </tr>
                <tr onclick="openArchive('vacation')">
                    <td><span class="file-icon">📄</span>연차/반차 휴가 신청서 양식 (2026 갱신)</td>
                    <td>2026.01.10</td>
                </tr>
                <tr onclick="openArchive('logo')">
                    <td><span class="file-icon">🖼️</span>회사 공식 로고 원본 파일 (AI, PNG, JPG)</td>
                    <td>2026.01.05</td>
                </tr>
                <tr onclick="openArchive('card')">
                    <td><span class="file-icon">📄</span>법인카드 지출 결의서 양식 및 매뉴얼</td>
                    <td>2025.12.20</td>
                </tr>
            </tbody>
        </table>
'@

$archiveSrc = $archiveSrc -replace '(?s)<table class="archive-list">.*?</table>', $newTable

# Replace the modal part
$newModal = @'
    <!-- Archive Detail Modal (Design updated to match reference) -->
    <dialog id="archive-detail-modal" style="border: none; border-radius: 12px; padding: 2.5rem; box-shadow: 0 10px 40px rgba(0,0,0,0.3); max-width: 800px; width: 100%; margin: 0; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); max-height: 85vh; overflow-y: auto;">
        <h2 id="arch-title" style="margin-top: 0; margin-bottom: 15px; font-size: 1.8rem; color: #111;"></h2>
        
        <div style="color: #666; font-size: 1rem; margin-bottom: 25px;">
            등록일 : <span id="arch-date"></span> &nbsp;<span style="color:#ddd; margin: 0 5px;">|</span>&nbsp; 조회수 : <span id="arch-views"></span>
        </div>
        
        <div style="border-top: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea; padding: 20px 0; margin-bottom: 30px;">
            <div id="arch-files" style="display: flex; flex-direction: column; gap: 12px;">
                <!-- Files injected here -->
            </div>
        </div>
        
        <div id="arch-content" style="min-height: 150px; font-size: 1.05rem; color: #222; line-height: 1.7;">
            <!-- Content injected here -->
        </div>
        
        <div style="text-align: right; margin-top: 30px;">
            <button class="btn-sm" style="background: #e2e8f0; color: #475569;" onclick="document.getElementById(`archive-detail-modal`).close()">닫기</button>
        </div>
    </dialog>
'@

$archiveSrc = $archiveSrc -replace '(?s)<!-- NotebookLM Modal Viewer -->.*?</dialog>', $newModal

# Replace Script
$newScript = @'
    <script>
        function tryUpload() {
            const pwd = prompt("자료를 업로드하려면 관리자 암호를 입력하세요:");
            if (pwd === "1234") {
                alert("인증 성공! 자료 업로드 팝업이 열립니다.");
            } else if (pwd !== null) {
                alert("비밀번호가 일치하지 않습니다. 업로드 권한이 없습니다.");
            }
        }

        const archiveData = {
            'nb': {
                title: '[추천] NotebookLM 업무 활용법 카드뉴스',
                date: '2026.06.09',
                views: 154,
                files: [
                    { name: 'NotebookLM_업무활용법.pdf', url: 'notebooklm_cardnews.html' }
                ],
                content: `
                    <h3 style="margin-bottom: 15px;">1. 문서 분석 요약 자동화</h3>
                    <p style="margin-bottom: 10px;">방대한 양의 문서를 쉽고 빠르게 요약하여 업무 효율성을 극대화합니다.</p>
                    <p>자세한 내용은 상단 첨부파일을 확인해주세요.</p>
                `
            },
            'vacation': {
                title: '연차/반차 휴가 신청서 양식 (2026 갱신)',
                date: '2026.01.10',
                views: 342,
                files: [
                    { name: '연차_반차_휴가_신청서_양식.html', url: '연차_반차_휴가_신청서_양식.html' }
                ],
                content: `
                    <h3 style="margin-bottom: 15px;">2026년도 연차/반차 신청 안내</h3>
                    <p style="margin-bottom: 10px;">새롭게 갱신된 2026년도 휴가 신청서 양식입니다.</p>
                    <p style="margin-bottom: 10px;"><strong>1. 신청기간:</strong> 사용 예정일 최소 3일 전까지 결재 완료 (기간 준수)</p>
                    <p style="margin-bottom: 10px;"><strong>2. 제출처:</strong> 소속 부서장 결재 후 인사총무팀 서면 제출</p>
                    <br>
                    <p>상단의 첨부파일을 클릭하여 다운로드 받으신 후 작성 바랍니다.</p>
                `
            },
            'logo': {
                title: '회사 공식 로고 원본 파일 (AI, PNG, JPG)',
                date: '2026.01.05',
                views: 89,
                files: [
                    { name: 'BATECH_Logo_AI.zip', url: '#' },
                    { name: 'BATECH_Logo_PNG_JPG.zip', url: '#' }
                ],
                content: `
                    <p style="margin-bottom: 10px;">비에이텍 공식 기업 로고 파일입니다.</p>
                    <p>대외 홍보물 및 공식 문서 작성 시 해당 로고를 사용해주시기 바랍니다.</p>
                `
            },
            'card': {
                title: '법인카드 지출 결의서 양식 및 매뉴얼',
                date: '2025.12.20',
                views: 215,
                files: [
                    { name: '지출결의서_양식_2026.xlsx', url: '#' },
                    { name: '법인카드_사용_매뉴얼.pdf', url: '#' }
                ],
                content: `
                    <p style="margin-bottom: 10px;">법인카드 사용 후 제출해야 하는 지출 결의서 양식과 작성 매뉴얼입니다.</p>
                    <p>매월 5일까지 전월 사용분을 재무팀으로 제출해 주시기 바랍니다.</p>
                `
            }
        };

        function openArchive(key) {
            const data = archiveData[key];
            document.getElementById('arch-title').innerText = data.title;
            document.getElementById('arch-date').innerText = data.date;
            document.getElementById('arch-views').innerText = data.views;
            
            let filesHtml = "";
            const paperclipSvg = `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink: 0;"><path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48"></path></svg>`;
            data.files.forEach(f => {
                filesHtml += `
                    <a href="${f.url}" download="${f.name !== '#' ? f.name : ''}" target="${f.url.endsWith('.html') ? '_blank' : '_self'}" style="color: #333; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; font-size: 1.1rem; padding: 2px 0; transition: color 0.2s;" onmouseover="this.style.color='#2563eb'" onmouseout="this.style.color='#333'">
                        ${paperclipSvg} <span>${f.name}</span>
                    </a>
                `;
            });
            document.getElementById('arch-files').innerHTML = filesHtml;
            document.getElementById('arch-content').innerHTML = data.content;
            
            document.getElementById('archive-detail-modal').showModal();
            
            // Simple view count increment for mockup
            archiveData[key].views += 1;
        }
    </script>
'@

$archiveSrc = $archiveSrc -replace '(?s)<script>.*?function tryUpload\(\).*?</script>', $newScript

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

