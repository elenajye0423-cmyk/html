const fs = require('fs');
const path = require('path');

const baseDir = 'c:\\Users\\elena\\OneDrive\\바탕 화면\\5월6일\\홈페이지자료\\Batech_Web';
const files = fs.readdirSync(baseDir).filter(f => f.endsWith('.html'));

const mapping = {
    'intro.html': '기업소개',
    'greetings.html': '기업소개',
    'sales_history.html': '기업소개',
    'organization.html': '기업소개',
    'certifications.html': '기업소개',
    'rd.html': '기업소개',
    'map.html': '기업소개',
    'product.html': '주요제품',
    'product_supply.html': '주요제품',
    'product_drainage.html': '주요제품',
    'product_industrial.html': '주요제품',
    'notice.html': '고객지원',
    'management.html': '고객지원',
    'technical.html': '고객지원',
    'faq.html': '고객지원',
    'video.html': '홍보센터',
    'ir.html': '홍보센터',
    'careers.html': '채용',
    'inquiry.html': '문의'
};

files.forEach(file => {
    let content = fs.readFileSync(path.join(baseDir, file), 'utf8');
    const targetMenu = mapping[file];
    
    if (targetMenu) {
        // Remove existing active classes from top-level nav links in this file
        content = content.replace(/class="active"/g, (match, offset) => {
            // Check if it's within <ul class="nav-links">
            const prevText = content.substring(0, offset);
            const navLinksStart = prevText.lastIndexOf('<ul class="nav-links">');
            const navLinksEnd = prevText.lastIndexOf('</ul>'); // This is tricky if there are nested uls
            
            // Simpler approach: replace only if it's on a top-level link
            // We'll just replace all class="active" on nav items first, then re-add
            return '';
        });
        
        // Clean up any remaining space like <a href="..."  >
        content = content.replace(/<a\s+([^>]+)\s+class=""/g, '<a $1');
        
        // Find the specific menu item and add active class
        const menuRegex = new RegExp(`<a\\s+([^>]+)>${targetMenu}</a>`, 'g');
        content = content.replace(menuRegex, (match, p1) => {
            if (p1.includes('class=')) {
                return `<a ${p1.replace(/class="[^"]*"/, 'class="active"')}>${targetMenu}</a>`;
            } else {
                return `<a ${p1} class="active">${targetMenu}</a>`;
            }
        });
        
        // Special case for sub-nav links which also use class="active"
        // Let's restore those if they were removed
        // Actually my replace(/class="active"/g) might have broken sub-nav active classes.
        // Let's rethink.
    }
});
