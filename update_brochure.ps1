$path = "c:\Users\elena\OneDrive\바탕 화면\26-1학기\ai\html-main\brochure.html"
$content = Get-Content -Raw -Encoding UTF8 $path

$cssStart = $content.IndexOf('/* 새 브로슈어 슬라이더 스타일 */')
if ($cssStart -ge 0) {
    $styleEnd = $content.IndexOf('</style>', $cssStart)
    $content = $content.Substring(0, $cssStart) + $content.Substring($styleEnd)
}

$htmlStart = $content.IndexOf('<div class="brochure-slider-container fade-in-up">')
if ($htmlStart -ge 0) {
    $scriptStart = $content.IndexOf('<script>', $htmlStart)
    $scriptEnd = $content.IndexOf('</script>', $scriptStart) + 9
    $content = $content.Substring(0, $htmlStart) + $content.Substring($scriptEnd)
}

$showcaseStart = $content.IndexOf('<div class="brochure-showcase fade-in-up"')
$sectionEnd = $content.IndexOf('</section>', $showcaseStart)

$newStructureHtml = @"
        <div class="brochure-controls text-center fade-in-up" style="margin-bottom: 30px;">
            <button id="btn-old-brochure" class="btn active" onclick="switchBrochure('old', true)" style="padding: 10px 24px; border-radius: 30px; background: #0284c7; color: white; border: none; margin: 0 5px; font-weight: bold; cursor: pointer; transition: 0.3s; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">기존 브로슈어</button>
            <button id="btn-new-brochure" class="btn" onclick="switchBrochure('new', true)" style="padding: 10px 24px; border-radius: 30px; background: #e2e8f0; color: #475569; border: none; margin: 0 5px; font-weight: bold; cursor: pointer; transition: 0.3s; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">신규 브로슈어</button>
        </div>

        <!-- 기존 브로슈어 래퍼 -->
        <div id="view-old-brochure" style="display: block; transition: opacity 0.4s ease;">
"@

$newBrochureHtml = @"
        </div>

        <!-- 신규 브로슈어 래퍼 -->
        <div id="view-new-brochure" class="fade-in-up" style="display: none; position: relative; width: 100%; max-width: 1100px; margin: 0 auto; transition: opacity 0.4s ease; text-align: center;">
            <img src="new_brochure.jpg" alt="신규 브로슈어" style="width: 100%; height: auto; border-radius: 20px; box-shadow: 0 20px 45px -10px rgba(0,0,0,0.25); display: block;">
            <img src="new_qr.png" alt="홈페이지 바로가기 QR코드" style="position: absolute; bottom: 4%; right: 4%; width: 12%; height: auto; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); background: white; padding: 5px; z-index: 5;">
        </div>

        <script>
            let currentView = 'old';
            let autoSwitchInterval;

            function switchBrochure(view, manual = false) {
                currentView = view;
                if(view === 'old') {
                    document.getElementById('view-old-brochure').style.display = 'block';
                    document.getElementById('view-new-brochure').style.display = 'none';
                    document.getElementById('btn-old-brochure').style.background = '#0284c7';
                    document.getElementById('btn-old-brochure').style.color = 'white';
                    document.getElementById('btn-new-brochure').style.background = '#e2e8f0';
                    document.getElementById('btn-new-brochure').style.color = '#475569';
                } else {
                    document.getElementById('view-old-brochure').style.display = 'none';
                    document.getElementById('view-new-brochure').style.display = 'block';
                    document.getElementById('btn-new-brochure').style.background = '#0284c7';
                    document.getElementById('btn-new-brochure').style.color = 'white';
                    document.getElementById('btn-old-brochure').style.background = '#e2e8f0';
                    document.getElementById('btn-old-brochure').style.color = '#475569';
                }
                
                if (manual) {
                    clearInterval(autoSwitchInterval);
                    startAutoSwitch();
                }
            }

            function startAutoSwitch() {
                autoSwitchInterval = setInterval(() => {
                    if (currentView === 'old') switchBrochure('new', false);
                    else switchBrochure('old', false);
                }, 5000);
            }

            document.addEventListener('DOMContentLoaded', () => {
                startAutoSwitch();
            });
        </script>
"@

$content = $content.Substring(0, $showcaseStart) + $newStructureHtml + $content.Substring($showcaseStart, $sectionEnd - $showcaseStart) + $newBrochureHtml + $content.Substring($sectionEnd)

[System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
Write-Host "Updated successfully."
