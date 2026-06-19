$utf8 = New-Object System.Text.UTF8Encoding $false
$files = Get-ChildItem -Filter *.html

$scriptBlock = @"
<script>
// Close mobile menu when clicking outside
document.addEventListener('click', function(e) {
    const mobileMenu = document.getElementById('mobile-menu');
    const navLinks = document.querySelector('.nav-links');
    if (mobileMenu && navLinks && navLinks.classList.contains('active')) {
        if (!navLinks.contains(e.target) && !mobileMenu.contains(e.target)) {
            navLinks.classList.remove('active');
            mobileMenu.classList.remove('active');
        }
    }
});
</script>
</body>
"@

foreach ($file in $files) {
    $content = [IO.File]::ReadAllText($file.FullName, $utf8)
    if ($content -notmatch "Close mobile menu when clicking outside") {
        $content = $content -replace '</body>\s*</html>', "$scriptBlock`n</html>"
        [IO.File]::WriteAllText($file.FullName, $content, $utf8)
        Write-Host "Updated $($file.Name)"
    }
}

