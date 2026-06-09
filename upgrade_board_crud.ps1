$utf8 = New-Object System.Text.UTF8Encoding $false

$boardSrc = [IO.File]::ReadAllText("portal_board.html", $utf8)

# 1. Update Write Modal to include Password
$newWriteModal = @'
    <!-- Write Post Modal -->
    <dialog id="write-modal" class="modal">
        <h3 style="margin-top: 0; margin-bottom: 1.5rem; color: #1e293b;">익명 게시글 작성</h3>
        <div class="form-group">
            <label class="form-label">제목</label>
            <input type="text" id="post-title" class="input-box" placeholder="글 제목을 입력하세요">
        </div>
        <div class="form-group">
            <label class="form-label">게시글 암호</label>
            <input type="password" id="post-pwd" class="input-box" placeholder="수정/삭제 시 사용할 암호 4자리 이상">
        </div>
        <div class="form-group">
            <label class="form-label">내용</label>
            <textarea id="post-content" class="input-box" style="height: 150px; resize: none;" placeholder="자유롭게 의견을 작성해 주세요..."></textarea>
        </div>
        <div style="text-align: right; display: flex; justify-content: flex-end; gap: 10px;">
            <button class="btn-sm" onclick="document.getElementById('write-modal').close()">취소</button>
            <button class="btn-sm primary" onclick="submitPost()">게시물 등록</button>
        </div>
    </dialog>
'@
$boardSrc = $boardSrc -replace '(?s)<!-- Write Post Modal -->.*?</dialog>', $newWriteModal

# 2. Update Detail Modal to include Edit/Delete Buttons
$newReadModal = @'
    <!-- Read Post & Comments Modal -->
    <dialog id="read-modal" class="modal">
        <input type="hidden" id="read-post-id">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.5rem;">
            <h2 id="read-title" style="margin-top: 0; margin-bottom: 0; color: #1e293b; font-size: 1.4rem;"></h2>
            <div style="display: flex; gap: 8px;">
                <button class="btn-sm" style="background: #fff; border: 1px solid #cbd5e1; color: #64748b;" onclick="promptBoardPwd('edit')">수정</button>
                <button class="btn-sm" style="background: #fee2e2; border: 1px solid #fecaca; color: #991b1b;" onclick="promptBoardPwd('delete')">삭제</button>
            </div>
        </div>
        <div style="font-size: 0.85rem; color: #64748b; margin-bottom: 1.5rem; border-bottom: 1px solid #e2e8f0; padding-bottom: 1rem;">
            작성자: <span id="read-author"></span> &nbsp;|&nbsp; <span id="read-date"></span>
        </div>
        <div id="read-content" style="color: #334155; line-height: 1.6; min-height: 100px; white-space: pre-wrap;"></div>
        
        <div class="comments-section">
            <h4 style="margin-top: 0; color: #1e293b;">댓글 (<span id="comment-count">0</span>)</h4>
            <div id="comments-list"></div>
            
            <div class="comment-input-area">
                <input type="text" id="new-comment" class="input-box" placeholder="따뜻한 익명 댓글을 남겨보세요..." onkeypress="if(event.key === 'Enter') addComment()">
                <button class="btn-sm primary" style="white-space: nowrap;" onclick="addComment()">댓글 등록</button>
            </div>
        </div>

        <div style="text-align: right; margin-top: 20px;">
            <button class="btn-sm" style="background: #e2e8f0; color: #475569;" onclick="document.getElementById('read-modal').close()">닫기</button>
        </div>
    </dialog>

    <!-- Password Modal for Board -->
    <dialog id="board-pwd-modal" class="modal" style="max-width: 350px;">
        <h3 style="margin-top: 0; margin-bottom: 1rem; color: #1e293b;">게시글 암호 확인</h3>
        <p style="font-size: 0.9rem; color: #64748b; margin-bottom: 1.5rem;" id="board-pwd-desc">본인 확인을 위해 암호를 입력해주세요.</p>
        <input type="password" id="board-action-pwd" class="input-box" placeholder="게시글 암호 입력" style="margin-bottom: 1rem;" onkeypress="if(event.key === 'Enter') submitBoardPwd()">
        <div style="text-align: right; display: flex; justify-content: flex-end; gap: 10px;">
            <button class="btn-sm" onclick="document.getElementById('board-pwd-modal').close()">취소</button>
            <button class="btn-sm primary" onclick="submitBoardPwd()">확인</button>
        </div>
    </dialog>

    <!-- Edit Post Modal -->
    <dialog id="edit-modal" class="modal">
        <h3 style="margin-top: 0; margin-bottom: 1.5rem; color: #1e293b;">게시글 수정</h3>
        <input type="hidden" id="edit-post-id">
        <div class="form-group">
            <label class="form-label">제목</label>
            <input type="text" id="edit-title" class="input-box">
        </div>
        <div class="form-group">
            <label class="form-label">내용</label>
            <textarea id="edit-content" class="input-box" style="height: 150px; resize: none;"></textarea>
        </div>
        <div style="text-align: right; display: flex; justify-content: flex-end; gap: 10px;">
            <button class="btn-sm" onclick="document.getElementById('edit-modal').close()">취소</button>
            <button class="btn-sm primary" onclick="saveEditPost()">저장 완료</button>
        </div>
    </dialog>
