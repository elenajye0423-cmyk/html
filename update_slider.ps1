$path = "c:\Users\elena\OneDrive\바탕 화면\26-1학기\ai\html-main\brochure.html"
$content = Get-Content -Raw -Encoding UTF8 $path

$content = $content -replace '<div id="view-old-brochure" style="display: block; transition: opacity 0.4s ease;">', '<div class="brochure-slider-window" style="overflow: hidden; width: 100%; max-width: 1100px; margin: 0 auto; box-shadow: 0 10px 30px rgba(0,0,0,0.1); border-radius: 20px;">
    <div class="brochure-slider-track" id="brochure-track" style="display: flex; width: 200%; transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1); transform: translateX(0%); align-items: flex-start;">
        <!-- 기존 브로슈어 래퍼 -->
        <div id="view-old-brochure" style="width: 50%; flex-shrink: 0;">'

$content = $content -replace '</div>\s*<!-- 신규 브로슈어 래퍼 -->\s*<div id="view-new-brochure" class="fade-in-up" style="display: none; position: relative; width: 100%; max-width: 1100px; margin: 0 auto; transition: opacity 0.4s ease; text-align: center;">', '</div>
        <!-- 신규 브로슈어 래퍼 -->
        <div id="view-new-brochure" style="width: 50%; flex-shrink: 0; position: relative; text-align: center;">'

$scriptStart = $content.IndexOf('<script>', $content.IndexOf('let currentView = ''old'';'))
$scriptEnd = $content.IndexOf('</script>', $scriptStart) + 9

$newScript = @"
        <script>
            let currentView = 'old';
            let autoSwitchInterval;

            function switchBrochure(view, manual = false) {
                currentView = view;
                const track = document.getElementById('brochure-track');
                if(view === 'old') {
                    track.style.transform = 'translateX(0%)';
                    document.getElementById('btn-old-brochure').style.background = '#0284c7';
                    document.getElementById('btn-old-brochure').style.color = 'white';
                    document.getElementById('btn-new-brochure').style.background = '#e2e8f0';
                    document.getElementById('btn-new-brochure').style.color = '#475569';
                } else {
                    track.style.transform = 'translateX(-50%)';
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
                }, 180000);
            }

            document.addEventListener('DOMContentLoaded', () => {
                startAutoSwitch();
            });
        </script>
    </div> <!-- end brochure-slider-track -->
</div> <!-- end brochure-slider-window -->
"@

$content = $content.Substring(0, $scriptStart) + $newScript + $content.Substring($scriptEnd)

[System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
Write-Host "Replaced successfully."
