$utf8 = New-Object System.Text.UTF8Encoding $false

# product_supply.html
$file = "product_supply.html"
$text = [IO.File]::ReadAllText($file, $utf8)

$find1 = '                        <div class="feature-item"><span class="feature-dot"></span>스마트 모니터링 시스템을 통한 실시간 관리</div>
                    </div>'
$rep1 = $find1 + '
                    <div class="product-action" style="margin-top: 2rem;">
                        <button class="btn-primary-outline view-manual-btn" onclick="toggleManual(this, ''assets/manuals/부스터펌프 유지관리지침서.pdf'')" style="width: 100%; padding: 12px; font-weight: bold; border-radius: 8px; cursor: pointer; border: 2px solid var(--primary-color); background: transparent; color: var(--primary-color); transition: all 0.3s;">
                            📄 유지관리지침서 열람하기
                        </button>
                    </div>
                    <div class="manual-viewer-container" style="display: none; margin-top: 1.5rem; height: 600px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; transition: all 0.3s ease;">
                        <iframe src="" style="width: 100%; height: 100%; border: none;"></iframe>
                    </div>'
$text = $text.Replace($find1, $rep1)

$find2 = '                        <div class="feature-item"><span class="feature-dot"></span>다양한 재질 선택 가능 (주철, 스테인리스 등)</div>
                    </div>'
$rep2 = $find2 + '
                    <div class="product-action" style="margin-top: 2rem;">
                        <button class="btn-primary-outline view-manual-btn" onclick="toggleManual(this, ''assets/manuals/편흡입볼류트펌프 유지관리지침서.pdf'')" style="width: 100%; padding: 12px; font-weight: bold; border-radius: 8px; cursor: pointer; border: 2px solid var(--primary-color); background: transparent; color: var(--primary-color); transition: all 0.3s;">
                            📄 유지관리지침서 열람하기
                        </button>
                    </div>
                    <div class="manual-viewer-container" style="display: none; margin-top: 1.5rem; height: 600px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; transition: all 0.3s ease;">
                        <iframe src="" style="width: 100%; height: 100%; border: none;"></iframe>
                    </div>'
$text = $text.Replace($find2, $rep2)

$script = '
<script>
function toggleManual(btn, pdfPath) {
    const container = btn.parentElement.nextElementSibling;
    const iframe = container.querySelector("iframe");
    
    if (container.style.display === "none") {
        iframe.src = pdfPath;
        container.style.display = "block";
        btn.innerHTML = "닫기 ❌";
        btn.style.background = "var(--primary-color)";
        btn.style.color = "white";
    } else {
        container.style.display = "none";
        iframe.src = "";
        btn.innerHTML = "📄 유지관리지침서 열람하기";
        btn.style.background = "transparent";
        btn.style.color = "var(--primary-color)";
    }
}
</script>
</body>'
$text = $text.Replace('</body>', $script)
[IO.File]::WriteAllText($file, $text, $utf8)

# product_drainage.html
$file = "product_drainage.html"
$text = [IO.File]::ReadAllText($file, $utf8)
$find1 = '                        <div class="feature-item"><span class="feature-dot"></span>자동 착탈 장치를 이용한 간편한 유지보수</div>
                    </div>'
$rep1 = $find1 + '
                    <div class="product-action" style="margin-top: 2rem;">
                        <button class="btn-primary-outline view-manual-btn" onclick="toggleManual(this, ''assets/manuals/수중펌프 유지관리지침서.pdf'')" style="width: 100%; padding: 12px; font-weight: bold; border-radius: 8px; cursor: pointer; border: 2px solid var(--primary-color); background: transparent; color: var(--primary-color); transition: all 0.3s;">
                            📄 유지관리지침서 열람하기
                        </button>
                    </div>
                    <div class="manual-viewer-container" style="display: none; margin-top: 1.5rem; height: 600px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; transition: all 0.3s ease;">
                        <iframe src="" style="width: 100%; height: 100%; border: none;"></iframe>
                    </div>'
$text = $text.Replace($find1, $rep1)

$find2 = '                        <div class="feature-item"><span class="feature-dot"></span>에너지 효율을 고려한 유체 역학적 설계</div>
                    </div>'
$rep2 = $find2 + '
                    <div class="product-action" style="margin-top: 2rem;">
                        <button class="btn-primary-outline view-manual-btn" onclick="toggleManual(this, ''assets/manuals/슬러지펌프 유지관리지침서.pdf'')" style="width: 100%; padding: 12px; font-weight: bold; border-radius: 8px; cursor: pointer; border: 2px solid var(--primary-color); background: transparent; color: var(--primary-color); transition: all 0.3s;">
                            📄 유지관리지침서 열람하기
                        </button>
                    </div>
                    <div class="manual-viewer-container" style="display: none; margin-top: 1.5rem; height: 600px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; transition: all 0.3s ease;">
                        <iframe src="" style="width: 100%; height: 100%; border: none;"></iframe>
                    </div>'
$text = $text.Replace($find2, $rep2)
$text = $text.Replace('</body>', $script)
[IO.File]::WriteAllText($file, $text, $utf8)

# product_industrial.html
$file = "product_industrial.html"
$text = [IO.File]::ReadAllText($file, $utf8)
$find1 = '                        <div class="feature-item"><span class="feature-dot"></span>정밀한 회전수 제어를 통한 유량 조절</div>
                    </div>'
$rep1 = $find1 + '
                    <div class="product-action" style="margin-top: 2rem;">
                        <button class="btn-primary-outline view-manual-btn" onclick="toggleManual(this, ''assets/manuals/일축나사식 모노펌프 유지관리지침서.pdf'')" style="width: 100%; padding: 12px; font-weight: bold; border-radius: 8px; cursor: pointer; border: 2px solid var(--primary-color); background: transparent; color: var(--primary-color); transition: all 0.3s;">
                            📄 유지관리지침서 열람하기
                        </button>
                    </div>
                    <div class="manual-viewer-container" style="display: none; margin-top: 1.5rem; height: 600px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; transition: all 0.3s ease;">
                        <iframe src="" style="width: 100%; height: 100%; border: none;"></iframe>
                    </div>'
$text = $text.Replace($find1, $rep1)

$find2 = '                        <div class="feature-item"><span class="feature-dot"></span>외부 신호(4~20mA) 연동 제어</div>
                    </div>'
$rep2 = $find2 + '
                    <div class="product-action" style="margin-top: 2rem;">
                        <button class="btn-primary-outline view-manual-btn" onclick="toggleManual(this, ''assets/manuals/정량펌프 유지관리지침서.pdf'')" style="width: 100%; padding: 12px; font-weight: bold; border-radius: 8px; cursor: pointer; border: 2px solid var(--primary-color); background: transparent; color: var(--primary-color); transition: all 0.3s;">
                            📄 유지관리지침서 열람하기
                        </button>
                    </div>
                    <div class="manual-viewer-container" style="display: none; margin-top: 1.5rem; height: 600px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; transition: all 0.3s ease;">
                        <iframe src="" style="width: 100%; height: 100%; border: none;"></iframe>
                    </div>'
$text = $text.Replace($find2, $rep2)
$text = $text.Replace('</body>', $script)
[IO.File]::WriteAllText($file, $text, $utf8)

