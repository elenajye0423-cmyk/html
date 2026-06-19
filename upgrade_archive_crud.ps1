$utf8 = New-Object System.Text.UTF8Encoding $false

# --- portal_archive.html ---
$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

# Inject Modals
$newModals = @'
    <!-- Password Prompt Modal -->
    <dialog id="archive-pwd-modal" style="border: none; border-radius: 12px; padding: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.2); max-width: 400px; width: 100%; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); margin: 0;">
        <h3 style="margin-top: 0; margin-bottom: 1rem; color: #1e293b;">보안 암호 확인</h3>
        <p style="font-size: 0.9rem; color: #64748b; margin-bottom: 1.5rem;" id="pwd-modal-desc">해당 작업을 수행하려면 관리자 암호가 필요합니다.</p>
        <input type="password" id="action-pwd" class="input-box" placeholder="관리자 암호 입력" style="margin-bottom: 1rem; padding: 10px; width: 100%; box-sizing: border-box; border: 1px solid #cbd5e1; border-radius: 6px;" onkeypress="if(event.key === 'Enter') submitPwd()">
        <div style="text-align: right; display: flex; justify-content: flex-end; gap: 10px;">
            <button class="btn-sm" onclick="document.getElementById(`archive-pwd-modal`).close()">취소</button>
            <button class="btn-sm primary" onclick="submitPwd()">확인</button>
        </div>
    </dialog>

    <!-- Upload/Edit Modal -->
    <dialog id="archive-upload-modal" style="border: none; border-radius: 12px; padding: 2.5rem; box-shadow: 0 10px 40px rgba(0,0,0,0.3); max-width: 600px; width: 100%; margin: 0; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); max-height: 85vh; overflow-y: auto;">
        <h2 id="upload-modal-title" style="margin-top: 0; margin-bottom: 1.5rem; color: #1e293b;">자료 업로드</h2>
        <input type="hidden" id="edit-archive-id">
        
        <div style="margin-bottom: 15px;">
            <label style="display: block; font-weight: 600; margin-bottom: 5px;">제목 <span style="color:#dc2626;">*</span></label>
            <input type="text" id="up-title" class="input-box" placeholder="자료 제목 입력" style="width:100%; box-sizing:border-box; padding:10px; border:1px solid #cbd5e1; border-radius:6px;" required>
        </div>
        
        <div style="margin-bottom: 15px;">
            <label style="display: block; font-weight: 600; margin-bottom: 5px;">첨부 파일 <span style="color:#dc2626;">*</span></label>
            <input type="file" id="up-file" class="input-box" style="width:100%; box-sizing:border-box; padding:10px; border:1px solid #cbd5e1; border-radius:6px;" multiple>
            <small style="color:#64748b; display:block; margin-top:5px;" id="up-file-hint">* 기존 파일을 유지하려면 비워두세요 (수정 시)</small>
        </div>
        
        <div style="margin-bottom: 25px;">
            <label style="display: block; font-weight: 600; margin-bottom: 5px;">상세 내용</label>
            <textarea id="up-content" class="input-box" style="width:100%; box-sizing:border-box; padding:10px; border:1px solid #cbd5e1; border-radius:6px; height: 120px; resize: none;"></textarea>
        </div>
        
        <div style="text-align: right; display: flex; justify-content: space-between; align-items: center; gap: 10px;">
            <button id="btn-delete-archive" class="btn-sm" style="background: #fee2e2; color: #991b1b; display: none;" onclick="promptPwd('delete')">자료 삭제</button>
            <div style="display: flex; gap: 10px; margin-left: auto;">
                <button class="btn-sm" style="background: #e2e8f0; color: #475569;" onclick="document.getElementById(`archive-upload-modal`).close()">취소</button>
                <button class="btn-sm primary" onclick="saveArchive()">저장</button>
            </div>
        </div>
    </dialog>
'@

# Replace existing modals
$archiveSrc = $archiveSrc -replace '(?s)<!-- Archive Detail Modal.*?</div>\s*</dialog>', "$newModals`r`n`r`n    <!-- Archive Detail Modal (Design updated to match reference) -->
    <dialog id=`"archive-detail-modal`" style=`"border: none; border-radius: 12px; padding: 2.5rem; box-shadow: 0 10px 40px rgba(0,0,0,0.3); max-width: 800px; width: 100%; margin: 0; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); max-height: 85vh; overflow-y: auto;`">
        <h2 id=`"arch-title`" style=`"margin-top: 0; margin-bottom: 15px; font-size: 1.8rem; color: #111;`"></h2>
        <input type=`"hidden`" id=`"read-arch-id`">
        
        <div style=`"color: #666; font-size: 1rem; margin-bottom: 25px;`">
            등록일 : <span id=`"arch-date`"></span> &nbsp;<span style=`"color:#ddd; margin: 0 5px;`">|</span>&nbsp; 조회수 : <span id=`"arch-views`"></span>
        </div>
        
        <div style=`"border-top: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea; padding: 20px 0; margin-bottom: 30px;`">
            <div id=`"arch-files`" style=`"display: flex; flex-direction: column; gap: 12px;`"></div>
        </div>
        
        <div id=`"arch-content`" style=`"min-height: 150px; font-size: 1.05rem; color: #222; line-height: 1.7;`"></div>
        
        <div style=`"text-align: right; margin-top: 30px; display: flex; justify-content: space-between; align-items: center;`">
            <button class=`"btn-sm`" style=`"background: #fff; border: 1px solid #cbd5e1; color: #64748b;`" onclick=`"promptPwd('edit')`">수정 및 삭제하기</button>
            <button class=`"btn-sm`" style=`"background: #e2e8f0; color: #475569;`" onclick=`"document.getElementById('archive-detail-modal').close()`">닫기</button>
        </div>
    </dialog>"

