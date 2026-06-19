$path = "c:\Users\elena\OneDrive\바탕 화면\26-1학기\ai\html-main\brochure.html"
$content = Get-Content -Raw -Encoding UTF8 $path

$content = $content -replace 'style="overflow: hidden; width: 100%; max-width: 1100px; margin: 0 auto; box-shadow: 0 10px 30px rgba\(0,0,0,0.1\); border-radius: 20px;"', 'style="overflow: hidden; width: 100%; max-width: 1100px; margin: 0 auto; box-shadow: 0 10px 30px rgba(0,0,0,0.1); border-radius: 20px; transition: height 0.6s cubic-bezier(0.25, 1, 0.5, 1);"'

$scriptStart = $content.IndexOf('<script>', $content.IndexOf("let currentView = 'old';"))
$scriptEnd = $content.IndexOf('</script>', $scriptStart) + 9

$newScript = @"
        <script>
            let currentView = 'old';

            function adjustWindowHeight(view) {
                const windowEl = document.querySelector('.brochure-slider-window');
                const targetId = view === 'old' ? 'view-old-brochure' : 'view-new-brochure';
                const targetEl = document.getElementById(targetId);
                if (windowEl && targetEl) {
                    windowEl.style.height = targetEl.offsetHeight + 'px';
                }
            }

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
                
                adjustWindowHeight(view);
            }

            window.addEventListener('load', () => {
                adjustWindowHeight(currentView);
                // 혹시 이미지 로딩 지연에 대비해 약간 딜레이 후 한 번 더 맞춤
                setTimeout(() => adjustWindowHeight(currentView), 500);
            });
            window.addEventListener('resize', () => {
                adjustWindowHeight(currentView);
            });
        </script>
"@

$content = $content.Substring(0, $scriptStart) + $newScript + $content.Substring($scriptEnd)

[System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
Write-Host "Height adjustment script added."
