$utf8 = New-Object System.Text.UTF8Encoding $false

# --- portal_board.html ---
$boardSrc = [IO.File]::ReadAllText("portal_board.html", $utf8)

$newScript = @'
    <script>
        function initBoard() {
            if(!localStorage.getItem("batech_board_init_v3")) {
                let defaultPosts = [
                    { id: "b2", title: "휴게실 안마의자 진짜 너무 좋습니다 ㅠㅠ", content: "최근에 들어온 안마의자 써보신 분 계신가요?\n점심시간에 15분 누워있었는데 피로가 싹 풀리네요.\n총무부 감사합니다!!", author: "익명", date: "2026.06.08", comments: [{id: "c1", author: "익명", text: "저도 내일 점심에 써봐야겠네요 ㅎㅎ", replies: []}, {id: "c2", author: "익명", text: "경쟁이 치열합니다 일찍 가셔야 해요", replies: [{author: "익명", text: "맞아요 점심시간 땡치면 바로 뛰어가야함 ㅋㅋ"}]}] },
                    { id: "b1", title: "이번 주 금요일 회식 장소 투표 좀 해주세요", content: "이번 주 팀 회식인데 메뉴를 못 정하고 있습니다.\n1. 삼겹살\n2. 회\n3. 곱창\n\n댓글로 의견 좀 남겨주세요!", author: "익명", date: "2026.06.07", comments: [{id: "c3", author: "익명", text: "무조건 1번 삼겹살이죠", replies: []}, {id: "c4", author: "익명", text: "저는 2번 회 추천합니다!", replies: []}] }
                ];
                
                // Migrate v2 user posts if any
                let oldPosts = JSON.parse(localStorage.getItem("batech_board_v2") || "[]");
                let v3Posts = [];
                if(oldPosts.length > 0) {
                    oldPosts.forEach(p => {
                        if(p.comments) {
                            p.comments.forEach((c, idx) => {
                                if(!c.id) c.id = "c_" + Date.now() + "_" + idx;
                                if(!c.replies) c.replies = [];
                            });
                        }
                        v3Posts.push(p);
                    });
                } else {
                    v3Posts = defaultPosts;
                }
                
                localStorage.setItem("batech_board_v3", JSON.stringify(v3Posts));
                localStorage.setItem("batech_board_init_v3", "true");
            }
        }

        function renderPosts() {
            const container = document.getElementById("posts-container");
            container.innerHTML = "";
            let posts = JSON.parse(localStorage.getItem("batech_board_v3") || "[]");
            
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
            
            if(!title || !content) return alert("제목과 내용을 모두 입력해주세요.");
            
            const today = new Date();
            const dateStr = today.getFullYear() + "." + String(today.getMonth()+1).padStart(2, "0") + "." + String(today.getDate()).padStart(2, "0");
            
            let posts = JSON.parse(localStorage.getItem("batech_board_v3") || "[]");
            posts.unshift({
                id: "b_" + new Date().getTime(),
                title: title,
                content: content,
                author: "익명",
                date: dateStr,
                comments: []
            });
            localStorage.setItem("batech_board_v3", JSON.stringify(posts));
            
            document.getElementById("post-title").value = "";
            document.getElementById("post-content").value = "";
            document.getElementById("write-modal").close();
            
            renderPosts();
            alert("게시글이 성공적으로 등록되었습니다.");
        }

        function openPost(id) {
            let posts = JSON.parse(localStorage.getItem("batech_board_v3") || "[]");
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

        function toggleReplyInput(commentId) {
            const box = document.getElementById(`reply-box-${commentId}`);
            if(box.style.display === "none") {
                box.style.display = "flex";
                document.getElementById(`reply-input-${commentId}`).focus();
            } else {
                box.style.display = "none";
            }
        }

        function renderComments(comments) {
            let totalCount = comments.length;
            comments.forEach(c => { totalCount += (c.replies ? c.replies.length : 0); });
            document.getElementById("comment-count").innerText = totalCount;
            
            const list = document.getElementById("comments-list");
            list.innerHTML = "";
            if(comments.length === 0) {
                list.innerHTML = `<div style="color: #94a3b8; font-size: 0.9rem; padding: 10px 0;">첫 댓글을 남겨보세요!</div>`;
                return;
            }
            
            comments.forEach(c => {
                if(!c.id) c.id = "c_" + Math.random().toString(36).substr(2, 9);
                if(!c.replies) c.replies = [];
                
                let repliesHtml = "";
                if(c.replies.length > 0) {
                    c.replies.forEach(r => {
                        repliesHtml += `
                            <div class="comment-item" style="margin-left: 20px; border-left: 3px solid #cbd5e1; background: #f1f5f9; margin-top: 8px;">
                                <div class="c-author">↳ ${r.author}</div>
                                <div class="c-text">${r.text}</div>
                            </div>
                        `;
                    });
                }
                
                list.innerHTML += `
                    <div class="comment-item" style="position: relative;">
                        <div class="c-author">${c.author}</div>
                        <div class="c-text">${c.text}</div>
                        <button style="background:none; border:none; color:#3b82f6; font-size:0.8rem; cursor:pointer; position:absolute; top:10px; right:10px; font-weight:600;" onclick="toggleReplyInput('${c.id}')">답글 달기</button>
                        
                        <div id="reply-box-${c.id}" style="display:none; margin-top: 10px; gap: 8px;">
                            <input type="text" id="reply-input-${c.id}" class="input-box" style="padding: 6px; font-size: 0.85rem;" placeholder="대댓글을 남겨보세요..." onkeypress="if(event.key === 'Enter') addReply('${c.id}')">
                            <button class="btn-sm primary" onclick="addReply('${c.id}')" style="white-space:nowrap;">등록</button>
                        </div>
                        
                        ${repliesHtml}
                    </div>
                `;
            });
        }

        function addComment() {
            const input = document.getElementById("new-comment");
            const text = input.value.trim();
            if(!text) return;
            
            const id = document.getElementById("read-post-id").value;
            let posts = JSON.parse(localStorage.getItem("batech_board_v3") || "[]");
            let pIndex = posts.findIndex(x => x.id === id);
            
            if(pIndex !== -1) {
                if(!posts[pIndex].comments) posts[pIndex].comments = [];
                posts[pIndex].comments.push({ id: "c_" + Date.now(), author: "익명", text: text, replies: [] });
                localStorage.setItem("batech_board_v3", JSON.stringify(posts));
                
                input.value = "";
                renderComments(posts[pIndex].comments);
                renderPosts();
            }
        }

        function addReply(commentId) {
            const input = document.getElementById(`reply-input-${commentId}`);
            const text = input.value.trim();
            if(!text) return;
            
            const postId = document.getElementById("read-post-id").value;
            let posts = JSON.parse(localStorage.getItem("batech_board_v3") || "[]");
            let pIndex = posts.findIndex(x => x.id === postId);
            
            if(pIndex !== -1) {
                let cIndex = posts[pIndex].comments.findIndex(c => c.id === commentId);
                if(cIndex !== -1) {
                    if(!posts[pIndex].comments[cIndex].replies) posts[pIndex].comments[cIndex].replies = [];
                    posts[pIndex].comments[cIndex].replies.push({ author: "익명", text: text });
                    localStorage.setItem("batech_board_v3", JSON.stringify(posts));
                    
                    renderComments(posts[pIndex].comments);
                    renderPosts();
                }
            }
        }

        document.addEventListener("DOMContentLoaded", () => {
            initBoard();
            renderPosts();
        });
    </script>
'@

$boardSrc = $boardSrc -replace '(?s)<script>.*?(?=<footer>)', "$newScript`r`n"
[IO.File]::WriteAllText("portal_board.html", $boardSrc, $utf8)

