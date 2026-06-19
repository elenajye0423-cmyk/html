import os
import glob
import re

navbar_html = """<nav id="navbar">
        <div class="nav-container">
            <a href="index.html" class="logo"><span class="logo-icon">💧</span> B.A. TECH</a>
            <ul class="nav-links">
                <li class="nav-item">
                    <a href="intro.html">기업소개</a>
                    <ul class="dropdown">
                        <li><a href="intro.html">기업개요</a></li>
                        <li><a href="greetings.html">인사말</a></li>
                        <li><a href="sales_history.html">연혁</a></li>
                        <li><a href="organization.html">조직도 및 업무분장</a></li>
                        <li><a href="certifications.html">인증현황</a></li>
                        <li><a href="facilities.html">주요시설</a></li>
                        <li><a href="rd.html">연구개발(R&D)</a></li>
                        <li><a href="map.html">찾아오시는 길</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="product.html">주요제품</a>
                    <ul class="dropdown">
                        <li><a href="product_supply.html">급수 및 가압 시스템</a></li>
                        <li><a href="product_drainage.html">배수 및 오폐수 처리</a></li>
                        <li><a href="product_industrial.html">산업 및 특수 공정</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="notice.html">고객지원</a>
                    <ul class="dropdown">
                        <li><a href="notice.html">공지사항</a></li>
                        <li><a href="management.html">유지관리 지침서</a></li>
                        <li><a href="technical.html">기술자료실</a></li>
                        <li><a href="faq.html">자주 묻는 질문</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="video.html">홍보센터</a>
                    <ul class="dropdown">
                        <li><a href="video.html#video">홍보</a></li>
                        <li><a href="ir.html">IR 자료실</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="careers.html">채용</a>
                    <ul class="dropdown">
                        <li><a href="careers.html">인재상</a></li>
                        <li><a href="job_openings.html">채용공고</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="portal.html">사내 포털</a>
                    <ul class="dropdown">
                        <li><a href="portal.html#notice">사내 공지</a></li>
                        <li><a href="portal.html#manual">신입 매뉴얼</a></li>
                        <li><a href="portal.html#forms">사내 서식 및 템플릿</a></li>
                        <li><a href="portal.html#resources">업무 지원 자료실</a></li>
                        <li><a href="portal.html#welfare">복리후생</a></li>
                    </ul>
                </li>
                <li><a href="inquiry.html" class="btn-primary-outline">문의</a></li>
            </ul>
            <div class="menu-toggle" id="mobile-menu"><span class="bar"></span><span class="bar"></span><span class="bar"></span></div>
        </div>
    </nav>"""

for filename in glob.glob('*.html'):
    if filename == 'management-viewer.html':
        continue
    
    with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Replace the broken navbar
    content = re.sub(r'<nav id="navbar">.*?</nav>', navbar_html, content, flags=re.DOTALL)
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
        
print("Navbar successfully restored with UTF-8 encoding!")
