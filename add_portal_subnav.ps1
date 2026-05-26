$noticeHtml = Get-Content ".\portal_notice.html" -Raw -Encoding UTF8
$formsHtml = Get-Content ".\portal_forms.html" -Raw -Encoding UTF8

$subNavNotice = @"
    <nav class="sub-nav">
        <div class="sub-nav-container">
            <a href="portal_notice.html" class="sub-nav-link active">사내 공지사항</a>
            <a href="portal_forms.html" class="sub-nav-link">서식 (템플릿 및 자료실)</a>
        </div>
    </nav>

    <section class="container">
"@

$subNavForms = @"
    <nav class="sub-nav">
        <div class="sub-nav-container">
            <a href="portal_notice.html" class="sub-nav-link">사내 공지사항</a>
            <a href="portal_forms.html" class="sub-nav-link active">서식 (템플릿 및 자료실)</a>
        </div>
    </nav>

    <section class="container">
"@

# Replace in portal_notice.html
if ($noticeHtml -notmatch "sub-nav-container") {
    $noticeHtml = $noticeHtml -replace '    <section class="container">', $subNavNotice
    [IO.File]::WriteAllText(".\portal_notice.html", $noticeHtml, (New-Object System.Text.UTF8Encoding $False))
    Write-Host "Updated portal_notice.html"
}

# Replace in portal_forms.html
if ($formsHtml -notmatch "sub-nav-container") {
    $formsHtml = $formsHtml -replace '    <section class="container">', $subNavForms
    [IO.File]::WriteAllText(".\portal_forms.html", $formsHtml, (New-Object System.Text.UTF8Encoding $False))
    Write-Host "Updated portal_forms.html"
}
