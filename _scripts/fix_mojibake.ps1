$files = Get-ChildItem -Filter *.html

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $modified = $false

    # Fix the music player buttons
    if ($content -match '\?ъ깮/\?쇱떆\?뺤\?') {
        $content = $content -replace '\?ъ깮/\?쇱떆\?뺤\?', '재생/일시정지'
        $modified = $true
    }
    if ($content -match '>/button>') {
        $content = $content -replace '>/button>', '>⏸</button>'
        $modified = $true
    }
    
    # General Mojibake fixes for common terms if found
    $replacements = @{
        '吏€移⑥꽌 酉곗뼱' = '지침서 뷰어';
        '??紐⑸줉?쇰줈 ?뚯븘媛€湲?' = '목록으로 돌아가기';
        '鍮곗뿉?댄뀓' = '비에이텍'
    }
    
    foreach ($old in $replacements.Keys) {
        if ($content.Contains($old)) {
            $content = $content.Replace($old, $replacements[$old])
            $modified = $true
        }
    }

    if ($modified) {
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Output "Fixed mojibake in $($file.Name)"
    }
}
