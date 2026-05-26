
// Shared Background Music Control Logic - Ultra Robust Persistence
function initBackgroundMusic() {
    const bgMusic = document.getElementById('bg-music');
    const musicToggle = document.getElementById('music-toggle');
    const volumeSlider = document.getElementById('volume-slider');

    // Only run music logic if elements exist
    if (bgMusic && musicToggle && volumeSlider) {
        // --- 1. Loop (Refill) Setting ---
        bgMusic.loop = true; // Ensure repeating playback

        // --- 2. Restoration Logic ---
        const savedTime = sessionStorage.getItem('bgm_currentTime');
        const savedPaused = sessionStorage.getItem('bgm_paused');
        const savedVolume = sessionStorage.getItem('bgm_volume');
        const savedTimestamp = sessionStorage.getItem('bgm_timestamp');

        // Restoration with millisecond precision to eliminate gaps
        if (savedTime && savedTimestamp && savedPaused !== 'true') {
            const timeElapsed = (Date.now() - parseInt(savedTimestamp)) / 1000;
            
            // If metadata is already loaded, we can modulo the duration
            if (bgMusic.duration) {
                bgMusic.currentTime = (parseFloat(savedTime) + timeElapsed) % bgMusic.duration;
            } else {
                // Wait for metadata to be loaded for accurate duration-based calculation
                bgMusic.addEventListener('loadedmetadata', () => {
                    bgMusic.currentTime = (parseFloat(savedTime) + timeElapsed) % bgMusic.duration;
                }, { once: true });
                // Fallback for immediate set
                bgMusic.currentTime = parseFloat(savedTime);
            }
        } else if (savedTime) {
            bgMusic.currentTime = parseFloat(savedTime);
        }
        
        // Set volume (10% default if never set, otherwise use saved)
        const initialVolume = savedVolume !== null ? parseFloat(savedVolume) : 0.1;
        bgMusic.volume = initialVolume;
        volumeSlider.value = initialVolume;

        const updateToggleIcon = () => {
            musicToggle.textContent = bgMusic.paused ? '▶' : '⏸';
        };

        // --- 3. Immediate & Continuous State Saving ---
        const saveState = () => {
            sessionStorage.setItem('bgm_currentTime', bgMusic.currentTime);
            sessionStorage.setItem('bgm_paused', bgMusic.paused);
            sessionStorage.setItem('bgm_volume', bgMusic.volume);
            sessionStorage.setItem('bgm_timestamp', Date.now());
        };

        // Save state on every link click or page change
        window.addEventListener('pagehide', saveState);
        window.addEventListener('visibilitychange', () => {
            if (document.visibilityState === 'hidden') saveState();
        });
        
        // High-frequency save for near-perfect continuity
        setInterval(saveState, 200);

        // --- 4. Auto-Play & Interaction Logic ---
        const tryPlay = () => {
            if (savedPaused === 'true') {
                updateToggleIcon();
                return;
            }

            bgMusic.play().then(() => {
                updateToggleIcon();
                removeAllTriggers();
            }).catch(() => {
                // Wait for interaction if blocked
                updateToggleIcon();
            });
        };

        const handleInteraction = () => {
            if (bgMusic.paused && savedPaused !== 'true') {
                tryPlay();
            } else {
                removeAllTriggers();
            }
        };

        const triggers = ['mousedown', 'keydown', 'touchstart', 'scroll', 'click'];
        const removeAllTriggers = () => {
            triggers.forEach(event => window.removeEventListener(event, handleInteraction));
        };
        
        triggers.forEach(event => window.addEventListener(event, handleInteraction, { passive: true }));

        // Try initial play
        tryPlay();

        // --- 5. Control Event Listeners ---
        musicToggle.addEventListener('click', (e) => {
            e.stopPropagation();
            if (bgMusic.paused) {
                bgMusic.play();
            } else {
                bgMusic.pause();
            }
            updateToggleIcon();
            saveState();
        });

        volumeSlider.addEventListener('input', (e) => {
            bgMusic.volume = e.target.value;
            saveState();
        });

        // --- 6. Media Sync Logic ---
        const videos = document.querySelectorAll('video');
        videos.forEach(video => {
            if (video.id !== 'bg-music') {
                video.addEventListener('play', () => {
                    if (!bgMusic.paused) {
                        bgMusic.pause();
                        updateToggleIcon();
                        bgMusic.dataset.pausedByVideo = "true";
                    }
                });
                ['pause', 'ended'].forEach(ev => {
                    video.addEventListener(ev, () => {
                        if (bgMusic.dataset.pausedByVideo === "true") {
                            bgMusic.play();
                            updateToggleIcon();
                            delete bgMusic.dataset.pausedByVideo;
                        }
                    });
                });
            }
        });
    }
}

function initNavigation() {
    const mobileMenu = document.getElementById('mobile-menu');
    const navLinks = document.querySelector('.nav-links');
    const navItems = document.querySelectorAll('.nav-item');
    const navbar = document.getElementById('navbar');

    if (mobileMenu && navLinks) {
        // Toggle Main Menu
        mobileMenu.addEventListener('click', (e) => {
            e.stopPropagation();
            const isOpen = navLinks.classList.contains('active');
            
            mobileMenu.classList.toggle('active');
            navLinks.classList.toggle('active');
            
            // Prevent body scroll when menu is open
            document.body.style.overflow = isOpen ? '' : 'hidden';
        });

        // Unified Toggle for Sub-menus (Mobile Only)
        navItems.forEach(item => {
            const link = item.querySelector('a');
            if (link) {
                link.addEventListener('click', (e) => {
                    if (window.innerWidth <= 1080) {
                        const dropdown = item.querySelector('.dropdown');
                        if (dropdown) {
                            // Only prevent default if it's a category with sub-items
                            e.preventDefault();
                            e.stopPropagation();
                            
                            const isActive = item.classList.contains('active');
                            
                            // Toggle current menu
                            item.classList.toggle('active');
                            
                            // Optional: Close other menus (Accordion style)
                            navItems.forEach(otherItem => {
                                if (otherItem !== item) otherItem.classList.remove('active');
                            });
                        }
                    }
                });
            }
        });

        // Close menu when clicking outside
        document.addEventListener('click', (e) => {
            if (navLinks.classList.contains('active')) {
                if (!navLinks.contains(e.target) && !mobileMenu.contains(e.target)) {
                    mobileMenu.classList.remove('active');
                    navLinks.classList.remove('active');
                    document.body.style.overflow = '';
                    navItems.forEach(item => item.classList.remove('active'));
                }
            }
        });
    }
}

document.addEventListener('DOMContentLoaded', () => {
    initBackgroundMusic();
    initNavigation();
    
    // Navbar Scroll Logic
    const navbarScroll = document.getElementById('navbar');
    if (navbarScroll) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 50) { navbarScroll.classList.add('scrolled'); }
            else { navbarScroll.classList.remove('scrolled'); }
        });
        // Trigger once on load in case the page is already scrolled
        if (window.scrollY > 50) navbarScroll.classList.add('scrolled');
    }
});
