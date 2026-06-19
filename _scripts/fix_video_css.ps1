$content = Get-Content ".\video.html" -Raw -Encoding UTF8

$oldCss = '(?m)^[ \t]*\.bifold-spread \{[\s\S]*?width: 100%; aspect-ratio: 1\.414 / 1;[\s\S]*?container-type: inline-size;[\s\S]*?\}'
$newCss = @'
            .bifold-spread {
                width: 100%; aspect-ratio: 1.414 / 1; min-height: max-content;
                display: flex; background: #fff; border-radius: 6px;
                box-shadow: 0 20px 45px -10px rgba(0,0,0,0.25);
                position: relative; overflow: hidden;
                transition: transform 0.4s cubic-bezier(0.16,1,0.3,1), box-shadow 0.4s ease;
                container-type: inline-size;
            }
'@

$newContent = $content -replace $oldCss, $newCss

if ($content -cne $newContent) {
    [IO.File]::WriteAllText(".\video.html", $newContent, (New-Object System.Text.UTF8Encoding $False))
    Write-Host "Updated video.html"
} else {
    Write-Host "No changes made."
}
