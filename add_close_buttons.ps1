$utf8 = New-Object System.Text.UTF8Encoding $false

$files = @("portal_board.html", "portal_archive.html", "portal_calendar.html", "portal.html")

$closeBtn = "`n        <button onclick=`"this.closest('dialog').close()`" style=`"position: absolute; top: 20px; right: 20px; background: transparent; border: none; font-size: 1.5rem; color: #94a3b8; cursor: pointer; padding: 5px; transition: 0.2s;`" onmouseover=`"this.style.color='#ef4444'`" onmouseout=`"this.style.color='#94a3b8'`"><i class=`"fa-solid fa-xmark`"></i></button>"

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = [IO.File]::ReadAllText($file, $utf8)
        
        # Only inject if we haven't already injected the close button
        if ($content -notmatch 'fa-xmark') {
            # Use Regex to find <dialog> and insert the button right after
            $content = [regex]::Replace($content, '(<dialog[^>]*>)', "`$1$closeBtn")
            
            [IO.File]::WriteAllText($file, $content, $utf8)
            Write-Host "Updated $file"
        } else {
            Write-Host "Skipped $file (already has close button)"
        }
    }
}

