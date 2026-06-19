import re
import os

filepath = r"C:\Users\elena\OneDrive\바탕 화면\html-main\html-main\chatbot_widget.js"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# I need to completely replace getAIResponse and add the typing effect.
# First, let's inject the new NLP getAIResponse

new_getAIResponse = """
    // 9. NLP 기반 가중치 의도 파악 시스템 (Advanced Intent Classification)
    function getAIResponse(query) {
        const queryLower = query.toLowerCase().replace(/\s+/g, '');
        
        // 의도(Intent)별 스코어 계산 함수
        function getScore(keywords) {
            let score = 0;
            keywords.forEach(kw => {
                if (queryLower.includes(kw)) score += 10;
            });
            return score;
        }

        // 인텐트 사전 정의 (확장된 동의어)
        const intents = {
            exit: getScore(['종료', '나가기', '대화종료', 'exit', '질문없', '아니오', '없습', '끝', '아니', '창닫기', '종료해줘', '됐어', '그만']),
            ceo: getScore(['조세형', '대표이사', '대표이름', '대표자', '사장성명', '사장이름', '대표명', '대표성명', '사장님', '누구야', '설립자']),
            location: getScore(['오시는길', '위치', '주소', '어디', '가려', '찾아', '춘천', '가는', '가려면', '지도', '약도', '본사', '공장', '어디에', '어떻게가', '길안내']),
            company: getScore(['회사', '기업', '비에이텍', '소개', '인사말', '설립', '창립', '연혁', '역사', '언제생겼', '비전', '경영', '가치', '무슨일', '뭐하는곳']),
            products: getScore(['제품', '펌프', '라인업', '종류', '기능', '생산', '판매', '카탈로그', '부스터', '수중', '슬러지', '모노', '볼류트', '정량', '추천', '어떤펌프', '설명', '사양']),
            diagnostics: getScore(['누수', '소음', '진동', '고장', '이상', '점검', '자가진단', '물샘', '시끄러', '굉음', '냄새', '타는', '멈춤', '고착', '오일', '누유', '진단', '수리', '안돌아', '망가', '고치']),
            rnd: getScore(['연구', '개발', 'rnd', 'cfd', '시뮬레이션', '유동', '유체', '인버터', '해석', '전산', '연구소', '특성', '학술', '기술력']),
            certifications: getScore(['인증', '특허', '면허', 'iso', '증명서', '확인서', '보유', '신뢰', '등록', '허가', '성적서', '증명']),
            facilities: getScore(['설비', '시설', '공장', '기계', '가공', '용접', '크레인', '설계실', '테스트베드', '장비', '어떻게만들', '제조시설']),
            contact: getScore(['연락처', '전화번호', '내선', '연락망', '전화', '유선', '번호', '고객센터', '문의', '연락', '물어볼', '전화번호가']),
            regulations: getScore(['취업규칙', '징계', '포상', '사내규정', '내부규칙', '인사규정', '상벌', '복리후생', '휴가']),
            greeting: getScore(['안녕', '반가워', '수고', '고마워', '감사', '누구야', '안뇽', '하이', '반갑습니다', '반갑', 'hello', 'hi'])
        };

        // 상태 기계 동작 (자가진단 등)
        // ... (기존 로직 유지 또는 통합)
        
        // 상태 기계가 동작 중이면 스코어보다 상태 우선 처리
        if (chatState === 'diag_pump_select') {
            if (queryLower.includes('1') || queryLower.includes('부스터')) {
                selectedPump = 'booster';
                chatState = 'diag_symptom_select';
                return {
                    text: `선택하신 펌프는 <strong>1. 부스터 펌프 시스템</strong>입니다.<br><br>겪고 계신 이상 증상을 선택해 주세요.
<div class="quick-chips-container" style="margin-top: 12px;">
    <button class="quick-chip" onclick="sendQuickKeyword('씰 누수 (분당 5방울 이상)')">💧 씰 누수 (분당 5방울 이상)</button>
    <button class="quick-chip" onclick="sendQuickKeyword('공동현상 (물 끓는 고음)')">🔊 공동현상 (물 끓는 고음)</button>
    <button class="quick-chip" onclick="sendQuickKeyword('모터 베어링 고주파음')">⚙️ 모터 베어링 고주파음</button>
</div>`, type: 'ai'
                };
            }
            if (queryLower.includes('2') || queryLower.includes('수중')) {
                selectedPump = 'submersible';
                chatState = 'diag_symptom_select';
                return {
                    text: `선택하신 펌프는 <strong>2. 수중 오폐수 펌프</strong>입니다.<br><br>겪고 계신 이상 증상을 선택해 주세요.
<div class="quick-chips-container" style="margin-top: 12px;">
    <button class="quick-chip" onclick="sendQuickKeyword('오일 유화 (우윳빛 변화)')">💧 오일 유화 (우윳빛 변화)</button>
    <button class="quick-chip" onclick="sendQuickKeyword('기동 지연 및 배관 고주파음')">⚙️ 기동 지연 및 배관 고주파음</button>
</div>`, type: 'ai'
                };
            }
            if (queryLower.includes('3') || queryLower.includes('슬러지')) {
                selectedPump = 'sludge';
                chatState = 'diag_symptom_select';
                return { text: `선택하신 펌프는 <strong>3. 슬러지 펌프</strong>입니다.<br><br>겪고 계신 이상 증상을 선택해 주세요.
<div class="quick-chips-container" style="margin-top: 12px;">
    <button class="quick-chip" onclick="sendQuickKeyword('오일 누유 (게이지 감소)')">💧 오일 누유 (게이지 감소)</button>
    <button class="quick-chip" onclick="sendQuickKeyword('베어링 고열 및 금속음')">⚙️ 베어링 고열 및 금속음</button>
</div>`, type: 'ai' };
            }
            if (queryLower.includes('4') || queryLower.includes('모노') || queryLower.includes('나사')) {
                selectedPump = 'mono';
                chatState = 'diag_symptom_select';
                return { text: `선택하신 펌프는 <strong>4. 일축나사식 모노 펌프</strong>입니다.<br><br>겪고 계신 이상 증상을 선택해 주세요.
<div class="quick-chips-container" style="margin-top: 12px;">
    <button class="quick-chip" onclick="sendQuickKeyword('공운전 고열 (타는 냄새/진동)')">⚙️ 공운전 고열 (타는 냄새/진동)</button>
    <button class="quick-chip" onclick="sendQuickKeyword('로터 고착 및 과부하 굉음')">🔊 로터 고착 및 과부하 굉음</button>
</div>`, type: 'ai' };
            }
            if (queryLower.includes('5') || queryLower.includes('볼류트') || queryLower.includes('편흡입')) {
                selectedPump = 'volute';
                chatState = 'diag_symptom_select';
                return { text: `선택하신 펌프는 <strong>5. 편흡입 볼류트 펌프</strong>입니다.<br><br>겪고 계신 이상 증상을 선택해 주세요.
<div class="quick-chips-container" style="margin-top: 12px;">
    <button class="quick-chip" onclick="sendQuickKeyword('그랜드 패킹 과다 누설')">💧 그랜드 패킹 과다 누설</button>
    <button class="quick-chip" onclick="sendQuickKeyword('흡입측 비정상 고진동음')">🔊 흡입측 비정상 고진동음</button>
</div>`, type: 'ai' };
            }
            if (queryLower.includes('6') || queryLower.includes('정량') || queryLower.includes('주입')) {
                selectedPump = 'dosing';
                chatState = 'diag_symptom_select';
                return { text: `선택하신 펌프는 <strong>6. 약품 주입 정량 펌프</strong>입니다.<br><br>겪고 계신 이상 증상을 선택해 주세요.
<div class="quick-chips-container" style="margin-top: 12px;">
    <button class="quick-chip" onclick="sendQuickKeyword('스트로크 조절 다이얼 마찰음')">⚙️ 스트로크 조절 다이얼 마찰음</button>
    <button class="quick-chip" onclick="sendQuickKeyword('주입 압력 저하 및 밸브 오물')">💧 주입 압력 저하 및 밸브 오물</button>
</div>`, type: 'ai' };
            }
            chatState = 'default';
        }

        if (chatState === 'diag_symptom_select') {
            chatState = 'default';
            if (selectedPump === 'booster') {
                selectedPump = '';
                if (queryLower.includes('씰') || queryLower.includes('누수')) return { text: `<strong>[부스터 펌프 씰 누수]</strong><br>- <strong>원인:</strong> 씰 슬리브 마모 또는 O-링 경화.<br>- <strong>해결:</strong> 즉시 제어반 전원을 차단하고 밸브를 폐쇄하세요. 분당 5방울 이상 누수 시 정품 씰 키트로 교체해야 합니다.<br>\${getFollowUpPrompt()}`, type: 'ai' };
                if (queryLower.includes('공동') || queryLower.includes('끓는') || queryLower.includes('고음')) return { text: `<strong>[부스터 펌프 공동현상]</strong><br>- <strong>원인:</strong> 흡입 압력 급감으로 배관 내 기포가 터지는 현상.<br>- <strong>해결:</strong> 흡입측 밸브 완전 개방 확인 및 수위를 복구하세요.<br>\${getFollowUpPrompt()}`, type: 'ai' };
                if (queryLower.includes('모터') || queryLower.includes('베어링') || queryLower.includes('고주파')) return { text: `<strong>[부스터 펌프 모터 소음]</strong><br>- <strong>원인:</strong> 베어링 그리스 고갈.<br>- <strong>해결:</strong> 즉시 운전을 정지하고 베어링 그리스를 주입하거나 정품 파츠로 교체하십시오.<br>\${getFollowUpPrompt()}`, type: 'ai' };
            }
            if (selectedPump === 'submersible') {
                selectedPump = '';
                if (queryLower.includes('유화') || queryLower.includes('우윳빛')) return { text: `<strong>[수중 펌프 오일 유화]</strong><br>- <strong>원인:</strong> 씰 손상에 따른 오일실 수분 유입.<br>- <strong>해결:</strong> 오일이 우윳빛이면 씰이 파손된 것입니다. 즉시 10MΩ 이상 메거 테스트 후 교체하세요.<br>\${getFollowUpPrompt()}`, type: 'ai' };
                if (queryLower.includes('지연') || queryLower.includes('고주파') || queryLower.includes('기동')) return { text: `<strong>[수중 펌프 과부하]</strong><br>- <strong>원인:</strong> 스트레이너 막힘.<br>- <strong>해결:</strong> 즉시 펌프를 인양하여 하단 메쉬망을 고압 세척하세요.<br>\${getFollowUpPrompt()}`, type: 'ai' };
            }
            if (selectedPump === 'sludge') {
                selectedPump = '';
                if (queryLower.includes('누유') || queryLower.includes('감소')) return { text: `<strong>[슬러지 펌프 오일 누유]</strong><br>- <strong>해결:</strong> 오일 씰이 찢어졌거나 편마모가 생겼을 수 있으니 부속을 신품으로 교체하세요.<br>\${getFollowUpPrompt()}`, type: 'ai' };
                if (queryLower.includes('금속') || queryLower.includes('고열')) return { text: `<strong>[슬러지 펌프 베어링 고열]</strong><br>- <strong>해결:</strong> 온도가 80℃ 이상 급상승 시 비상 정지하고 오일을 전면 교환하세요.<br>\${getFollowUpPrompt()}`, type: 'ai' };
            }
            if (selectedPump === 'mono') {
                selectedPump = '';
                if (queryLower.includes('타는') || queryLower.includes('냄새') || queryLower.includes('공운전')) return { text: `<strong>[모노 펌프 공운전]</strong><br>- <strong>해결:</strong> 액체 미유입 상태로 30초 이상 운전하면 고무 고정자가 녹습니다. 즉시 정지하고 액체를 채운 뒤 기동하세요.<br>\${getFollowUpPrompt()}`, type: 'ai' };
                if (queryLower.includes('고착') || queryLower.includes('굉음')) return { text: `<strong>[모노 펌프 고착]</strong><br>- <strong>해결:</strong> 축을 역회전시켜 고착을 점검하고, 이물질이 걸린 경우 분해 세척하세요.<br>\${getFollowUpPrompt()}`, type: 'ai' };
            }
            if (selectedPump === 'volute') {
                selectedPump = '';
                if (queryLower.includes('패킹') || queryLower.includes('누설')) return { text: `<strong>[볼류트 펌프 패킹 누설]</strong><br>- <strong>해결:</strong> 분당 20방울 이상 누설 시 너트를 평평하게 1/4바퀴씩 조절해가며 조여주세요.<br>\${getFollowUpPrompt()}`, type: 'ai' };
                if (queryLower.includes('진동') || queryLower.includes('흡입')) return { text: `<strong>[볼류트 펌프 소음]</strong><br>- <strong>해결:</strong> 임펠러 사이에 낀 오물을 세척하거나 입구 밸브 에어 유입을 차단하세요.<br>\${getFollowUpPrompt()}`, type: 'ai' };
            }
            if (selectedPump === 'dosing') {
                selectedPump = '';
                if (queryLower.includes('기어') || queryLower.includes('다이얼')) return { text: `<strong>[정량 펌프 다이얼 파손]</strong><br>- <strong>해결:</strong> 다이얼은 반드시 펌프 모터가 가동 중인 상태에서만 회전시켜야 합니다!<br>\${getFollowUpPrompt()}`, type: 'ai' };
                if (queryLower.includes('압력') || queryLower.includes('밸브')) return { text: `<strong>[정량 펌프 주입 불량]</strong><br>- <strong>해결:</strong> 체크 밸브 하우징을 풀고 볼과 시트를 솔벤트로 세척하십시오.<br>\${getFollowUpPrompt()}`, type: 'ai' };
            }
            selectedPump = '';
        }

        if (chatState === 'prod_function_select') {
            chatState = 'default';
            if (queryLower.includes('급수') || queryLower.includes('부스터') || queryLower.includes('1')) return { text: `<strong>🏢 [부스터 펌프 시스템]</strong><br>아파트/빌딩 급수용으로 최적화된 인버터 정압 패키지입니다.<br>\${getFollowUpPrompt()}`, type: 'ai' };
            if (queryLower.includes('수중') || queryLower.includes('오폐수') || queryLower.includes('2')) return { text: `<strong>☔ [수중 오폐수 처리 펌프]</strong><br>오수관 및 지하 배수탑에서 완벽한 방수를 자랑합니다.<br>\${getFollowUpPrompt()}`, type: 'ai' };
            if (queryLower.includes('슬러지') || queryLower.includes('3')) return { text: `<strong>💩 [슬러지 펌프]</strong><br>고농도 침전 슬러지를 막힘없이 강제 이송합니다.<br>\${getFollowUpPrompt()}`, type: 'ai' };
            if (queryLower.includes('모노') || queryLower.includes('4')) return { text: `<strong>🍯 [모노 펌프]</strong><br>초고점도 물질이나 페이스트를 기밀 이송하는 특수 펌프입니다.<br>\${getFollowUpPrompt()}`, type: 'ai' };
            if (queryLower.includes('볼류트') || queryLower.includes('5')) return { text: `<strong>🌀 [볼류트 펌프]</strong><br>다목적 산업 공정용으로 압도적인 연속 순환 안정성을 보장합니다.<br>\${getFollowUpPrompt()}`, type: 'ai' };
            if (queryLower.includes('정량') || queryLower.includes('약품') || queryLower.includes('6')) return { text: `<strong>🔬 [정량 펌프]</strong><br>초정밀 화학 약품 투입을 오차율 ±1% 이내로 제어합니다.<br>\${getFollowUpPrompt()}`, type: 'ai' };
        }

        // --- 스코어링 결과 판별 ---
        let maxIntent = '';
        let maxScore = 0;
        for (const [intent, score] of Object.entries(intents)) {
            if (score > maxScore) {
                maxScore = score;
                maxIntent = intent;
            }
        }

        // 조건이 너무 모호하거나 낮은 스코어일 때 Fallback
        if (maxScore < 10) {
            return {
                text: `죄송합니다, 말씀하신 내용을 정확히 이해하지 못했습니다. 혹시 다음과 같은 정보를 찾으시나요?<br><br>
<div class="quick-chips-container">
    <button class="quick-chip" onclick="sendQuickKeyword('주요 제품')">📦 제품 카탈로그</button>
    <button class="quick-chip" onclick="sendQuickKeyword('고장 증상 진단')">💧 펌프 고장 진단</button>
    <button class="quick-chip" onclick="sendQuickKeyword('연락처')">📞 전화 문의</button>
</div>`,
                type: 'ai'
            };
        }

        // 강력한 의도 분기
        switch (maxIntent) {
            case 'exit':
                return { text: "상담이 종료되었습니다. 이용해 주셔서 감사합니다! 행복한 하루 되십시오.", type: 'ai', isExit: true };
            case 'greeting':
                return { text: "안녕하세요! 비에이텍 AI 고객비서입니다. 제품 정보, 자가진단, 회사 소개 등 무엇이든 물어보세요!", type: 'ai' };
            case 'ceo':
                return { text: "비에이텍의 대표이사는 **조세형** 대표님입니다. 언제나 최고의 물 기술력으로 보답하겠습니다.<br>\${getFollowUpPrompt()}", type: 'ai' };
            case 'location':
                return { text: "저희 비에이텍 본사 및 공장은 **강원특별자치도 춘천시 퇴계공단2길 64**에 위치해 있습니다. 내비게이션에 '비에이텍'을 검색하시면 편하게 찾아오실 수 있습니다.<br>\${getFollowUpPrompt()}", type: 'ai', source: 'map.html' };
            case 'company':
                return { text: "(주)비에이텍은 깨끗하고 안전한 물 환경을 조성하는 워터펌프 시스템 전문 기업입니다. 우수한 기술력을 바탕으로 상하수도 설비, 공업용수, 부스터 펌프 시스템 등을 제조하고 있습니다.<br>\${getFollowUpPrompt()}", type: 'ai' };
            case 'products':
                chatState = 'prod_function_select';
                return { text: "어떤 용도의 펌프를 찾으시나요? 아래에서 원하시는 분야를 선택해 주시거나 번호를 입력해 주세요.<br><br>1. 건물/급수용 부스터펌프<br>2. 수중 오폐수 배수펌프<br>3. 고농도 슬러지 펌프<br>4. 초고점도 모노 펌프<br>5. 다목적 순환 볼류트 펌프<br>6. 초정밀 약품 정량 펌프", type: 'ai' };
            case 'diagnostics':
                chatState = 'diag_pump_select';
                return { text: "어떤 펌프에서 문제가 발생했나요? 아래 번호를 입력해 주시면 고장 증상 및 조치 방법을 진단해 드립니다.<br><br>1. 부스터 펌프<br>2. 수중 펌프<br>3. 슬러지 펌프<br>4. 모노 펌프<br>5. 볼류트 펌프<br>6. 정량 펌프", type: 'ai' };
            case 'contact':
                return { text: "고객지원 대표전화는 **033-264-9240** 입니다. 유선으로 문의하시면 전문가가 신속하게 안내해 드립니다.<br>\${getFollowUpPrompt()}", type: 'ai' };
            case 'rnd':
                return { text: "비에이텍 연구소는 3D CFD(유동해석) 기술을 활용하여 최적의 펌프 임펠러 및 케이싱을 독자 설계합니다. 에너지 효율을 극대화하는 인버터 기술도 보유하고 있습니다.<br>\${getFollowUpPrompt()}", type: 'ai' };
            case 'certifications':
                return { text: "저희는 ISO 9001 품질경영인증을 비롯하여, 고효율 에너지 기자재 인증, KC 안전인증 등 펌프 및 상하수도 설비 관련 다수의 특허와 증명서를 보유하고 있습니다.<br>\${getFollowUpPrompt()}", type: 'ai' };
            case 'facilities':
                return { text: "최신식 CNC 머시닝센터, 플라즈마 절단기, 전용 대형 호이스트 크레인 등 펌프의 생산부터 가공, 테스트베드 조립까지 완벽한 자체 공장 라인을 갖추고 있습니다.<br>\${getFollowUpPrompt()}", type: 'ai' };
            case 'regulations':
                return { text: "사내 규정 및 서식 관련 문의는 사내 포털의 '서식 및 자료실' 페이지를 이용해 주시기 바랍니다. NotebookLM 가이드 등도 업로드되어 있습니다.<br>\${getFollowUpPrompt()}", type: 'ai' };
            default:
                return { text: repContactTemplate, type: 'ai' };
        }
    }
"""

