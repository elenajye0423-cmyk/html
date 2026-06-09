$utf8 = New-Object System.Text.UTF8Encoding $false
$file = "product_drainage.html"
$text = [IO.File]::ReadAllText($file, $utf8)

$restoredContent = '                        <span class="label">기술적 강점</span>
                        <span class="role-text">완벽한 방수 구조와 내마모성이 강한 소재를 사용하여 가혹한 수중 환경에서도 장시간 운전이 가능합니다. 이물질 통과 능력이 우수한 임펠러 설계가 특징입니다.</span>
                    </div>
                    <div class="facility-features" style="margin-top: 1.5rem;">
                        <div class="feature-item"><span class="feature-dot"></span>강력한 이물질 배출 능력 (Non-clog)</div>
                        <div class="feature-item"><span class="feature-dot"></span>이중 메카니컬 씰 적용으로 누수 완벽 차단</div>
                        <div class="feature-item"><span class="feature-dot"></span>자동 착탈 장치를 이용한 간편한 유지보수</div>
                    </div>
                    <div class="product-action" style="margin-top: 2rem;">
                        <button class="btn-primary-outline view-manual-btn" onclick="toggleManual(this, ''assets/manuals/수중펌프 유지관리지침서.pdf'')" style="width: 100%; padding: 12px; font-weight: bold; border-radius: 8px; cursor: pointer; border: 2px solid var(--primary-color); background: transparent; color: var(--primary-color); transition: all 0.3s;">
                            📄 유지관리지침서 열람하기
                        </button>
                    </div>
                    <div class="manual-viewer-container" style="display: none; margin-top: 1.5rem; height: 600px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; transition: all 0.3s ease;">
                        <iframe src="" style="width: 100%; height: 100%; border: none;"></iframe>
                    </div>
                </div>
            </div>

            <div class="product-card fade-in-up delay-1">
                <div class="product-img">
                    <img src="assets/sludge_pump_pro.png" alt="슬러지 펌프" style="width: 100%; height: 100%; object-fit: contain; padding: 20px;">
                </div>
                <div class="product-info">
                    <h3 class="product-title">슬러지펌프</h3>
                    <div class="info-item">
                        <span class="label">적용 분야</span>
                        <span class="role-text">하수 처리장, 분뇨 처리 시설, 산업 폐수 처리</span>
                    </div>
                    <div class="info-item">
                        <span class="label">기술적 강점</span>
                        <span class="role-text">점도가 높고 입자가 포함된 슬러지를 효율적으로 이송하기 위해 설계되었습니다. 특수 합금 임펠러를 채택하여 마모에 강하며 일정한 토출량을 유지합니다.</span>
                    </div>
                    <div class="facility-features" style="margin-top: 1.5rem;">
                        <div class="feature-item"><span class="feature-dot"></span>고농도 슬러지 이송에 최적화된 내부 구조</div>
                        <div class="feature-item"><span class="feature-dot"></span>강력한 흡입력과 막힘 방지 기능</div>
                        <div class="feature-item"><span class="feature-dot"></span>에너지 효율을 고려한 유체 역학적 설계</div>
                    </div>
                    <div class="product-action" style="margin-top: 2rem;">
                        <button class="btn-primary-outline view-manual-btn" onclick="toggleManual(this, ''assets/manuals/슬러지펌프 유지관리지침서.pdf'')" style="width: 100%; padding: 12px; font-weight: bold; border-radius: 8px; cursor: pointer; border: 2px solid var(--primary-color); background: transparent; color: var(--primary-color); transition: all 0.3s;">
                            📄 유지관리지침서 열람하기
                        </button>
                    </div>
                    <div class="manual-viewer-container" style="display: none; margin-top: 1.5rem; height: 600px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden; transition: all 0.3s ease;">
                        <iframe src="" style="width: 100%; height: 100%; border: none;"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </section>

'

$text = $text.Replace('                        <span class="label">기술적 강점</span>
                        <span class="role-text">지하 배수, 건설 현장, 침수 방지 시설, 공장 집수정</span>
                    </div>
                    <div class="info-item">
    <footer>', '                        <span class="label">기술적 강점</span>
                        <span class="role-text">지하 배수, 건설 현장, 침수 방지 시설, 공장 집수정</span>
                    </div>
                    <div class="info-item">
' + $restoredContent + '    <footer>')

# Also append the script if not present
if (-not $text.Contains("function toggleManual")) {
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
    $text = $text.Replace("</body>", $script)
}

[IO.File]::WriteAllText($file, $text, $utf8)

