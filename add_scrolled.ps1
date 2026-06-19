$utf8 = New-Object System.Text.UTF8Encoding $false
$files = Get-ChildItem -Filter *.html

$scriptToInject = '
<script>
document.addEventListener("DOMContentLoaded", () => {
    // Scroll listener for navbar
    window.addEventListener("scroll", () => {
        const navbar = document.getElementById("navbar");
        if (navbar) {
            if (window.scrollY > 50) {
                navbar.classList.add("scrolled");
            } else {
                navbar.classList.remove("scrolled");
            }
        }
    });
});
</script>
'

foreach ($f in $files) {
    $text = [IO.File]::ReadAllText($f.FullName, $utf8)
    
    # Check if the scroll listener is missing
    if (-not $text.Contains("navbar.classList.add('scrolled')") -and -not $text.Contains('navbar.classList.add("scrolled")')) {
        $text = $text.Replace("</body>", $scriptToInject + "</body>")
        [IO.File]::WriteAllText($f.FullName, $text, $utf8)
    }
}

