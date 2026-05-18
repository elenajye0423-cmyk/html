$htmlFiles = @(
    'careers.html', 'certifications.html', 'facilities.html', 'faq.html', 
    'greetings.html', 'index.html', 'inquiry.html', 'intro.html', 'ir.html', 
    'job_openings.html', 'management-viewer.html', 'management.html', 'map.html', 
    'notice.html', 'organization.html', 'product.html', 'product_drainage.html', 
    'product_industrial.html', 'product_supply.html', 'rd.html', 
    'sales_history.html', 'technical.html', 'video.html'
)

$replacements = @{
    '湲곗뾽?뚭컻' = '기업소개'
    '湲곗뾽媛쒖슂' = '기업개요'
    '?몄궗留?' = '인사말'
    '?고쁺' = '연혁'
    '議곗쭅??諛??낅Т遺꾩옣' = '조직도 및 업무분장'
    '?몄쬆?꾪솴' = '인증현황'
    '?곌뎄媛쒕컻(R&D)' = '연구개발(R&D)'
    '李얩븘?ㅼ떆??湲?' = '찾아오시는 길'
    '二쇱슂?쒗뭹' = '주요제품'
    '湲됱닔 諛?媛€???쒖뒪??' = '급수 및 가압 시스템'
    '諛곗닔 諛??ㅽ룓??泥섎━' = '배수 및 오폐수 처리'
    '?곗뾽 諛??뱀닔 怨듭젙' = '산업 및 특수 공정'
    '怨좉컼吏€??' = '고객지원'
    '怨듭??ы빆' = '공지사항'
    '?좎?愿€由?吏€移⑥꽌' = '유지관리 지침서'
    '湲곗닠?먮즺??' = '기술자료실'
    '?먯＜ 臾삳뒗 吏덈Ц' = '자주 묻는 질문'
    '?띾낫?쇳꽣' = '홍보센터'
    '?띾낫' = '홍보'
    'IR ?먮즺??' = 'IR 자료실'
    '梨꾩슜' = '채용'
    '?몄옱??' = '인재상'
    '梨꾩슜怨듦퀬' = '채용공고'
    '臾몄쓽' = '문의'
    '?뮛' = '💧'
}

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllText((Resolve-Path $file), [System.Text.Encoding]::UTF8)
        
        foreach ($old in $replacements.Keys) {
            $content = $content.Replace($old, $replacements[$old])
        }
        
        # Navigation block replacement
        $navTemplate = @"
<ul class="nav-links">
                <li class="nav-item">
                    <a href="intro.html">기업소개</a>
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
                        <li><a href="video.html#video">홍보 영상</a></li>
                        <li><a href="video.html#brochure">브로슈어</a></li>
                        <li><a href="video.html#cardnews">카드뉴스</a></li>
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
                <li><a href="inquiry.html" class="btn-primary-outline">문의</a></li>
            </ul>
"@
        
        $content = [regex]::Replace($content, '(?s)<ul class="nav-links">.*?</ul>', $navTemplate)
        
        [System.IO.File]::WriteAllText((Resolve-Path $file), $content, [System.Text.Encoding]::UTF8)
        Write-Host "Fixed $file"
    }
}