# Update Javascript
$newScript = @'
    <script>
        function initArchive() {
            if(!localStorage.getItem("batech_archive_v1")) {
                let defaults = [
                    { id: "a_nb", title: "[추천] NotebookLM 업무 활용법 카드뉴스", date: "2026.06.09", views: 154, files: [{name: "NotebookLM_업무활용법.pdf", url: "notebooklm_cardnews.html"}], content: "<h3 style='margin-bottom: 15px;'>1. 문서 분석 요약 자동화</h3><p style='margin-bottom: 10px;'>방대한 양의 문서를 쉽고 빠르게 요약하여 업무 효율성을 극대화합니다.</p><p>자세한 내용은 상단 첨부파일을 확인해주세요.</p>", isSpecial: true },
                    { id: "a_vac", title: "연차/반차 휴가 신청서 양식 (2026 갱신)", date: "2026.01.10", views: 342, files: [{name: "연차_반차_휴가_신청서_양식.html", url: "연차_반차_휴가_신청서_양식.html"}], content: "<h3 style='margin-bottom: 15px;'>2026년도 연차/반차 신청 안내</h3><p style='margin-bottom: 10px;'>새롭게 갱신된 2026년도 휴가 신청서 양식입니다.</p><p style='margin-bottom: 10px;'><strong>1. 신청기간:</strong> 사용 예정일 최소 3일 전까지 결재 완료 (기간 준수)</p><p style='margin-bottom: 10px;'><strong>2. 제출처:</strong> 소속 부서장 결재 후 인사총무팀 서면 제출</p><br><p>상단의 첨부파일을 클릭하여 다운로드 받으신 후 작성 바랍니다.</p>" },
                    { id: "a_logo", title: "회사 공식 로고 원본 파일 (AI, PNG, JPG)", date: "2026.01.05", views: 89, files: [{name: "BATECH_Logo_AI.zip", url: "#"}, {name: "BATECH_Logo_PNG_JPG.zip", url: "#"}], content: "<p style='margin-bottom: 10px;'>비에이텍 공식 기업 로고 파일입니다.</p><p>대외 홍보물 및 공식 문서 작성 시 해당 로고를 사용해주시기 바랍니다.</p>" },
                    { id: "a_card", title: "법인카드 지출 결의서 양식 및 매뉴얼", date: "2025.12.20", views: 215, files: [{name: "지출결의서_양식_2026.xlsx", url: "#"}, {name: "법인카드_사용_매뉴얼.pdf", url: "#"}], content: "<p style='margin-bottom: 10px;'>법인카드 사용 후 제출해야 하는 지출 결의서 양식과 작성 매뉴얼입니다.</p><p>매월 5일까지 전월 사용분을 재무팀으로 제출해 주시기 바랍니다.</p>" }
                ];
                localStorage.setItem("batech_archive_v1", JSON.stringify(defaults));
            }
        }

        function renderArchiveList() {
            let archives = JSON.parse(localStorage.getItem("batech_archive_v1") || "[]");
            let tbody = document.querySelector(".archive-list tbody");
            tbody.innerHTML = "";
            
            archives.forEach(a => {
                let icon = "📄";
                if(a.title.includes("로고") || a.title.includes("이미지")) icon = "🖼️";
                if(a.isSpecial) icon = "📙";
                
                let trClass = a.isSpecial ? "class='nb-highlight'" : "";
                let titleHtml = a.isSpecial ? `<strong>${a.title}</strong>` : a.title;
                
                tbody.innerHTML += `
                    <tr ${trClass} onclick="openArchive('${a.id}')">
                        <td><span class="file-icon">${icon}</span>${titleHtml}</td>
                        <td>${a.date}</td>
                    </tr>
                `;
            });
        }

        let pendingAction = null;

        function promptPwd(actionType) {
            pendingAction = actionType;
            let desc = "";
            if(actionType === "add") desc = "자료를 업로드하려면 관리자 암호가 필요합니다.";
            if(actionType === "edit") desc = "자료를 수정/삭제하려면 관리자 암호가 필요합니다.";
            if(actionType === "delete") desc = "자료를 완전히 삭제하려면 관리자 암호가 필요합니다.";
            
            document.getElementById("pwd-modal-desc").innerText = desc;
            document.getElementById("action-pwd").value = "";
            document.getElementById("archive-pwd-modal").showModal();
        }

        function submitPwd() {
            let pwd = document.getElementById("action-pwd").value;
            if(pwd !== "1234") {
                alert("보안 암호가 올바르지 않습니다.");
                return;
            }
            
            document.getElementById("archive-pwd-modal").close();
            
            if(pendingAction === "add") {
                openUploadModal();
            } else if(pendingAction === "edit") {
                openEditModal();
            } else if(pendingAction === "delete") {
                executeDelete();
            }
        }

        function tryUpload() {
            promptPwd("add");
        }

        function openUploadModal() {
            document.getElementById("upload-modal-title").innerText = "새 자료 업로드";
            document.getElementById("edit-archive-id").value = "";
            document.getElementById("up-title").value = "";
            document.getElementById("up-file").value = "";
            document.getElementById("up-content").value = "";
            document.getElementById("btn-delete-archive").style.display = "none";
            document.getElementById("archive-upload-modal").showModal();
        }

        function openEditModal() {
            document.getElementById("archive-detail-modal").close();
            
            let id = document.getElementById("read-arch-id").value;
            let archives = JSON.parse(localStorage.getItem("batech_archive_v1") || "[]");
            let data = archives.find(x => x.id === id);
            if(!data) return;
            
            document.getElementById("upload-modal-title").innerText = "자료 수정";
            document.getElementById("edit-archive-id").value = id;
            document.getElementById("up-title").value = data.title;
            document.getElementById("up-file").value = "";
            document.getElementById("up-content").value = data.content.replace(/<br>/g, "\n").replace(/<\/?[^>]+(>|$)/g, ""); // basic strip for edit
            document.getElementById("btn-delete-archive").style.display = "inline-block";
            document.getElementById("archive-upload-modal").showModal();
        }

        function saveArchive() {
            const title = document.getElementById("up-title").value;
            const content = document.getElementById("up-content").value.replace(/\n/g, "<br>");
            const fileInput = document.getElementById("up-file");
            const id = document.getElementById("edit-archive-id").value;
            
            if(!title) return alert("제목을 입력해주세요.");
            
            let archives = JSON.parse(localStorage.getItem("batech_archive_v1") || "[]");
            let files = [];
            
            if(fileInput.files.length > 0) {
                for(let i=0; i<fileInput.files.length; i++) {
                    files.push({ name: fileInput.files[i].name, url: "#" });
                }
            }
            
            if(id) {
                // Edit
                let idx = archives.findIndex(x => x.id === id);
                if(idx !== -1) {
                    archives[idx].title = title;
                    archives[idx].content = content;
                    if(files.length > 0) {
                        archives[idx].files = files; // Replace files if new ones uploaded
                    }
                }
            } else {
                // Add
                if(files.length === 0) return alert("최소 1개의 파일을 첨부해주세요.");
                let today = new Date();
                let dStr = today.getFullYear() + "." + String(today.getMonth()+1).padStart(2,"0") + "." + String(today.getDate()).padStart(2,"0");
                archives.unshift({
                    id: "a_" + Date.now(),
                    title: title,
                    date: dStr,
                    views: 0,
                    files: files,
                    content: content
                });
            }
            
            localStorage.setItem("batech_archive_v1", JSON.stringify(archives));
            document.getElementById("archive-upload-modal").close();
            renderArchiveList();
            alert("자료가 성공적으로 저장되었습니다.");
        }

        function executeDelete() {
            let id = document.getElementById("edit-archive-id").value;
            let archives = JSON.parse(localStorage.getItem("batech_archive_v1") || "[]");
            archives = archives.filter(x => x.id !== id);
            localStorage.setItem("batech_archive_v1", JSON.stringify(archives));
            
            document.getElementById("archive-upload-modal").close();
            renderArchiveList();
            alert("자료가 삭제되었습니다.");
        }

        function openArchive(key) {
            let archives = JSON.parse(localStorage.getItem("batech_archive_v1") || "[]");
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
                        <a href="${f.url}" download="${f.name !== '#' ? f.name : ''}" target="${f.url.endsWith('.html') ? '_blank' : '_self'}" style="color: #333; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; font-size: 1.1rem; padding: 2px 0; transition: color 0.2s;" onmouseover="this.style.color='#2563eb'" onmouseout="this.style.color='#333'">
                            ${paperclipSvg} <span>${f.name}</span>
                        </a>
                    `;
                });
            }
            document.getElementById('arch-files').innerHTML = filesHtml;
            document.getElementById('arch-content').innerHTML = data.content;
            
            document.getElementById('archive-detail-modal').showModal();
            
            // Simple view count increment
            let idx = archives.findIndex(x => x.id === key);
            archives[idx].views += 1;
            localStorage.setItem("batech_archive_v1", JSON.stringify(archives));
            renderArchiveList(); // update background list optionally
        }

        document.addEventListener("DOMContentLoaded", () => {
            initArchive();
            renderArchiveList();
        });
    </script>
'@

$archiveSrc = $archiveSrc -replace '(?s)<script>.*?function tryUpload\(\).*?</script>', $newScript

# We also need to empty out the static table body so the dynamic JS takes over
$archiveSrc = $archiveSrc -replace '(?s)<tbody>.*?</tbody>', '<tbody></tbody>'

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

