Add-Type -AssemblyName System.Drawing

$path = "c:\Users\elena\OneDrive\바탕 화면\26-1학기\ai\html-main"
$img1Path = Join-Path $path "new_brochure.jpg"
$img2Path = Join-Path $path "new_qr.png"
$outPath = Join-Path $path "new_brochure_edited.jpg"

$img1 = [System.Drawing.Image]::FromFile($img1Path)
$img2 = [System.Drawing.Image]::FromFile($img2Path)

$w = $img1.Width
$h = $img1.Height

# User's final adjusted CSS values: width 9%, right 5.8%, bottom 3.4%
$qrW = [math]::Round($w * 0.09)
$qrH = [math]::Round($img2.Height * ($qrW / $img2.Width))

$rightDist = [math]::Round($w * 0.058)
$bottomDist = [math]::Round($h * 0.034)

$x = $w - $qrW - $rightDist
$y = $h - $qrH - $bottomDist

# Create a new bitmap to draw on so we don't lock the original file awkwardly, though FromFile is fine.
$bmp = New-Object System.Drawing.Bitmap($img1)
$g = [System.Drawing.Graphics]::FromImage($bmp)

# First, erase the old QR code with a white rectangle that is slightly larger (10% larger) to make sure it covers it entirely
$eraseW = [math]::Round($qrW * 1.1)
$eraseH = [math]::Round($qrH * 1.1)
$eraseX = $x - [math]::Round(($eraseW - $qrW) / 2)
$eraseY = $y - [math]::Round(($eraseH - $qrH) / 2)

$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.FillRectangle($brush, $eraseX, $eraseY, $eraseW, $eraseH)

# Now draw the new QR code
$g.DrawImage($img2, $x, $y, $qrW, $qrH)

# Save
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)

# Cleanup
$g.Dispose()
$bmp.Dispose()
$img1.Dispose()
$img2.Dispose()

Write-Host "Image successfully edited."
