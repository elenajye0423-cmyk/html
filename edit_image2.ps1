Add-Type -AssemblyName System.Drawing

$img1Path = "c:\Users\elena\OneDrive\바탕 화면\26-1학기\ai\html-main\new_brochure.jpg"
$img2Path = "c:\Users\elena\OneDrive\바탕 화면\26-1학기\ai\html-main\new_qr.png"
$outPath = "c:\Users\elena\OneDrive\바탕 화면\26-1학기\ai\html-main\new_brochure_edited.jpg"

if (-not (Test-Path $img1Path)) { Write-Host "img1 not found"; exit }
if (-not (Test-Path $img2Path)) { Write-Host "img2 not found"; exit }

$img1 = [System.Drawing.Image]::FromFile($img1Path)
$img2 = [System.Drawing.Image]::FromFile($img2Path)

$w = $img1.Width
$h = $img1.Height

$qrW = [math]::Round($w * 0.09)
$qrH = [math]::Round($img2.Height * ($qrW / $img2.Width))

$rightDist = [math]::Round($w * 0.058)
$bottomDist = [math]::Round($h * 0.034)

$x = $w - $qrW - $rightDist
$y = $h - $qrH - $bottomDist

$bmp = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmp)

$g.DrawImage($img1, 0, 0, $w, $h)

$eraseW = [math]::Round($qrW * 1.1)
$eraseH = [math]::Round($qrH * 1.1)
$eraseX = $x - [math]::Round(($eraseW - $qrW) / 2)
$eraseY = $y - [math]::Round(($eraseH - $qrH) / 2)

$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.FillRectangle($brush, $eraseX, $eraseY, $eraseW, $eraseH)

$g.DrawImage($img2, $x, $y, $qrW, $qrH)

$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)

$g.Dispose()
$bmp.Dispose()
$img1.Dispose()
$img2.Dispose()

Write-Host "Image successfully edited."
