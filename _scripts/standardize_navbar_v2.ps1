$megaMenuHtml = @"
    <nav id="navbar">
        <div class="nav-container">
            <a href="index.html" class="logo"><span class="logo-icon">💧</span> B.A. TECH</a>
            <ul class="nav-links">
                <li class="nav-item" data-menu="1"><a href="intro.html">기업소개</a></li>
                <li class="nav-item" data-menu="2"><a href="product.html">주요제품</a></li>
                <li class="nav-item" data-menu="3"><a href="notice.html">고객지원</a></li>
                <li class="nav-item" data-menu="4"><a href="video.html">홍보센터</a></li>
                <li class="nav-item" data-menu="5"><a href="careers.html">채용</a></li>
                <li><a href="inquiry.html" class="btn-primary-outline">문의</a></li>
            </ul>
            <div class="menu-toggle" id="mobile-menu"><span class="bar"></span><span class="bar"></span><span class="bar"></span></div>
        </div>
        <!-- Mega Menu Desktop -->
        <div class="mega-menu-panel">
            <div class="mega-container">
                <div class="mega-col">
                    <ul class="mega-list">
                        <li><a href="intro.html">기업개요</a></li>
                        <li><a href="greetings.html">인사말</a></li>
                        <li><a href="sales_history.html">연혁</a></li>
                        <li><a href="organization.html">조직도 및 업무분장</a></li>
                        <li><a href="certifications.html">인증현황</a></li>
                        <li><a href="rd.html">연구개발(R&D)</a></li>
                        <li><a href="map.html">찾아오시는 길</a></li>
                    </ul>
                </div>
                <div class="mega-col">
                    <ul class="mega-list">
                        <li><a href="product_supply.html">급수 및 가압 시스템</a></li>
                        <li><a href="product_drainage.html">배수 및 오폐수 처리</a></li>
                        <li><a href="product_industrial.html">산업 및 특수 공정</a></li>
                    </ul>
                </div>
                <div class="mega-col">
                    <ul class="mega-list">
                        <li><a href="notice.html">공지사항</a></li>
                        <li><a href="management.html">유지관리 지침서</a></li>
                        <li><a href="technical.html">기술자료실</a></li>
                        <li><a href="faq.html">자주 묻는 질문</a></li>
                    </ul>
                </div>
                <div class="mega-col">
                    <ul class="mega-list">
                        <li><a href="video.html#video">홍보 영상</a></li>
                        <li><a href="video.html#brochure">브로슈어</a></li>
                        <li><a href="video.html#cardnews">카드뉴스</a></li>
                        <li><a href="ir.html">IR 자료실</a></li>
                    </ul>
                </div>
                <div class="mega-col">
                    <ul class="mega-list">
                        <li><a href="careers.html">인재상</a></li>
                        <li><a href="job_openings.html">채용공고</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
"@

$files = Get-ChildItem -Filter *.html

foreach ($file in $files) {
    if ($file.Name -eq "management-viewer.html") { continue }
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($content -match '(?s)<nav id="navbar".*?</nav>') {
        $oldNav = $Matches[0]
        $content = $content.Replace($oldNav, $megaMenuHtml)
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
    }
}
