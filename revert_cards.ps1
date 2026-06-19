$utf8 = New-Object System.Text.UTF8Encoding $false
$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

$oldContent = "<div style='text-align: center;'><h3 style='margin-bottom: 20px; color: #1e293b;'>[카드뉴스] NotebookLM 업무 활용법</h3><img src='nb_card1.png' style='max-width: 100%; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);'><img src='nb_card2.png' style='max-width: 100%; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);'><p style='color: #475569; font-size: 1.1rem; line-height: 1.6;'>방대한 양의 사내 문서를 쉽고 빠르게 요약하여 업무 효율성을 극대화합니다.<br>위 카드뉴스를 참고하여 팀 내 업무에 적극 도입해 보시기 바랍니다.</p></div>"
$newContent = "<div style='text-align: center;'><h3 style='margin-bottom: 20px; color: #1e293b;'>[카드뉴스] NotebookLM 업무 활용법</h3><iframe src='notebooklm_cardnews.html' style='width: 100%; height: 650px; border: none; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); margin-bottom: 20px; max-width: 600px;'></iframe><p style='color: #475569; font-size: 1.1rem; line-height: 1.6;'>사내 기술문서 기반 AI 챗봇의 강력한 활용법을 위 카드뉴스에서 직접 스와이프하며 확인하세요.</p></div>"

$archiveSrc = $archiveSrc.Replace($oldContent, $newContent)
$archiveSrc = $archiveSrc -replace 'batech_archive_v5', 'batech_archive_v6'

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