# Extract the region to replace
pattern = re.compile(r"// 9\. 웹페이지 지식망 & 대표전화 매핑 라우터.*?function getAIResponse.*?return \{ text: repContactTemplate, type: 'ai' \};\s*\}\s*\}", re.DOTALL)

if pattern.search(content):
    new_content = pattern.sub(new_getAIResponse.strip(), content)
    
    # Also I need to modify the appendMessage to simulate typing effect!
    append_pattern = re.compile(r"function appendMessage\(text, type, source = null\) \{.*?\n\s+chatBody\.appendChild\(bubble\);\s*\}", re.DOTALL)
    
    new_appendMessage = """
    function appendMessage(text, type, source = null) {
        const bubble = document.createElement('div');
        bubble.className = `message-bubble ${type}`;
        
        let headerHtml = '';
        if (source) {
            headerHtml += `<span class="message-source">${source}</span><br>`;
        }
        
        chatBody.appendChild(bubble);
        
        // Typing Effect logic for AI
        if (type === 'ai' && !text.includes('<div class="quick-chips-container"')) {
            bubble.innerHTML = headerHtml;
            // Temporarily hide HTML tags during typing
            let i = 0;
            let isTag = false;
            let currentHTML = headerHtml;
            
            function typeWriter() {
                if (i < text.length) {
                    let char = text.charAt(i);
                    currentHTML += char;
                    bubble.innerHTML = currentHTML;
                    if (char === '<') isTag = true;
                    if (char === '>') isTag = false;
                    
                    i++;
                    let delay = isTag ? 0 : 15;
                    setTimeout(typeWriter, delay);
                    scrollToBottom();
                }
            }
            typeWriter();
        } else {
            bubble.innerHTML = headerHtml + text;
            scrollToBottom();
        }
    }
"""
    new_content = append_pattern.sub(new_appendMessage.strip(), new_content)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("Successfully upgraded chatbot_widget.js with NLP logic and Typing Effect.")
else:
    print("Could not find the getAIResponse function to replace. Regex failed.")

