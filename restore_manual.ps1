$replacements = @{
    '湲곗뾽?뚭컻' = '기업소개'
    '湲곗뾽媛쒖슂' = '기업개요'
    '?몄궗留?' = '인사말'
    '?고쁺' = '연혁'
    '議곗쭅??諛??낅Т遺꾩옣' = '조직도 및 업무분장'
    '?몄쬆?꾪솴' = '인증현황'
    '?곌뎄媛쒕컻(R&D)' = '연구개발(R&D)'
    '李얠븘?ㅼ떆??湲?' = '찾아오시는 길'
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
    '?띾낫 ?곸긽' = '홍보 영상'
    '釉뚮줈?덉뼱' = '브로슈어'
    '移대뱶?댁뒪' = '카드뉴스'
    'IR ?먮즺??' = 'IR 자료실'
    '梨꾩슜' = '채용'
    '?몄옱??' = '인재상'
    '梨꾩슜怨듦퀬' = '채용공고'
    '臾몄쓽' = '문의'
}

Get-ChildItem *.html | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
    foreach ($old in $replacements.Keys) {
        $content = $content.Replace($old, $replacements[$old])
    }
    [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.Encoding]::UTF8)
}
