/* 비에이텍 사내 AI 지식 비서 챗봇 위젯 스크립트 (FAQ 축소 버전) */
(function() {
    function initWidget() {
        // 1. DOM에 챗봇 HTML 구조가 없는 경우 동적 주입 (자체 인라인 SVG 탑재)
        if (!document.getElementById('chatbot-widget-container')) {
            const widgetContainer = document.createElement('div');
            widgetContainer.id = 'chatbot-widget-container';
            widgetContainer.innerHTML = `
                <!-- 챗봇 플로팅 버튼 -->
                <button class="chatbot-trigger" id="chatbotTrigger" title="자주 묻는 질문(FAQ) 열기">
                    <svg class="chat-icon" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path>
                        <line x1="12" y1="17" x2="12.01" y2="17"></line>
                    </svg>
                    <svg class="close-icon" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="display: none;">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </button>

                <!-- 챗봇 글래스모피즘 윈도우 -->
                <div class="chatbot-window" id="chatbotWindow">
                    <!-- 헤더 -->
                    <div class="chat-header">
                        <div class="chat-header-info">
                            <div class="chat-avatar">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="16" x2="12" y2="12"></line>
                                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                </svg>
                            </div>
                            <div class="chat-title-group">
                                <h4>빠른 도움말</h4>
                                <p><span class="chat-status-dot"></span> 비에이텍 고객지원 센터</p>
                            </div>
                        </div>
                        <button class="chat-close-btn" id="closeChatBtn" title="창 닫기">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>

                    <!-- 대화 스크롤 구역 (FAQ 컨텐츠) -->
                    <div class="chat-body" id="chatBody" style="background: #f8fafc; padding: 20px;">
                        <div id="faq-list-container">
                            <div style="font-size: 0.9rem; color: #334155; margin-bottom: 15px; line-height: 1.5;">
                                안녕하세요! 궁금하신 내용을 아래 목록에서 선택해 주세요.
                            </div>
                            <div style="display: flex; flex-direction: column; gap: 10px;">
                                <button class="quick-chip faq-btn" style="text-align: left; padding: 10px 15px;" data-target="faq-company">🏢 회사 위치가 어떻게 되나요?</button>
                                <button class="quick-chip faq-btn" style="text-align: left; padding: 10px 15px;" data-target="faq-product">📦 주요 제품 카탈로그를 보고 싶어요</button>
                                <button class="quick-chip faq-btn" style="text-align: left; padding: 10px 15px;" data-target="faq-manual">📖 펌프 유지관리 지침서는 어디 있나요?</button>
                                <button class="quick-chip faq-btn" style="text-align: left; padding: 10px 15px;" data-target="faq-diag">💧 펌프 고장 자가진단은 어떻게 하나요?</button>
                                <button class="quick-chip faq-btn" style="text-align: left; padding: 10px 15px;" data-target="faq-contact">📞 고객지원센터 전화번호가 뭔가요?</button>
                            </div>
                        </div>

                        <div id="faq-answer-container" style="display: none;">
                            <div style="background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 16px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02);">
                                <h5 id="faq-question-title" style="color: #0284c7; margin: 0 0 10px 0; font-size: 0.9rem; border-bottom: 1px dashed #e2e8f0; padding-bottom: 10px;"></h5>
                                <div id="faq-answer-content" style="font-size: 0.88rem; color: #334155; line-height: 1.6;"></div>
                            </div>
                            <button id="faq-back-btn" class="quick-chip" style="margin-top: 15px; width: 100%; justify-content: center; display: flex;">⬅ 목록으로 돌아가기</button>
                        </div>
                    </div>
                </div>
            `;
            document.body.appendChild(widgetContainer);
        }

        // 2. 주요 요소 선택
        const trigger = document.getElementById('chatbotTrigger');
        const windowEl = document.getElementById('chatbotWindow');
        const closeBtn = document.getElementById('closeChatBtn');
        
        const faqListContainer = document.getElementById('faq-list-container');
        const faqAnswerContainer = document.getElementById('faq-answer-container');
        const faqQuestionTitle = document.getElementById('faq-question-title');
        const faqAnswerContent = document.getElementById('faq-answer-content');
        const faqBackBtn = document.getElementById('faq-back-btn');

        // FAQ 답변 데이터
        const answers = {
            'faq-company': '비에이텍 본사 및 제1공장은 <strong>강원특별자치도 춘천시 퇴계공단2길 64</strong>에 위치해 있습니다.<br><br><button class="quick-chip" onclick="window.location.href=\'map.html\'" style="margin-top: 10px;">📍 오시는 길 페이지 가기</button>',
            'faq-product': '저희 비에이텍은 부스터 펌프, 수중 오폐수 펌프, 슬러지 펌프, 모노 펌프, 편흡입 볼류트 펌프, 정량 펌프 등 6대 핵심 펌프를 제조 및 공급합니다.<br><br><button class="quick-chip" onclick="window.location.href=\'product.html\'" style="margin-top: 10px;">📦 제품 안내 페이지 가기</button>',
            'faq-manual': '펌프별 유지관리 지침서 및 상세 매뉴얼은 홈페이지 내 <strong>[유지관리 지침서]</strong> 메뉴에서 확인 및 다운로드하실 수 있습니다.<br><br><button class="quick-chip" onclick="window.location.href=\'management.html\'" style="margin-top: 10px;">📖 유지관리 지침서 가기</button>',
            'faq-diag': '홈페이지의 <strong>[고객지원] -> [자주묻는질문(FAQ)]</strong> 게시판을 확인하시거나, 아래 고객센터(<strong>033-264-9240</strong>)로 전화 주시면 상세히 진단해 드립니다.<br><br><button class="quick-chip" onclick="window.location.href=\'faq.html\'" style="margin-top: 10px;">💧 자주묻는질문 가기</button>',
            'faq-contact': '고객지원 대표전화는 <strong>033-264-9240</strong> 입니다.<br><br>⏰ <strong>업무시간:</strong> 평일 09:00 ~ 18:00 (점심시간 12:00~13:00)<br>*주말 및 공휴일 휴무<br><br>업무시간 내에 문의해 주시면 전문가가 친절하게 상담해 드립니다.'
        };

        // 4. 토글 이벤트
        trigger.addEventListener('click', toggleChatbot);
        closeBtn.addEventListener('click', closeChatbot);

        function toggleChatbot() {
            windowEl.classList.toggle('active');
            trigger.classList.toggle('active');
        }

        function closeChatbot() {
            windowEl.classList.remove('active');
            trigger.classList.remove('active');
            setTimeout(() => resetFAQ(), 300);
        }

        // FAQ 버튼 클릭 이벤트
        document.querySelectorAll('.faq-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const target = btn.getAttribute('data-target');
                const questionText = btn.innerText;
                
                faqListContainer.style.display = 'none';
                faqAnswerContainer.style.display = 'block';
                faqQuestionTitle.innerText = "Q. " + questionText.replace(/^[^\s]+\s/, ''); // 이모지 제거
                faqAnswerContent.innerHTML = answers[target];
            });
        });

        // 뒤로가기 버튼
        faqBackBtn.addEventListener('click', resetFAQ);

        function resetFAQ() {
            faqListContainer.style.display = 'block';
            faqAnswerContainer.style.display = 'none';
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initWidget);
    } else {
        initWidget();
    }
})();
