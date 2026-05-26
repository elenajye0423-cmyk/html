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
                <li><a href="inquiry.html" class="btn-primary-outline{inquiry_active_btn}">문의</a></li>
            </ul>"""

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

def fix_file(filename):
    with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # 1. Fix Title
    if filename in titles:
        content = re.sub(r'<title>.*?</title>', f'<title>{titles[filename]}</title>', content)

    # 2. Fix Meta Description for index.html
    if filename == 'index.html':
        content = re.sub(r'<meta name="description" content=".*?">', '<meta name="description" content="(주)비에이텍은 깨끗하고 안전한 물을 위한 워터펌프 제작, 설치, 수리 전문기업입니다.">', content)

    # 3. Fix Logo Icon
    # Replace anything that looks like mojibake logo icon
    content = re.sub(r'<span class="logo-icon">.*?</span>', '<span class="logo-icon">💧</span>', content)
    
    # 4. Fix Nav Links
    intro_active = ' class="active"' if filename in ['intro.html', 'greetings.html', 'sales_history.html', 'organization.html', 'certifications.html', 'rd.html', 'map.html'] else ''
    product_active = ' class="active"' if filename in ['product.html', 'product_supply.html', 'product_drainage.html', 'product_industrial.html'] else ''
    support_active = ' class="active"' if filename in ['notice.html', 'management.html', 'technical.html', 'faq.html'] else ''
    pr_active = ' class="active"' if filename in ['video.html', 'ir.html'] else ''
    careers_active = ' class="active"' if filename in ['careers.html', 'job_openings.html'] else ''
    inquiry_active_btn = ' active' if filename == 'inquiry.html' else ''
    
    nav_html = nav_links_template.replace('{intro_active}', intro_active)
    nav_html = nav_html.replace('{product_active}', product_active)
    nav_html = nav_html.replace('{support_active}', support_active)
    nav_html = nav_html.replace('{pr_active}', pr_active)
    nav_html = nav_html.replace('{careers_active}', careers_active)
    nav_html = nav_html.replace('{inquiry_active_btn}', inquiry_active_btn)
    
    content = re.sub(r'<ul class="nav-links">.*?</ul>', nav_html, content, flags=re.DOTALL)
    
    # 5. Fix Footer Mojibake (Quick & Dirty)
    content = content.replace('湲곗뾽?뚭컻', '기업소개')
    content = content.replace('二쇱슂?쒗뭹', '주요제품')
    content = content.replace('怨좉컼吏€??', '고객지원')
    content = content.replace('?띾낫', '홍보')
    content = content.replace('梨꾩슜', '채용')
    content = content.replace('臾몄쓽', '문의')
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)

for f in glob.glob('*.html'):
    try:
        fix_file(f)
        print(f"Fixed {f}")
    except Exception as e:
        print(f"Error fixing {f}: {e}")
