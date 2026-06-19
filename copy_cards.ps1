$utf8 = New-Object System.Text.UTF8Encoding $false

# 1. Copy the images
$img1 = "C:\Users\elena\.gemini\antigravity\brain\532fc25d-e88e-48ab-9006-82fe53e5b031\notebooklm_card1_1780969485489.png"
$img2 = "C:\Users\elena\.gemini\antigravity\brain\532fc25d-e88e-48ab-9006-82fe53e5b031\notebooklm_card2_1780969499888.png"

Copy-Item -Path $img1 -Destination "nb_card1.png" -Force
Copy-Item -Path $img2 -Destination "nb_card2.png" -Force

# 2. Update portal_archive.html
$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

$oldContent = "<h3 style='margin-bottom: 15px;'>1. 문서 분석 요약 자동화</h3><p style='margin-bottom: 10px;'>방대한 양의 문서를 쉽고 빠르게 요약하여 업무 효율성을 극대화합니다.</p><p>자세한 내용은 상단 첨부파일을 확인해주세요.</p>"
$newContent = "<div style='text-align: center;'><h3 style='margin-bottom: 20px; color: #1e293b;'>[카드뉴스] NotebookLM 업무 활용법</h3><img src='nb_card1.png' style='max-width: 100%; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);'><img src='nb_card2.png' style='max-width: 100%; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);'><p style='color: #475569; font-size: 1.1rem; line-height: 1.6;'>방대한 양의 사내 문서를 쉽고 빠르게 요약하여 업무 효율성을 극대화합니다.<br>위 카드뉴스를 참고하여 팀 내 업무에 적극 도입해 보시기 바랍니다.</p></div>"

$archiveSrc = $archiveSrc.Replace($oldContent, $newContent)

# 3. Bump version to force reset
$archiveSrc = $archiveSrc -replace 'batech_archive_v3', 'batech_archive_v5'
$archiveSrc = $archiveSrc -replace 'batech_archive_v4', 'batech_archive_v5'

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

