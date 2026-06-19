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

# ORIGINAL QR code position to ERASE (from last successful attempt)
$origRightDist = [math]::Round($w * 0.058)
$origBottomDist = [math]::Round($h * 0.034)
$origX = $w - $qrW - $origRightDist
$origY = $h - $qrH - $origBottomDist

# NEW QR code position to DRAW (moved ~30% of QR width to the right)
$newRightDist = [math]::Round($w * 0.035)
$newBottomDist = [math]::Round($h * 0.034)
$newX = $w - $qrW - $newRightDist
$newY = $h - $qrH - $newBottomDist

$bmp = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmp)

$g.DrawImage($img1, 0, 0, $w, $h)

# Erase old QR code
$eraseW = [math]::Round($qrW * 1.1)
$eraseH = [math]::Round($qrH * 1.1)
$eraseX = $origX - [math]::Round(($eraseW - $qrW) / 2)
$eraseY = $origY - [math]::Round(($eraseH - $qrH) / 2)

$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.FillRectangle($brush, $eraseX, $eraseY, $eraseW, $eraseH)

# Draw new QR code
$g.DrawImage($img2, $newX, $newY, $qrW, $qrH)

$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)

$g.Dispose()
$bmp.Dispose()
$img1.Dispose()
$img2.Dispose()

Write-Host "Image successfully edited with new position."
