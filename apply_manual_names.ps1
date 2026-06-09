$utf8 = New-Object System.Text.UTF8Encoding $false
$files = Get-ChildItem -Filter *.html

foreach ($f in $files) {
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)

    if ($f.Name -eq "product_supply.html") {
        $text = $text.Replace('<h3 class="product-title">인버터 제어 부스터 펌프 시스템</h3>', '<h3 class="product-title">부스터펌프</h3>')
        $text = $text.Replace('<h3 class="product-title">편흡입 볼류트 펌프 (Volute Pump)</h3>', '<h3 class="product-title">편흡입볼류트펌프</h3>')
    }
    if ($f.Name -eq "product_drainage.html") {
        $text = $text.Replace('<h3 class="product-title">고성능 수중 배수 펌프</h3>', '<h3 class="product-title">수중펌프</h3>')
        $text = $text.Replace('<h3 class="product-title">고농도 슬러지 펌프 (Sludge Pump)</h3>', '<h3 class="product-title">슬러지펌프</h3>')
    }
    if ($f.Name -eq "product_industrial.html") {
        $text = $text.Replace('<h3 class="product-title">일축나사형 모노펌프 (Mono Pump)</h3>', '<h3 class="product-title">일축나사식 모노펌프</h3>')
        $text = $text.Replace('<h3 class="product-title">디지털 제어 정밀 정량 펌프</h3>', '<h3 class="product-title">정량펌프</h3>')
    }

    [IO.File]::WriteAllText($f.FullName, $text, $utf8)
}

