import os
import glob
import re

nav_links_template = """<ul class="nav-links">
                <li class="nav-item">
                    <a href="intro.html"{intro_active}>기업소개</a>
                    <ul class="dropdown">
                        <li><a href="intro.html">기업개요</a></li>
                        <li><a href="greetings.html">인사말</a></li>
                        <li><a href="sales_history.html">연혁</a></li>
                        <li><a href="organization.html">조직도 및 업무분장</a></li>
                        <li><a href="certifications.html">인증현황</a></li>
                        <li><a href="rd.html">연구개발(R&D)</a></li>
                        <li><a href="map.html">찾아오시는 길</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="product.html"{product_active}>주요제품</a>
                    <ul class="dropdown">
                        <li><a href="product_supply.html">급수 및 가압 시스템</a></li>
                        <li><a href="product_drainage.html">배수 및 오폐수 처리</a></li>
                        <li><a href="product_industrial.html">산업 및 특수 공정</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="notice.html"{support_active}>고객지원</a>
                    <ul class="dropdown">
                        <li><a href="notice.html">공지사항</a></li>
                        <li><a href="management.html">유지관리 지침서</a></li>
                        <li><a href="technical.html">기술자료실</a></li>
                        <li><a href="faq.html">자주 묻는 질문</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="video.html"{pr_active}>홍보센터</a>
                    <ul class="dropdown">
                        <li><a href="video.html#video">홍보 영상</a></li>
                        <li><a href="video.html#brochure">브로슈어</a></li>
                        <li><a href="video.html#cardnews">카드뉴스</a></li>
                        <li><a href="ir.html">IR 자료실</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="careers.html"{careers_active}>채용</a>
                    <ul class="dropdown">
                        <li><a href="careers.html">인재상</a></li>
                        <li><a href="job_openings.html">채용공고</a></li>
                    </ul>
                </li>
                <li><a href="inquiry.html" class="btn-primary-outline"{inquiry_active}>문의</a></li>
            </ul>"""

def fix_file(filename):
    with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # 1. Fix Title
    content = re.sub(r'<title>.*?</title>', lambda m: m.group(0).encode('latin-1').decode('utf-8', 'ignore') if '湲?' in m.group(0) else m.group(0), content)
    # Actually, let's just replace titles based on filename
    titles = {
        'index.html': '(주)비에이텍 - 깨끗하고 안전한 물의 시작',
        'intro.html': '(주)비에이텍 - 기업소개',
        'greetings.html': '인사말 | (주)비에이텍',
        'sales_history.html': '연혁 | (주)비에이텍',
        'organization.html': '조직도 | (주)비에이텍',
        'certifications.html': '인증현황 | (주)비에이텍',
        'rd.html': '연구개발 | (주)비에이텍',
        'map.html': '오시는 길 | (주)비에이텍',
        'product.html': '주요제품 | (주)비에이텍',
        'product_supply.html': '급수 및 가압 시스템 | (주)비에이텍',
        'product_drainage.html': '배수 및 오폐수 처리 | (주)비에이텍',
        'product_industrial.html': '산업 및 특수 공정 | (주)비에이텍',
        'notice.html': '공지사항 | (주)비에이텍',
        'management.html': '유지관리 지침서 | (주)비에이텍',
        'technical.html': '기술자료실 | (주)비에이텍',
        'faq.html': '자주 묻는 질문 | (주)비에이텍',
        'video.html': '홍보센터 | (주)비에이텍',
        'ir.html': 'IR 자료실 | (주)비에이텍',
        'careers.html': '채용 | (주)비에이텍',
        'job_openings.html': '채용공고 | (주)비에이텍',
        'inquiry.html': '문의 | (주)비에이텍'
    }
    if filename in titles:
        content = re.sub(r'<title>.*?</title>', f'<title>{titles[filename]}</title>', content)

    # 2. Fix Logo Icon
    content = content.replace('?뮛', '💧')
    
    # 3. Fix Nav Links
    intro_active = ' class="active"' if filename in ['intro.html', 'greetings.html', 'sales_history.html', 'organization.html', 'certifications.html', 'rd.html', 'map.html'] else ''
    product_active = ' class="active"' if filename in ['product.html', 'product_supply.html', 'product_drainage.html', 'product_industrial.html'] else ''
    support_active = ' class="active"' if filename in ['notice.html', 'management.html', 'technical.html', 'faq.html'] else ''
    pr_active = ' class="active"' if filename in ['video.html', 'ir.html'] else ''
    careers_active = ' class="active"' if filename in ['careers.html', 'job_openings.html'] else ''
    inquiry_active = ' active' if filename == 'inquiry.html' else ''
    
    nav_html = nav_links_template.format(
        intro_active=intro_active,
        product_active=product_active,
        support_active=support_active,
        pr_active=pr_active,
        careers_active=careers_active,
        inquiry_active=inquiry_active
    )
    
    content = re.sub(r'<ul class="nav-links">.*?</ul>', nav_html, content, flags=re.DOTALL)
    
    # 4. Fix Footer
    # (Simple replacement for common mojibake in footer)
    content = content.replace('?띾낫', '홍보')
    content = content.replace('湲곗뾽?뚭컻', '기업소개')
    content = content.replace('二쇱슂?쒗뭹', '주요제품')
    content = content.replace('怨좉컼吏€??', '고객지원')
    content = content.replace('梨꾩슜', '채용')
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)

for f in glob.glob('*.html'):
    fix_file(f)
    print(f"Fixed {f}")
