document.addEventListener('DOMContentLoaded', () => {
    const librarySection = document.getElementById('library-section');
    const viewerSection = document.getElementById('viewer-section');
    const bookContainer = document.getElementById('book');
    const loading = document.getElementById('loading');
    const loadingText = document.getElementById('loading-text');
    const closeViewerBtn = document.getElementById('close-viewer');
    const prevBtn = document.getElementById('prev-btn');
    const nextBtn = document.getElementById('next-btn');
    const pageInfo = document.getElementById('page-info');

    let pageFlip = null;
    let pdfDoc = null;

    const manuals = [
        { name: '부스터펌프', pdf: 'assets/manuals/부스터펌프 유지관리지침서.pdf', img: 'assets/booster_pump_new.png' },
        { name: '수중펌프', pdf: 'assets/manuals/수중펌프 유지관리지침서.pdf', img: 'assets/submersible_pump_new.png' },
        { name: '슬러지펌프', pdf: 'assets/manuals/슬러지펌프 유지관리지침서.pdf', img: 'assets/sludge_pump_new.png' },
        { name: '일축나사식 모노펌프', pdf: 'assets/manuals/일축나사식 모노펌프 유지관리지침서.pdf', img: 'assets/mono_pump_new.png' },
        { name: '편흡입볼류트펌프', pdf: 'assets/manuals/편흡입볼류트펌프 유지관리지침서.pdf', img: 'assets/volute_pump_new.png' },
        { name: '정량펌프', pdf: 'assets/manuals/정량펌프 유지관리지침서.pdf', img: 'assets/metering_pump_new.png' }
    ];

    // Initialize Library Grid
    function initLibrary() {
        librarySection.innerHTML = '';
        manuals.forEach(manual => {
            const card = document.createElement('div');
            card.className = 'manual-card';
            card.innerHTML = `
                <img src="${manual.img}" alt="${manual.name}">
                <h3>${manual.name}</h3>
                <span class="read-btn">지침서 읽기</span>
            `;
            card.onclick = () => openViewer(manual);
            librarySection.appendChild(card);
        });
    }

    async function openViewer(manual) {
        librarySection.style.display = 'none';
        viewerSection.style.display = 'block';
        window.scrollTo({ top: 0, behavior: 'smooth' });
        await loadPdf(manual.pdf);
    }

    closeViewerBtn.onclick = () => {
        viewerSection.style.display = 'none';
        librarySection.style.display = 'grid';
        if (pageFlip) pageFlip.destroy();
        bookContainer.innerHTML = '';
    };

    async function loadPdf(url) {
        loading.style.display = 'block';
        bookContainer.innerHTML = '';
        
        try {
            const loadingTask = pdfjsLib.getDocument(url);
            pdfDoc = await loadingTask.promise;
            
            const totalPages = pdfDoc.numPages;
            loadingText.textContent = `Rendering ${totalPages} pages...`;
            
            for (let i = 1; i <= totalPages; i++) {
                const page = await pdfDoc.getPage(i);
                const viewport = page.getViewport({ scale: 2 }); // Higher scale for better quality
                
                const canvas = document.createElement('canvas');
                const context = canvas.getContext('2d');
                canvas.height = viewport.height;
                canvas.width = viewport.width;
                
                await page.render({ canvasContext: context, viewport: viewport }).promise;
                
                const pageDiv = document.createElement('div');
                pageDiv.className = 'page';
                const img = document.createElement('img');
                img.src = canvas.toDataURL('image/jpeg', 0.9);
                img.style.width = '100%';
                img.style.height = '100%';
                img.style.objectFit = 'contain';
                pageDiv.appendChild(img);
                bookContainer.appendChild(pageDiv);
            }
            
            initPageFlip();
            loading.style.display = 'none';
            
        } catch (error) {
            console.error('Error loading PDF:', error);
            loadingText.textContent = '지침서를 불러오는 데 실패했습니다.';
        }
    }

    function initPageFlip() {
        if (pageFlip) pageFlip.destroy();

        pageFlip = new St.PageFlip(bookContainer, {
            width: 550,
            height: 733,
            size: "stretch",
            minWidth: 315,
            maxWidth: 1000,
            minHeight: 420,
            maxHeight: 1350,
            showCover: true,
            mobileScrollSupport: false
        });

        pageFlip.loadFromHTML(document.querySelectorAll(".page"));

        pageFlip.on('flip', (e) => {
            pageInfo.textContent = `Page ${e.data + 1} of ${pdfDoc.numPages}`;
        });

        prevBtn.onclick = () => pageFlip.flipPrev();
        nextBtn.onclick = () => pageFlip.flipNext();
        
        pageInfo.textContent = `Page 1 of ${pdfDoc.numPages}`;
    }

    initLibrary();

    // Handle direct links from management.html
    const urlParams = new URLSearchParams(window.location.search);
    const initialPdf = urlParams.get('pdf');
    if (initialPdf) {
        const manual = manuals.find(m => m.pdf === initialPdf);
        if (manual) {
            openViewer(manual);
        } else {
            // Fallback for direct path
            openViewer({ pdf: initialPdf });
        }
    }
});
