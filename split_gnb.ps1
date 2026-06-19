$utf8 = New-Object System.Text.UTF8Encoding $false
$files = Get-ChildItem -Filter *.html

$newGnb = '            <li class="nav-item">
                <a href="video.html">홍보센터</a>
                <ul class="dropdown">
                    <li><a href="video.html">홍보 영상</a></li>
                    <li><a href="brochure.html">기업 브로슈어</a></li>
                    <li><a href="cardnews.html">카드뉴스</a></li>
                    <li><a href="ir.html">IR 자료실</a></li>
                </ul>
            </li>'

$newFooter = '            <div class="footer-links">
                <h4>PR &amp; IR</h4>
                <ul>
                    <li><a href="video.html">홍보 영상</a></li>
                    <li><a href="brochure.html">기업 브로슈어</a></li>
                    <li><a href="cardnews.html">카드뉴스</a></li>
                    <li><a href="ir.html">IR 자료실</a></li>
                    
                </ul>
            </div>'

foreach ($f in $files) {
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)
    
    # Replace GNB
    $text = $text -replace '(?s)<li class="nav-item">\s*<a href="video\.html">홍보센터</a>\s*<ul class="dropdown">\s*<li><a href="video\.html#video">홍보</a></li>\s*<li><a href="ir\.html">IR 자료실</a></li>\s*</ul>\s*</li>', $newGnb
    
    # Replace Footer (handle both &amp; and & just in case)
    $text = $text -replace '(?s)<div class="footer-links">\s*<h4>PR (?:&amp;|&) IR</h4>\s*<ul>\s*<li><a href="video\.html">홍보</a></li>\s*<li><a href="ir\.html">IR 자료실</a></li>\s*</ul>\s*</div>', $newFooter
    $text = $text -replace '(?s)<div class="footer-links">\s*<h4>PR (?:&amp;|&) IR</h4>\s*<ul>\s*<li><a href="video\.html">홍보</a></li>\s*<li><a href="ir\.html">IR 자료실</a></li>\s*<li>\s*</li>\s*</ul>\s*</div>', $newFooter

    # Update ir.html LNB specifically
    if ($f.Name -eq "ir.html") {
        $text = $text -replace '(?s)<nav class="sub-nav">\s*<div class="sub-nav-container">\s*<a href="video\.html" class="sub-nav-link">홍보</a>\s*<a href="ir\.html" class="sub-nav-link active">IR 자료실</a>\s*</div>\s*</nav>', '    <nav class="sub-nav">
        <div class="sub-nav-container">
            <a href="video.html" class="sub-nav-link">홍보 영상</a>
            <a href="brochure.html" class="sub-nav-link">기업 브로슈어</a>
            <a href="cardnews.html" class="sub-nav-link">카드뉴스</a>
            <a href="ir.html" class="sub-nav-link active">IR 자료실</a>
        </div>
    </nav>'
    }

    [IO.File]::WriteAllText($f.FullName, $text, $utf8)
}

