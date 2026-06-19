$musicPlayerHtml = @"
                <div class="bg-music-player">
                    <div class="music-info">BGM: Crystal Stream</div>
                    <div class="player-controls">
                        <button id="music-toggle" class="music-btn" title="재생/일시정지">⏸</button>
                        <input type="range" id="volume-slider" class="volume-slider" min="0" max="1" step="0.1" value="0.15">
                    </div>
                    <audio id="bg-music" loop>
                        <source src="Crystal Stream.mp3" type="audio/mpeg">
                    </audio>
                </div>
"@

$htmlFiles = Get-ChildItem -Filter *.html

foreach ($file in $htmlFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $modified = $false

    if ($content -notlike '*class="bg-music-player"*') {
        Write-Output "Processing $($file.Name)..."
        # Search for company-desc
        if ($content -match '(?s)(<p class="company-desc">.*?</p>)') {
            $descBlock = $Matches[1]
            $content = $content.Replace($descBlock, "$descBlock`n$musicPlayerHtml")
            $modified = $true
            Write-Output "  Added music player after company-desc"
        } elseif ($content -match '(?s)(<div class="footer-brand">.*?)') {
            $brandBlock = $Matches[1]
            $content = $content.Replace($brandBlock, "$brandBlock`n$musicPlayerHtml")
            $modified = $true
            Write-Output "  Added music player after footer-brand"
        }
    }

    if ($content -notlike '*src="music_player.js"*') {
        if ($content -match '</body>') {
            $content = $content.Replace('</body>', "    <script src=`"music_player.js`"></script>`n</body>")
            $modified = $true
            Write-Output "  Added music_player.js script tag"
        }
    }

    if ($modified) {
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Output "  Successfully updated $($file.Name)"
    }
}
