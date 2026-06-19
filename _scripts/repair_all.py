import os
import glob
import re

# Navigation Template
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
    'inquiry.html': '문의 | (주)비에이텍',
    'facilities.html': '주요 설비 | (주)비에이텍',
    'management-viewer.html': '지침서 뷰어 | (주)비에이텍'
}

def fix_mojibake(text):
    # This function attempts to fix text that was UTF-8 but read as CP949 and then saved as UTF-8
    try:
        # Try to find sequences that look like mojibake and fix them
        # We'll use a broad approach first: encode as CP949 then decode as UTF-8
        # But we only do this if it contains common mojibake characters like '湲' or '곗'
        if any(c in text for c in ['湲', '곗', '뾽', '?']):
            # We must be careful not to break already correct text or ASCII
            # Let's try to fix it line by line or block by block
            def replacer(match):
                s = match.group(0)
                try:
                    return s.encode('cp949').decode('utf-8')
                except:
                    return s
            
            # Match sequences of non-ASCII characters
            return re.sub(r'[^\x00-\x7f]+', replacer, text)
    except:
        pass
    return text

def fix_file(filename):
    with open(filename, 'rb') as f:
        raw = f.read()
    
    # Remove BOM if present
    if raw.startswith(b'\xef\xbb\xbf'):
        raw = raw[3:]
        
    try:
        content = raw.decode('utf-8')
    except UnicodeDecodeError:
        content = raw.decode('cp949', errors='ignore')

    # 1. Fix Mojibake in the whole content
    content = fix_mojibake(content)
    
    # 2. Specific replacements for common patterns that fix_mojibake might miss
    replacements = {
        '湲곗뾽?뚭컻': '기업소개',
        '湲곗뾽媛쒖슂': '기업개요',
        '?몄궗留?': '인사말',
        '?고쁺': '연혁',
        '議곗쭅??諛??낅Т遺꾩옣': '조직도 및 업무분장',
        '?몄쬆?꾪솴': '인증현황',
        '?곌뎄媛쒕컻(R&D)': '연구개발(R&D)',
        '李얩븘?ㅼ떆??湲?': '찾아오시는 길',
        '二쇱슂?쒗뭹': '주요제품',
        '湲됱닔 諛?媛€???쒖뒪??': '급수 및 가압 시스템',
        '諛곗닔 諛??ㅽ룓??泥섎━': '배수 및 오폐수 처리',
        '?곗뾽 諛??뱀닔 怨듭젙': '산업 및 특수 공정',
        '怨좉컼吏€??': '고객지원',
        '怨듭??ы빆': '공지사항',
        '?좎?愿€由?吏€移⑥꽌': '유지관리 지침서',
        '湲곗닠?먮즺??': '기술자료실',
        '?먯＜ 臾삳뒗 吏덈Ц': '자주 묻는 질문',
        '?띾낫?쇳꽣': '홍보센터',
        '?띾낫': '홍보',
        'IR ?먮즺??': 'IR 자료실',
        '梨꾩슜': '채용',
        '?몄옱??': '인재상',
        '梨꾩슜怨듦퀬': '채용공고',
        '臾몄쓽': '문의',
        '?뮛': '💧',
        '源⑤걮?섍퀬 ?덉쟾??': '깨끗하고 안전한',
        '理쒓퀬??': '최고의',
        '湲곗닠?μ쑝濡?': '기술력으로',
        '?뚰꽣?뚰봽': '워터펌프',
        '?쒖옉': '제작',
        '?ㅼ튂': '설치',
        '?섎━': '수리',
        '?붾（?섏쓣': '솔루션을',
        '?쒓났?⑸땲??': '제공합니다.',
        '?섎뀈媛꾩쓽': '수년간의',
        '?명븯?곗?': '노하우와',
        '異뺤쟻??': '축적된',
        '湲곗닠濡?': '기술로',
        '?대뼡': '어떤',
        '?섍꼍?먯': '환경에서',
        '?꾨??: '완벽한',
        '?깅뒫??: '성능을',
        '蹂댁옣?⑸땲??: '보장합니다.',
        '?곹샇': '상호',
        '二쇱냼': '주소',
        '?꾪솕': '전화',
        '異섏쿇??: '춘천시',
        '?댁젙?곸씤': '열정적인',
        '?몄옱瑜?: '인재를',
        '湲곕떎由쎈땲??: '기다립니다.'
    }
    for old, new in replacements.items():
        content = content.replace(old, new)

    # 3. Fix Title
    if filename in titles:
        content = re.sub(r'<title>.*?</title>', f'<title>{titles[filename]}</title>', content)

    # 4. Fix Logo Icon
    content = re.sub(r'<span class="logo-icon">.*?</span>', '<span class="logo-icon">💧</span>', content)
    
    # 5. Fix Nav Links
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
    
    # 6. Fix Sub-nav if present
    if '<nav class="sub-nav">' in content:
        # Attempt to fix mojibake in sub-nav links
        def sub_nav_fix(match):
            s = match.group(0)
            return fix_mojibake(s)
        content = re.sub(r'<nav class="sub-nav">.*?</nav>', sub_nav_fix, content, flags=re.DOTALL)

    # Write back as UTF-8 without BOM
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)

html_files = [
    'careers.html', 'certifications.html', 'facilities.html', 'faq.html', 
    'greetings.html', 'index.html', 'inquiry.html', 'intro.html', 'ir.html', 
    'job_openings.html', 'management-viewer.html', 'management.html', 'map.html', 
    'notice.html', 'organization.html', 'product.html', 'product_drainage.html', 
    'product_industrial.html', 'product_supply.html', 'rd.html', 
    'sales_history.html', 'technical.html', 'video.html'
]

for f in html_files:
    if os.path.exists(f):
        try:
            fix_file(f)
            print(f"Fixed {f}")
        except Exception as e:
            print(f"Error fixing {f}: {e}")
