$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("video.html", $utf8)

$sec1 = '    <!-- ===== SECTION 1: 홍보 영상 ===== -->
    <section id="video" class="container" style="padding-top: 80px; padding-bottom: 80px;">
        <div class="section-header text-center" style="margin-bottom: 50px;">
            <span style="display: inline-block; background: #dbeafe; color: var(--primary-color); padding: 6px 18px; border-radius: 20px; font-size: 0.9rem; font-weight: 700; margin-bottom: 14px;">PROMOTION VIDEO</span>
            <h2 class="section-title">기업 홍보 영상</h2>
            <p class="section-description">비에이텍의 기술력과 현장을 생생한 영상으로 만나보세요.</p>
        </div>
        <div class="fade-in-up" style="max-width: 900px; margin: 0 auto; border-radius: 20px; overflow: hidden; box-shadow: var(--shadow-lg); background: #000;">
            <video width="100%" controls style="display: block;">
                <source src="영상 완성.mp4" type="video/mp4">
                브라우저가 동영상을 지원하지 않습니다.
            </video>
        </div>
    </section>'

$sec2 = [regex]::Match($src, '(?s)    <!-- ===== SECTION 2: 브로슈어 ===== -->.*?    </section>').Value
$sec3 = [regex]::Match($src, '(?s)    <!-- ===== SECTION 3: 카드뉴스 ===== -->.*?    </section>').Value

$baseSrc = $src -replace '(?s)(<nav class="sub-nav">.*?</nav>).*?(<footer>)', '$1====BODY====$2'

# 1. video.html
$vLnb = '    <nav class="sub-nav">
        <div class="sub-nav-container">
            <a href="video.html" class="sub-nav-link active">홍보 영상</a>
            <a href="brochure.html" class="sub-nav-link">기업 브로슈어</a>
            <a href="cardnews.html" class="sub-nav-link">카드뉴스</a>
            <a href="ir.html" class="sub-nav-link">IR 자료실</a>
        </div>
    </nav>'
$vSrc = $baseSrc -replace '(?s)<nav class="sub-nav">.*?</nav>', $vLnb
$vSrc = $vSrc -replace '====BODY====', "`r`n$sec1`r`n`r`n"
$vSrc = $vSrc -replace '<title>홍보 \| \(주\)비에이텍</title>', '<title>홍보 영상 | (주)비에이텍</title>'
$vSrc = $vSrc -replace '<h1 class="title">홍보</h1>', '<h1 class="title">홍보 영상</h1>'
$vSrc = $vSrc -replace '<p class="description">비에이텍의 생생한 현장과 기술력을 영상과 자료로 만나보세요.</p>', '<p class="description">비에이텍의 기술력과 현장을 생생한 영상으로 만나보세요.</p>'

# 2. brochure.html
$bLnb = '    <nav class="sub-nav">
        <div class="sub-nav-container">
            <a href="video.html" class="sub-nav-link">홍보 영상</a>
            <a href="brochure.html" class="sub-nav-link active">기업 브로슈어</a>
            <a href="cardnews.html" class="sub-nav-link">카드뉴스</a>
            <a href="ir.html" class="sub-nav-link">IR 자료실</a>
        </div>
    </nav>'
$bSrc = $baseSrc -replace '(?s)<nav class="sub-nav">.*?</nav>', $bLnb
$bSrc = $bSrc -replace '====BODY====', "`r`n$sec2`r`n`r`n"
$bSrc = $bSrc -replace '<title>홍보 \| \(주\)비에이텍</title>', '<title>기업 브로슈어 | (주)비에이텍</title>'
$bSrc = $bSrc -replace '<h1 class="title">홍보</h1>', '<h1 class="title">기업 브로슈어</h1>'
$bSrc = $bSrc -replace '<p class="description">비에이텍의 생생한 현장과 기술력을 영상과 자료로 만나보세요.</p>', '<p class="description">비에이텍의 주요 제품과 기술력을 브로슈어로 한눈에 확인하세요.</p>'

# 3. cardnews.html
$cLnb = '    <nav class="sub-nav">
        <div class="sub-nav-container">
            <a href="video.html" class="sub-nav-link">홍보 영상</a>
            <a href="brochure.html" class="sub-nav-link">기업 브로슈어</a>
            <a href="cardnews.html" class="sub-nav-link active">카드뉴스</a>
            <a href="ir.html" class="sub-nav-link">IR 자료실</a>
        </div>
    </nav>'
$cSrc = $baseSrc -replace '(?s)<nav class="sub-nav">.*?</nav>', $cLnb
$cSrc = $cSrc -replace '====BODY====', "`r`n$sec3`r`n`r`n"
$cSrc = $cSrc -replace '<title>홍보 \| \(주\)비에이텍</title>', '<title>카드뉴스 | (주)비에이텍</title>'
$cSrc = $cSrc -replace '<h1 class="title">홍보</h1>', '<h1 class="title">카드뉴스</h1>'
$cSrc = $cSrc -replace '<p class="description">비에이텍의 생생한 현장과 기술력을 영상과 자료로 만나보세요.</p>', '<p class="description">비에이텍의 유익한 정보를 쉽고 재미있는 카드 형식으로 확인하세요.</p>'

[IO.File]::WriteAllText("video.html", $vSrc, $utf8)
[IO.File]::WriteAllText("brochure.html", $bSrc, $utf8)
[IO.File]::WriteAllText("cardnews.html", $cSrc, $utf8)

