(function() {
    function initMobileMenu() {
        const mobileMenu = document.getElementById('mobile-menu');
        const navLinks = document.querySelector('.nav-links');
        
        if (!mobileMenu || !navLinks) return;
        
        // Remove old listeners to prevent duplicates if called twice
        const newMenu = mobileMenu.cloneNode(true);
        mobileMenu.parentNode.replaceChild(newMenu, mobileMenu);
        
        newMenu.addEventListener('click', (e) => {
            e.stopPropagation();
            newMenu.classList.toggle('active');
            navLinks.classList.toggle('active');
        });

        // Accordion toggle
        const navItems = document.querySelectorAll('.nav-links > li > a');
        navItems.forEach(item => {
            const newItem = item.cloneNode(true);
            item.parentNode.replaceChild(newItem, item);
            
            newItem.addEventListener('click', (e) => {
                if (window.innerWidth <= 1080) {
                    const dropdown = newItem.nextElementSibling;
                    if (dropdown && dropdown.classList.contains('dropdown')) {
                        e.preventDefault();
                        newItem.parentElement.classList.toggle('active');
                    }
                }
            });
        });
    }

    // Run immediately
    initMobileMenu();
    // And also on DOMContentLoaded just in case
    document.addEventListener('DOMContentLoaded', initMobileMenu);
})();