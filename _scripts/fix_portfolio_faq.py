import re

# 1. Update portfolio.html background
portfolio_path = r"c:\Users\elena\OneDrive\바탕 화면\html-main\html-main\portfolio.html"
with open(portfolio_path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace factory_exterior.jpg with performance_test.jpg for the hero
content = content.replace("url('factory_exterior.jpg')", "url('performance_test.jpg')")

with open(portfolio_path, "w", encoding="utf-8") as f:
    f.write(content)

# 2. Update faq.html with LocalStorage and Delete button
faq_path = r"c:\Users\elena\OneDrive\바탕 화면\html-main\html-main\faq.html"
with open(faq_path, "r", encoding="utf-8") as f:
    faq_content = f.read()

new_js = """
        // LocalStorage keys
        const FAQ_STORAGE_KEY = 'user_faqs';

        // Load saved FAQs on page load
        document.addEventListener('DOMContentLoaded', () => {
            loadSavedFaqs();
        });

        function loadSavedFaqs() {
            const savedFaqs = JSON.parse(localStorage.getItem(FAQ_STORAGE_KEY) || '[]');
            savedFaqs.forEach(faq => {
                renderFaq(faq.id, faq.questionText);
            });
        }

        function submitQuestion() {
            const input = document.getElementById('newQuestion');
            const questionText = input.value.trim();
            
            if (!questionText) {
                alert('질문을 입력해주세요.');
                return;
            }

            const faqId = 'faq_' + new Date().getTime();
            
            // Save to LocalStorage
            const savedFaqs = JSON.parse(localStorage.getItem(FAQ_STORAGE_KEY) || '[]');
            savedFaqs.push({ id: faqId, questionText: questionText });
            localStorage.setItem(FAQ_STORAGE_KEY, JSON.stringify(savedFaqs));
            
            // Render it
            renderFaq(faqId, questionText);

            // Clear input and show alert
            input.value = '';
            alert('질문이 정상적으로 등록되었습니다. 담당자 확인 후 답변이 달릴 예정입니다.');
        }

        function renderFaq(id, questionText) {
            const details = document.createElement('details');
            details.className = 'faq-item user-added';
            details.id = id;
            
            const summary = document.createElement('summary');
            summary.className = 'faq-question';
            summary.innerHTML = `<span class="badge badge-pending">답변 대기중</span>${questionText} <button class="btn-delete-faq" onclick="deleteFaq('${id}')">취소</button>`;
            
            const answer = document.createElement('div');
            answer.className = 'faq-answer';
            answer.innerHTML = `<em>등록된 질문을 담당자가 확인 중입니다. 빠른 시일 내에 답변을 달아드리겠습니다.</em>`;
            
            details.appendChild(summary);
            details.appendChild(answer);

            const faqList = document.getElementById('faqList');
            faqList.insertBefore(details, faqList.firstChild);
        }

        function deleteFaq(id) {
            if (!confirm('등록하신 질문을 취소하시겠습니까?')) return;
            
            // Remove from DOM
            const element = document.getElementById(id);
            if (element) {
                element.remove();
            }
            
            // Remove from LocalStorage
            let savedFaqs = JSON.parse(localStorage.getItem(FAQ_STORAGE_KEY) || '[]');
            savedFaqs = savedFaqs.filter(faq => faq.id !== id);
            localStorage.setItem(FAQ_STORAGE_KEY, JSON.stringify(savedFaqs));
        }
"""

faq_content = re.sub(r'(?s)        function submitQuestion\(\) \{.*\}', new_js.strip(), faq_content)

# We also need to add some styling for the delete button if not exists
if '.btn-delete-faq' not in faq_content:
    css_addition = """
        .btn-delete-faq {
            float: right;
            background: #ef4444;
            color: white;
            border: none;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.8rem;
            cursor: pointer;
            margin-top: 2px;
        }
        .btn-delete-faq:hover {
            background: #dc2626;
        }
"""
    faq_content = faq_content.replace('</style>', css_addition + '</style>')


with open(faq_path, "w", encoding="utf-8") as f:
    f.write(faq_content)

print("Updated portfolio.html and faq.html")
