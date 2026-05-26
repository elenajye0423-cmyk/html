$lines = Get-Content ".\chatbot_widget.js" -Encoding UTF8
$part1 = $lines[0..244]
$part2 = Get-Content ".\chatbot_new_part.js" -Raw -Encoding UTF8

Set-Content -Path ".\chatbot_widget.js" -Value ($part1 -join "`r`n") -Encoding UTF8
Add-Content -Path ".\chatbot_widget.js" -Value "`r`n" -Encoding UTF8
Add-Content -Path ".\chatbot_widget.js" -Value $part2 -Encoding UTF8