'@
$boardSrc = $boardSrc -replace '(?s)<!-- Read Post & Comments Modal -->.*?</dialog>', $newReadModal

# 3. Javascript Updates
$newScripts = @'
        function initBoard() {
            if(!localStorage.getItem("batech_board_init_v4")) {
                let defaultPosts = [
                    { id: "b2", title: "휴게실 안마의자 진짜 너무 좋습니다 ㅠㅠ", content: "최근에 들어온 안마의자 써보신 분 계신가요?\n점심시간에 15분 누워있었는데 피로가 싹 풀리네요.\n총무부 감사합니다!!", author: "익명", date: "2026.06.08", password: "1234", comments: [{id: "c1", author: "익명", text: "저도 내일 점심에 써봐야겠네요 ㅎㅎ", replies: []}, {id: "c2", author: "익명", text: "경쟁이 치열합니다 일찍 가셔야 해요", replies: [{author: "익명", text: "맞아요 점심시간 땡치면 바로 뛰어가야함 ㅋㅋ"}]}] },
                    { id: "b1", title: "이번 주 금요일 회식 장소 투표 좀 해주세요", content: "이번 주 팀 회식인데 메뉴를 못 정하고 있습니다.\n1. 삼겹살\n2. 회\n3. 곱창\n\n댓글로 의견 좀 남겨주세요!", author: "익명", date: "2026.06.07", password: "1234", comments: [{id: "c3", author: "익명", text: "무조건 1번 삼겹살이죠", replies: []}, {id: "c4", author: "익명", text: "저는 2번 회 추천합니다!", replies: []}] }
                ];
                
                let oldPosts = JSON.parse(localStorage.getItem("batech_board_v3") || "[]");
                let v4Posts = [];
                if(oldPosts.length > 0) {
                    oldPosts.forEach(p => {
                        if(!p.password) p.password = "1234"; // default password for old posts
                        v4Posts.push(p);
                    });
                } else {
                    v4Posts = defaultPosts;
                }
                
                localStorage.setItem("batech_board_v4", JSON.stringify(v4Posts));
                localStorage.setItem("batech_board_init_v4", "true");
            }
        }

        function renderPosts() {
            const container = document.getElementById("posts-container");
            container.innerHTML = "";
            let posts = JSON.parse(localStorage.getItem("batech_board_v4") || "[]");
            
            posts.forEach(p => {
                let count = p.comments ? p.comments.length : 0;
                if(p.comments) {
                    p.comments.forEach(c => { count += (c.replies ? c.replies.length : 0); });
                }
                
                container.innerHTML += `
                    <li onclick="openPost(\`${p.id}\`)">
                        <div class="title">${p.title} <span style="color:#ef4444; font-size:0.9rem;">[${count}]</span></div>
                        <div class="meta">
                            <span>${p.author}</span>
                            <span>${p.date}</span>
                        </div>
                    </li>`;
            });
        }

        function submitPost() {
            const title = document.getElementById("post-title").value;
            const content = document.getElementById("post-content").value;
            const pwd = document.getElementById("post-pwd").value;
            
            if(!title || !content || !pwd) return alert("제목, 내용, 암호를 모두 입력해주세요.");
            if(pwd.length < 4) return alert("암호는 4자리 이상 설정해주세요.");
            
            const today = new Date();
            const dateStr = today.getFullYear() + "." + String(today.getMonth()+1).padStart(2, "0") + "." + String(today.getDate()).padStart(2, "0");
            
            let posts = JSON.parse(localStorage.getItem("batech_board_v4") || "[]");
            posts.unshift({
                id: "b_" + new Date().getTime(),
                title: title,
                content: content,
                author: "익명",
                date: dateStr,
                password: pwd,
                comments: []
            });
            localStorage.setItem("batech_board_v4", JSON.stringify(posts));
            
            document.getElementById("post-title").value = "";
            document.getElementById("post-content").value = "";
            document.getElementById("post-pwd").value = "";
            document.getElementById("write-modal").close();
            
            renderPosts();
            alert("게시글이 성공적으로 등록되었습니다.");
        }

        function openPost(id) {
            let posts = JSON.parse(localStorage.getItem("batech_board_v4") || "[]");
            let p = posts.find(x => x.id === id);
            if(!p) return;
            
            document.getElementById("read-post-id").value = id;
            document.getElementById("read-title").innerText = p.title;
            document.getElementById("read-author").innerText = p.author;
            document.getElementById("read-date").innerText = p.date;
            document.getElementById("read-content").innerText = p.content;
            
            renderComments(p.comments || []);
            document.getElementById("read-modal").showModal();
        }

        let pendingBoardAction = null;
        let activePostId = null;

        function promptBoardPwd(actionType) {
            pendingBoardAction = actionType;
            activePostId = document.getElementById("read-post-id").value;
            
            let desc = actionType === 'edit' ? "게시글을 수정하려면 암호가 필요합니다." : "게시글을 삭제하려면 암호가 필요합니다.";
            document.getElementById("board-pwd-desc").innerText = desc;
            document.getElementById("board-action-pwd").value = "";
            document.getElementById("board-pwd-modal").showModal();
        }

        function submitBoardPwd() {
            let pwd = document.getElementById("board-action-pwd").value;
            let posts = JSON.parse(localStorage.getItem("batech_board_v4") || "[]");
            let p = posts.find(x => x.id === activePostId);
            
            if(!p) return;
            
            if(p.password !== pwd) {
                alert("게시글 암호가 일치하지 않습니다!");
                return;
            }
            
            document.getElementById("board-pwd-modal").close();
            
            if(pendingBoardAction === 'delete') {
                if(confirm("정말 이 게시글을 삭제하시겠습니까?")) {
                    posts = posts.filter(x => x.id !== activePostId);
                    localStorage.setItem("batech_board_v4", JSON.stringify(posts));
                    document.getElementById("read-modal").close();
                    renderPosts();
                    alert("게시글이 삭제되었습니다.");
                }
            } else if(pendingBoardAction === 'edit') {
                document.getElementById("read-modal").close();
                document.getElementById("edit-post-id").value = p.id;
                document.getElementById("edit-title").value = p.title;
                document.getElementById("edit-content").value = p.content;
                document.getElementById("edit-modal").showModal();
            }
        }

        function saveEditPost() {
            const title = document.getElementById("edit-title").value;
            const content = document.getElementById("edit-content").value;
            const id = document.getElementById("edit-post-id").value;
            
            if(!title || !content) return alert("제목과 내용을 모두 입력해주세요.");
            
            let posts = JSON.parse(localStorage.getItem("batech_board_v4") || "[]");
            let idx = posts.findIndex(x => x.id === id);
            if(idx !== -1) {
                posts[idx].title = title;
                posts[idx].content = content;
                localStorage.setItem("batech_board_v4", JSON.stringify(posts));
            }
            
            document.getElementById("edit-modal").close();
            renderPosts();
            openPost(id); // Re-open updated post
            alert("수정이 완료되었습니다.");
        }
'@

$boardSrc = $boardSrc -replace '(?s)function initBoard\(\).*?function addComment\(\)', "$newScripts`r`n`r`n        function addComment()"
$boardSrc = $boardSrc -replace 'batech_board_v3', 'batech_board_v4'

[IO.File]::WriteAllText("portal_board.html", $boardSrc, $utf8)

