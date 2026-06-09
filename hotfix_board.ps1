$utf8 = New-Object System.Text.UTF8Encoding $false

$boardSrc = [IO.File]::ReadAllText("portal_board.html", $utf8)

$missingFunctions = @'
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
'@

$boardSrc = $boardSrc -replace 'function addComment\(\) \{', "$missingFunctions`r`n`r`n        function addComment() {"

[IO.File]::WriteAllText("portal_board.html", $boardSrc, $utf8)

