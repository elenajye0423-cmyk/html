$content = Get-Content ".\video.html" -Raw -Encoding UTF8

# Remove min-height: max-content; from .bifold-spread
$content = $content -replace 'aspect-ratio: 1\.414 / 1; min-height: max-content;', 'aspect-ratio: 1.414 / 1;'

# Replace the minimum value of clamp() to 0rem for all font sizes in the brochure to allow infinite shrinking
$content = [regex]::Replace($content, 'clamp\([0-9.]+rem,', 'clamp(0rem,')

if ($content) {
    [IO.File]::WriteAllText(".\video.html", $content, (New-Object System.Text.UTF8Encoding $False))
    Write-Host "Updated video.html with auto-scaling fonts."
}
